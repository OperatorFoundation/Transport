//
//  NWConnectionFactory.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Network
#elseif os(Linux)
    import NetworkLinux
#endif

public class NetworkConnectionFactory: ConnectionFactory
{
    public var name: String
    
    public var host: NWEndpoint.Host
    public var port: NWEndpoint.Port
    
    public init(host: NWEndpoint.Host, port: NWEndpoint.Port)
    {
        self.host=host
        self.port=port
        self.name="Network"
    }
    
    public func connect(using parameters: NWParameters) -> Connection?
    {
        let conn = NWConnection(host: host, port: port, using: parameters)
        
        return conn
    }
}
