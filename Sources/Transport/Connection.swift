import Foundation
import Net

public protocol Connection
{
    func start(queue: DispatchQueue)
    func cancel()
    
    var stateUpdateHandler: ((NWConnection.State) -> Void)? { get set }
    var viabilityUpdateHandler: ((Bool) -> Void)? { get set }
    
    func send(content: Data?,
              contentContext: NWConnection.ContentContext,
              isComplete: Bool,
              completion: NWConnection.SendCompletion)
    
    func receive(minimumIncompleteLength: Int, maximumLength: Int, completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
}

