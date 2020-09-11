//
//  NWListener+Listener.swift
//  Network
//
//  Created by Brandon Wiley on 9/4/18.
//

import Foundation
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Network
#elseif os(Linux)
    import NetworkLinux
#endif

extension NWListener: Listener
{
    public var newTransportConnectionHandler: ((Connection) -> Void)?
    {
        get
        {
            guard let handler = self.newConnectionHandler
                else
            {
                return nil
            }
            
            return
                {
                    (newConnection: Connection) in
                    
                    guard let connection = newConnection as? NWConnection
                        else
                    {
                        return
                    }
                    
                    handler(connection)
                    
                }
        }
        
        set(newHandler)
        {
            if newHandler == nil
            {
                self.newConnectionHandler = nil
            }
            else
            {
                let handler = newHandler!
                self.newConnectionHandler = {
                    (connection: NWConnection) in
                    
                    handler(connection)
                }
            }
        }
    }
}
