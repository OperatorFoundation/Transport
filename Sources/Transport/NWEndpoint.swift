//
//  NWEndpoint.swift
//  Transport
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation

public enum NWEndpoint
{
    public enum Host
    {
        case ipv4(IPv4Address)
    }
    
    public struct Port
    {
        var rawValue: UInt16
        
        init?(rawValue: UInt16)
        {
            self.rawValue=rawValue
        }
    }
    
    case hostPort(host: NWEndpoint.Host, port: NWEndpoint.Port)
}
