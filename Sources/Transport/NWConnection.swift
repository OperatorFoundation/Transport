//
//  NetworkConnection.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation

open class NWConnection: Connection
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
        
        public init(completion: @escaping((NWError?) -> Void))
        {
            self = .contentProcessed(completion)
        }
        
    }
    
    public class ContentContext
    {
        public init()
        {
            //
        }
    }
    
    private var network: URLSessionStreamTask
    
    public init?(host: NWEndpoint.Host, port: NWEndpoint.Port, using: NWParameters)
    {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        guard case let .ipv4(addr) = host else {
            return nil
        }
        
        network = session.streamTask(withHostName: addr.address, port: Int(port.rawValue))
        network.resume()
                
        if let viability = viabilityUpdateHandler {
            viability(true)
        }
        
        if let state = stateUpdateHandler {
            state(.ready)
        }
    }
    
    public func start(queue: DispatchQueue)
    {
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
        if let data = content
        {
            network.write(data, timeout: 0)
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
                completion(nil, context, true, error)
                return
            }
            
            guard data != nil else {
                completion(nil, context, false, nil)
                return
            }
            
            completion(data, context, false, nil)
        }
    }
    
    public func receive(minimumIncompleteLength: Int, maximumLength: Int, completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
    {
        network.readData(ofMinLength: minimumIncompleteLength, maxLength: maximumLength, timeout: 60)
        {
            (data, bool, error) in
            
            guard error == nil else {
                let nwerr = NWError.posix(POSIXErrorCode.ECONNREFUSED)
                completion(nil, nil, true, nwerr)
                return
            }
            
            guard data != nil else {
                completion(nil, nil, false, nil)
                return
            }
            
            completion(data, nil, false, nil)
        }
    }
}
