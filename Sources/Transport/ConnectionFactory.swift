//
//  ConnectionFactory.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation
import Net

public protocol ConnectionFactory {
    
    var name: String { get }
    func connect(using parameters: NWParameters) -> Connection?
}
