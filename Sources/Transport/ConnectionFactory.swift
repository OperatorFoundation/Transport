//
//  ConnectionFactory.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation
import Network

public protocol ConnectionFactory {
    func connect(_ using: NWParameters) -> Connection?
}
