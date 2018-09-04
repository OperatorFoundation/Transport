//
//  Listener.swift
//  Transport
//
//  Created by Brandon Wiley on 9/4/18.
//

import Foundation
import Network

protocol Listener
{
    init(using: NWParameters, on: NWEndpoint.Port) throws
    
    var debugDescription: String { get }
    var newConnectionHandler: ((NWConnection) -> Void)? { get set }
    var parameters: NWParameters { get }
    var port: NWEndpoint.Port? { get }
    var queue: DispatchQueue? { get }
    var stateUpdateHandler: ((NWListener.State) -> Void)? { get set }
    
    func start(queue: DispatchQueue)
    func cancel()
}
