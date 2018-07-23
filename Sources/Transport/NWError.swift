//
//  NWError.swift
//  Transport
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation

public enum NWError
{
    case posix(POSIXErrorCode)
    case tls(OSStatus)
}
