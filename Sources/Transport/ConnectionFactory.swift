//
//  ConnectionFactory.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation

public protocol ConnectionFactory {
    func connect(_ using: NWParameters) -> Connection?
}
