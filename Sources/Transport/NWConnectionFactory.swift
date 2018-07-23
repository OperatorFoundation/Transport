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
    var using: NWParameters
    
    init(host: NWEndpoint.Host, port: NWEndpoint.Port, using: NWParameters)
    {
        self.host=host
        self.port=port
        self.using=using
    }
    
    func connect(_ using: NWParameters) -> Connection?
    {
        return NWConnection(host: host, port: port, using: using) as? Connection
    }
}
