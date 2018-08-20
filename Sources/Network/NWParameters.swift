//
//  NWParameters.swift
//  TransportPackageDescription
//
//  Created by Brandon Wiley on 6/12/18.
//

import Foundation

public class NWParameters
{
    public class ProtocolStack
    {
        public var applicationProtocols: [NWProtocolOptions]
        public var internetProtocol: NWProtocolOptions?
        public var transportProtocol: NWProtocolOptions?
        
        public init()
        {
            applicationProtocols=[]
            internetProtocol=nil
            transportProtocol=nil
        }
    }
        
    public class var udp: NWParameters
    {
        get
        {
            return NWParameters(dtls: nil, udp: NWProtocolUDP.Options())
        }
    }
    public class var tcp: NWParameters
    {
        get
        {
            return NWParameters(tls: nil, tcp: NWProtocolTCP.Options())
        }
    }
    
    public var defaultProtocolStack: ProtocolStack
    
    public init()
    {
        defaultProtocolStack=ProtocolStack()
    }
    
    public init(dtls: NWProtocolTLS.Options?, udp: NWProtocolUDP.Options)
    {
        defaultProtocolStack=ProtocolStack()
        defaultProtocolStack.internetProtocol=NWProtocolUDP.Options()
    }
    
    public init(tls: NWProtocolTLS.Options?, tcp: NWProtocolTCP.Options)
    {
        defaultProtocolStack=ProtocolStack()
        defaultProtocolStack.internetProtocol=NWProtocolTCP.Options()
    }
}
