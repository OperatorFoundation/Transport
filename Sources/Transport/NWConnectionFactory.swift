//
//  NWConnectionFactory.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation

class NWConnectionFactory: ConnectionFactory
{
    var host: NWEndpoint.Host
    var port: NWEndpoint.Port
    
    init(host: NWEndpoint.Host, port: NWEndpoint.Port)
    {
        self.host=host
        self.port=port
    }
    
    func connect(_ using: NWParameters) -> Connection?
    {
        let maybeConn = NWConnection(host: host, port: port, using: using)
        guard let conn = maybeConn else {
            return nil
        }
        
        return conn as Connection
    }
}
