//
//  NWConnection+Connection.swift
//  Transport
//
//  Created by Dr. Brandon Wiley on 8/20/18.
//

import Foundation
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Network
#elseif os(Linux)
    import NetworkLinux
#endif

extension NWConnection: Connection
{
    public func receive(completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
    {
        //FIXME
    }
    
}
