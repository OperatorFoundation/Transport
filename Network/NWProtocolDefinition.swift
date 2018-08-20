//
//  NWProtocolDefinition.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 8/16/18.
//

import Foundation

public class NWProtocolDefinition
{
    public var debugDescription: String
    public let name: String
    
    public init(name: String)
    {
        self.name=name
        debugDescription="NWProtocolDefinition: \(name)"
    }
}
