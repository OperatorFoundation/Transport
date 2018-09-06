//
//  NetworkConnection.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation
import Dispatch

import SwiftSocket

open class NWConnection
{
    public enum State
    {
        case cancelled
        case failed(NWError)
        case preparing
        case ready
        case setup
        case waiting(NWError)
    }
    
    public enum SendCompletion
    {
        case contentProcessed((NWError?) -> Void)
        case idempotent
    }
    
    public class ContentContext
    {
        public init()
        {
            //
        }
    }
    
    private var usingUDP: Bool
    private var network: URLSessionStreamTask?
    private var client: UDPClient?
    private var queue: DispatchQueue?
    
    public init?(host: NWEndpoint.Host, port: NWEndpoint.Port, using: NWParameters)
    {
        usingUDP = false
        
        if let prot = using.defaultProtocolStack.internetProtocol
        {
            if let _ = prot as? NWProtocolUDP.Options {
                usingUDP = true
            }
        }

        if(usingUDP)
        {
            guard case let .ipv4(addr) = host else {
                return nil
            }
            
            client=UDPClient(address: addr.address, port: Int32(port.rawValue))
        }
        else
        {
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
            guard case let .ipv4(addr) = host else {
                return nil
            }
            
            network = session.streamTask(withHostName: addr.address, port: Int(port.rawValue))
            network?.resume()
        }
        
        if let viability = viabilityUpdateHandler {
            viability(true)
        }
        
        if let state = stateUpdateHandler {
            state(.ready)
        }
    }
    
    public func start(queue: DispatchQueue)
    {
        self.queue=queue
        
        if let viability = viabilityUpdateHandler {
            viability(true)
        }
        
        if let state = stateUpdateHandler {
            state(.ready)
        }
    }
    
    public func cancel()
    {
        if let state = stateUpdateHandler
        {
            state(.cancelled)
        }
    }
    
    public var stateUpdateHandler: ((NWConnection.State) -> Void)?
    public var viabilityUpdateHandler: ((Bool) -> Void)?
    
    public func send(content: Data?, contentContext: NWConnection.ContentContext, isComplete: Bool, completion: NWConnection.SendCompletion)
    {
        if(usingUDP)
        {
            sendUDP(content: content, contentContext: contentContext, isComplete: isComplete, completion: completion)
        }
        else
        {
            sendTCP(content: content, contentContext: contentContext, isComplete: isComplete, completion: completion)
        }
    }

    public func sendUDP(content: Data?, contentContext: NWConnection.ContentContext, isComplete: Bool, completion: NWConnection.SendCompletion)
    {
        guard let data = content else
        {
            switch completion
            {
                case .contentProcessed(let callback):
                    let nwerr = NWError.posix(POSIXErrorCode.ECONNREFUSED)
                    callback(nwerr)
                    return
                case .idempotent:
                    return
            }
        }
        
        let maybeResult = client?.send(data: [UInt8](data))
        guard let result = maybeResult else
        {
            switch completion
            {
            case .contentProcessed(let callback):
                let nwerr = NWError.posix(POSIXErrorCode.ECONNREFUSED)
                callback(nwerr)
                return
            case .idempotent:
                return
            }
        }

        switch completion
        {
            case .contentProcessed(let callback):
                switch(result)
                {
                    case .success:
                        callback(nil)
                    case .failure(let error):
                        print(error)
                        let nwerr = NWError.posix(POSIXErrorCode.ECONNREFUSED)
                        callback(nwerr);
                }
            case .idempotent:
                return
        }
    }
    
    public func sendTCP(content: Data?, contentContext: NWConnection.ContentContext, isComplete: Bool, completion: NWConnection.SendCompletion)
    {
        if let data = content
        {
            network?.write(data, timeout: 0)
            {
                (error) in
                
                switch completion
                {
                    case .contentProcessed(let callback):
                        if error != nil
                        {
                            print(error ?? "nil")
                            let nwerr = NWError.posix(POSIXErrorCode.ECONNREFUSED)
                            callback(nwerr);
                        }
                        else
                        {
                            callback(nil)
                        }
                    case .idempotent:
                        return
                }
            }
        }
    }
    
    public func receive(completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
    {
        receive(minimumIncompleteLength: 1, maximumLength: 1024)
        {
            (data, context, isComplete, error) in
            
            guard error == nil else {
                completion(nil, context, isComplete, error)
                return
            }
            
            guard data != nil else {
                completion(nil, context, isComplete, nil)
                return
            }
            
            completion(data, context, isComplete, nil)
        }
    }
    
    public func receive(minimumIncompleteLength: Int, maximumLength: Int, completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
    {
        if(usingUDP)
        {
            receiveUDP(minimumIncompleteLength: minimumIncompleteLength, maximumLength: maximumLength, completion: completion)
        }
        else
        {
            receiveTCP(minimumIncompleteLength: minimumIncompleteLength, maximumLength: maximumLength, completion: completion)
        }
    }

    public func receiveUDP(minimumIncompleteLength: Int, maximumLength: Int, completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
    {
        queue?.async
        {
            let maybeResult = self.client?.recv(minimumIncompleteLength)
            guard let (maybeBytes, _, _) = maybeResult else
            {
                completion(nil, nil, false, nil)
                return
            }
            
            guard let bytes = maybeBytes else
            {
                completion(nil, nil, false, nil)
                return
            }
            
            completion(Data(bytes), nil, false, nil)
        }
    }
    
    public func receiveTCP(minimumIncompleteLength: Int, maximumLength: Int, completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
    {
        network?.readData(ofMinLength: minimumIncompleteLength, maxLength: maximumLength, timeout: 60)
        {
            (data, bool, error) in
            
            guard error == nil else {
                let nwerr = NWError.posix(POSIXErrorCode.ECONNREFUSED)
                completion(nil, nil, bool, nwerr)
                return
            }
            
            guard data != nil else {
                completion(nil, nil, bool, nil)
                return
            }
            
            completion(data, nil, bool, nil)
        }
    }
}
