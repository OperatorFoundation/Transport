//
//  ConnectionFactory.swift
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

public protocol ConnectionFactory {
    
    var name: String { get }
    func connect(using parameters: NWParameters) -> Connection?
}
