//
//  NWConnectionFactory.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation

public class NetworkConnectionFactory: ConnectionFactory
{
    public var host: NWEndpoint.Host
    public var port: NWEndpoint.Port
    
    public init(host: NWEndpoint.Host, port: NWEndpoint.Port)
    {
        self.host=host
        self.port=port
    }
    
    public func connect(_ using: NWParameters) -> Connection?
    {
        let maybeConn = NWConnection(host: host, port: port, using: using)
        guard let conn = maybeConn else {
            return nil
        }
        
        return conn as Connection
    }
}
