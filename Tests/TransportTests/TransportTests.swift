import XCTest
@testable import Transport
//import Datable

class TransportTests: XCTestCase {
    func testTCPConnectionFactory() {
        let maybeAddr = IPv4Address("172.217.9.174")
        guard let addr = maybeAddr else {
            XCTAssertNotNil(maybeAddr)
            return
        }
        let host = NWEndpoint.Host.ipv4(addr)
        let maybePort = NWEndpoint.Port(rawValue: 80)
        guard let port = maybePort else {
            XCTAssertNotNil(maybePort)
            return
        }
        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
        let params = NWParameters()
        let conn = factory.connect(params)
        XCTAssertNotNil(conn)
    }
    
    func testTCPSend() {
        var lock: DispatchGroup
        lock = DispatchGroup.init()
        
        let maybeAddr = IPv4Address("172.217.9.174")
        guard let addr = maybeAddr else {
            XCTAssertNotNil(maybeAddr)
            return
        }
        let host = NWEndpoint.Host.ipv4(addr)
        let maybePort = NWEndpoint.Port(rawValue: 80)
        guard let port = maybePort else {
            XCTAssertNotNil(maybePort)
            return
        }
        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
        let params = NWParameters()
        let maybeConn = factory.connect(params)
        guard let conn = maybeConn else {
            XCTAssertNotNil(maybeConn)
            return
        }

        let data: Data = "GET / HTTP/1.0\n\n".data(using: .ascii)!
        let context=NWConnection.ContentContext()
        lock.enter()
        conn.send(content: data, contentContext: context, isComplete: true, completion: NWConnection.SendCompletion.contentProcessed({
            (maybeError) in
            
            lock.leave()
            XCTAssertNil(maybeError)
        }))
        lock.wait()
    }

    func testTCPReceive() {
        var lock: DispatchGroup
        lock = DispatchGroup.init()
        
        let maybeAddr = IPv4Address("172.217.9.174")
        guard let addr = maybeAddr else {
            XCTAssertNotNil(maybeAddr)
            return
        }
        let host = NWEndpoint.Host.ipv4(addr)
        let maybePort = NWEndpoint.Port(rawValue: 80)
        guard let port = maybePort else {
            XCTAssertNotNil(maybePort)
            return
        }
        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
        let params = NWParameters()
        let maybeConn = factory.connect(params)
        guard let conn = maybeConn else {
            XCTAssertNotNil(maybeConn)
            return
        }
        
        let data: Data = "GET / HTTP/1.0\n\n".data(using: .ascii)!
        let context=NWConnection.ContentContext()
        lock.enter()
        conn.send(content: data, contentContext: context, isComplete: true, completion: NWConnection.SendCompletion.contentProcessed({
            (maybeError) in
            
            guard maybeError==nil else {
                XCTAssertNil(maybeError)
                lock.leave()
                return
            }
            
            lock.leave()
        }))
        lock.wait()

        lock.enter()
        conn.receive(minimumIncompleteLength: 1, maximumLength: 1024) {
            (maybeData, maybeContext, isComplet, maybeError) in
            
            guard maybeError==nil else {
                XCTAssertNil(maybeError)
                lock.leave()
                return
            }
            
            guard let data = maybeData else {
                XCTAssertNotNil(maybeData)
                lock.leave()
                return
            }
            
            print("data: \(data)")
            lock.leave()
        }
        
        lock.wait()
    }
    
    func testUDPConnectionFactory() {
        let maybeAddr = IPv4Address("172.217.9.174")
        guard let addr = maybeAddr else {
            XCTAssertNotNil(maybeAddr)
            return
        }
        let host = NWEndpoint.Host.ipv4(addr)
        let maybePort = NWEndpoint.Port(rawValue: 80)
        guard let port = maybePort else {
            XCTAssertNotNil(maybePort)
            return
        }
        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
        let conn = factory.connect(.udp)
        XCTAssertNotNil(conn)
    }
    
    func testUDPSend() {
        var lock: DispatchGroup
        lock = DispatchGroup.init()
        
        let maybeAddr = IPv4Address("172.217.9.174")
        guard let addr = maybeAddr else {
            XCTAssertNotNil(maybeAddr)
            return
        }
        let host = NWEndpoint.Host.ipv4(addr)
        let maybePort = NWEndpoint.Port(rawValue: 80)
        guard let port = maybePort else {
            XCTAssertNotNil(maybePort)
            return
        }
        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
        let maybeConn = factory.connect(.udp)
        guard let conn = maybeConn else {
            XCTAssertNotNil(maybeConn)
            return
        }
        
        let data: Data = "GET / HTTP/1.0\n\n".data(using: .ascii)!
        let context=NWConnection.ContentContext()
        lock.enter()
        conn.send(content: data, contentContext: context, isComplete: true, completion: NWConnection.SendCompletion.contentProcessed({
            (maybeError) in
            
            lock.leave()
            XCTAssertNil(maybeError)
        }))
        lock.wait()
    }
    
    func testUDPReceive() {
        var lock: DispatchGroup
        lock = DispatchGroup.init()
        
        let maybeAddr = IPv4Address("172.217.9.174")
        guard let addr = maybeAddr else {
            XCTAssertNotNil(maybeAddr)
            return
        }
        let host = NWEndpoint.Host.ipv4(addr)
        let maybePort = NWEndpoint.Port(rawValue: 80)
        guard let port = maybePort else {
            XCTAssertNotNil(maybePort)
            return
        }
        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
        let maybeConn = factory.connect(.udp)
        guard let conn = maybeConn else {
            XCTAssertNotNil(maybeConn)
            return
        }
        
        let data: Data = "GET / HTTP/1.0\n\n".data(using: .ascii)!
        let context=NWConnection.ContentContext()
        lock.enter()
        conn.send(content: data, contentContext: context, isComplete: true, completion: NWConnection.SendCompletion.contentProcessed({
            (maybeError) in
            
            guard maybeError==nil else {
                XCTAssertNil(maybeError)
                lock.leave()
                return
            }
            
            lock.leave()
        }))
        lock.wait()
        
        lock.enter()
        conn.receive(minimumIncompleteLength: 1, maximumLength: 1024) {
            (maybeData, maybeContext, isComplet, maybeError) in
            
            guard maybeError==nil else {
                XCTAssertNil(maybeError)
                lock.leave()
                return
            }
            
            guard let data = maybeData else {
                XCTAssertNotNil(maybeData)
                lock.leave()
                return
            }
            
            print("data: \(data)")
            lock.leave()
        }
        
        lock.wait()
    }
}
