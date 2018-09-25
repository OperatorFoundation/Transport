//
//  NWConnection+Connection.swift
//  Transport
//
//  Created by Dr. Brandon Wiley on 8/20/18.
//

import Foundation
import Network

extension NWConnection: Connection
{
    public func receive(completion: @escaping (Data?, NWConnection.ContentContext?, Bool, NWError?) -> Void)
    {
        //FIXME
    }
    
}
