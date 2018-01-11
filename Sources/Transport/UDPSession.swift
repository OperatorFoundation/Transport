//
//  UDPSession.swift
//  Transport
//
//  Created by Brandon Wiley on 1/11/18.
//

import Foundation
import NetworkExtension

extension NWUDPSession: UDPSession {}

public protocol UDPSession {
    var state: NWUDPSessionState { get }
    var isViable: Bool { get }
    
    var resolvedEndpoint: NWEndpoint? { get }
    func tryNextResolvedEndpoint()
    
    func setReadHandler(_ handler: @escaping ([Data]?, Error?) -> Void,
                        maxDatagrams: Int)
    func writeDatagram(_ datagram: Data,
                       completionHandler: @escaping (Error?) -> Void)
    func writeMultipleDatagrams(_ datagramArray: [Data],
                                completionHandler: @escaping (Error?) -> Void)
    var maximumDatagramLength: Int { get }
    
    func cancel()
    
    var hasBetterPath: Bool { get }
    init(upgradeFor session: NWUDPSession)
}
