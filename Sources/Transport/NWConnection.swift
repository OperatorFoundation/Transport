//
//  NWConnection.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation

public class NWConnection
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
        
    }
    
    init(host: NWEndpoint.Host, port: NWEndpoint.Port, using: NWParameters)
    {
        
    }
    
    func start(queue: DispatchQueue)
    {
        
    }
    
    func cancel()
    {
        
    }
    
    var stateUpdateHandler: ((NWConnection.State) -> Void)?
    var viabilityUpdateHandler: ((Bool) -> Void)?

    
    func send(content: Data?, contentContext: NWConnection.ContentContext, isComplete: Bool, completion: NWConnection.SendCompletion)
    {
        
    }
    
    func receive(completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
    {
        
    }
    
    func receive(minimumIncompleteLength: Int, maximumLength: Int, completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
    {
        
    }
}
