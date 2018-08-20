//
//  IPv4Address.swift
//  Transport
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation

public struct IPv4Address
{
    public var address: String
    
    public init?(_ address: String)
    {
        self.address=address
    }
}
