//
//  Listener.swift
//  Transport
//
//  Created by Brandon Wiley on 9/4/18.
//

import Foundation
import Net

public protocol Listener
{
    var debugDescription: String { get }
    var newTransportConnectionHandler: ((Connection) -> Void)? { get set }
    var parameters: NWParameters { get }
    var port: NWEndpoint.Port? { get }
    var queue: DispatchQueue? { get }
    var stateUpdateHandler: ((NWListener.State) -> Void)? { get set }
    
    func start(queue: DispatchQueue)
    func cancel()
}
