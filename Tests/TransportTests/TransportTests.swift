import XCTest
@testable import Transport
import Datable
import Net

class TransportTests: XCTestCase {

    static var allTests = [
        ("testTCPConnectionFactory", testTCPConnectionFactory),
        ("testTCPSend", testTCPSend),
        ("testTCPReceive", testTCPReceive)
    ]

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
        let conn = factory.connect(using: .tcp)
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
        let maybeConn = factory.connect(using: .tcp)
        guard let conn = maybeConn else {
            XCTAssertNotNil(maybeConn)
            return
        }
        
        let queue = DispatchQueue(label: "networkTests")
        conn.start(queue: queue)
        
        let data: Data = "GET / HTTP/1.0\n\n".data(using: .ascii)!
        lock.enter()
        conn.send(content: data, contentContext: .defaultMessage, isComplete: true, completion: NWConnection.SendCompletion.contentProcessed({
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
        
        let maybeConn = factory.connect(using: .tcp)
        guard let conn = maybeConn else {
            XCTAssertNotNil(maybeConn)
            return
        }
        
        let queue = DispatchQueue(label: "networkTests")
        conn.start(queue: queue)
        
        let data: Data = "GET / HTTP/1.0\n\n".data(using: .ascii)!
        lock.enter()
        conn.send(content: data, contentContext: .defaultMessage, isComplete: true, completion: NWConnection.SendCompletion.contentProcessed({
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
    
//    func testUDPConnectionFactory() {
//        let maybeAddr = IPv4Address("172.217.9.174")
//        guard let addr = maybeAddr else {
//            XCTAssertNotNil(maybeAddr)
//            return
//        }
//        let host = NWEndpoint.Host.ipv4(addr)
//        let maybePort = NWEndpoint.Port(rawValue: 80)
//        guard let port = maybePort else {
//            XCTAssertNotNil(maybePort)
//            return
//        }
//        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
//        let conn = factory.connect(using: .udp)
//        XCTAssertNotNil(conn)
//    }
//
//    func testUDPSend() {
//        var lock: DispatchGroup
//        lock = DispatchGroup.init()
//
//        let maybeAddr = IPv4Address("172.217.9.174")
//        guard let addr = maybeAddr else {
//            XCTAssertNotNil(maybeAddr)
//            return
//        }
//        let host = NWEndpoint.Host.ipv4(addr)
//        let maybePort = NWEndpoint.Port(rawValue: 80)
//        guard let port = maybePort else {
//            XCTAssertNotNil(maybePort)
//            return
//        }
//        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
//        let maybeConn = factory.connect(using: .udp)
//        guard let conn = maybeConn else {
//            XCTAssertNotNil(maybeConn)
//            return
//        }
//
//        let data: Data = "GET / HTTP/1.0\n\n".data(using: .ascii)!
//        lock.enter()
//        conn.send(content: data, contentContext: .defaultMessage, isComplete: true, completion: NWConnection.SendCompletion.contentProcessed({
//            (maybeError) in
//
//            lock.leave()
//            XCTAssertNil(maybeError)
//        }))
//        lock.wait()
//    }
//
//    func testUDPReceive() {
//        var lock: DispatchGroup
//        lock = DispatchGroup.init()
//
//        let maybeAddr = IPv4Address("172.217.9.174")
//        guard let addr = maybeAddr
//        else
//        {
//            XCTAssertNotNil(maybeAddr)
//            return
//        }
//        let host = NWEndpoint.Host.ipv4(addr)
//        let maybePort = NWEndpoint.Port(rawValue: 80)
//        guard let port = maybePort
//        else
//        {
//            XCTAssertNotNil(maybePort)
//            return
//        }
//        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
//        let maybeConn = factory.connect(using: .udp)
//        guard let conn = maybeConn
//        else
//        {
//            XCTAssertNotNil(maybeConn)
//            return
//        }
//
//        let data: Data = "GET / HTTP/1.0\n\n".data(using: .ascii)!
//        lock.enter()
//        conn.send(content: data,
//                  contentContext: .defaultMessage,
//                  isComplete: true,
//                  completion: NWConnection.SendCompletion.contentProcessed(
//        {
//            (maybeError) in
//
//            guard maybeError==nil
//            else
//            {
//                XCTAssertNil(maybeError)
//                lock.leave()
//                return
//            }
//
//            lock.leave()
//        }))
//        lock.wait()
//
//        lock.enter()
//        conn.receive(minimumIncompleteLength: 1, maximumLength: 1024)
//        {
//            (maybeData, maybeContext, isComplet, maybeError) in
//
//            guard maybeError==nil
//            else
//            {
//                XCTAssertNil(maybeError)
//                lock.leave()
//                return
//            }
//
//            guard let data = maybeData
//            else
//            {
//                XCTAssertNotNil(maybeData)
//                lock.leave()
//                return
//            }
//
//            print("data: \(data)")
//            lock.leave()
//        }
//
//        lock.wait()
//    }
//
//    func testUDPListener()
//    {
//        let serverReady = expectation(description: "Server is ready to accept connections.")
//        let clientConnected = expectation(description: "Connected to server.")
//        let serverConnected = expectation(description: "Connection from client.")
//        let serverReceived = expectation(description: "Server received packet.")
//        //let clientReceived = expectation(description: "Client received packet.")
//
//        let queue = DispatchQueue.global()
//        let maybeListener = try? NWListener(using: .udp, on: NWEndpoint.Port(rawValue: 2079)!)
//        guard let listener = maybeListener else
//        {
//            XCTFail("Could not listen on UDP port")
//            return
//        }
//
//        listener.newConnectionHandler =
//        {
//            newConnection in
//
//            serverConnected.fulfill()
//            newConnection.start(queue: queue)
//
//            newConnection.receive(completion:
//            {
//                (maybeData, maybeContext, isComplete, maybeError) in
//
//                serverReceived.fulfill()
//                newConnection.send(content: "OK".data,
//                                   contentContext: .defaultMessage,
//                                   isComplete: true,
//                                   completion: .idempotent)
//            })
//        }
//
//        listener.stateUpdateHandler =
//        {
//            newState in
//
//            print("new state \(newState)")
//            switch newState
//            {
//                case .ready:
//                    serverReady.fulfill()
//                default:
//                    print("Received unexpected state: \(newState)")
//                    XCTFail()
//                    break
//            }
//        }
//
//        listener.start(queue: queue)
//
//        print("server setup")
//
//        let addr = IPv4Address("127.0.0.1")!
//        let host = NWEndpoint.Host.ipv4(addr)
//        let port = NWEndpoint.Port(rawValue: 2079)!
//        let factory: ConnectionFactory = NetworkConnectionFactory(host: host, port: port)
//        let maybeConn = factory.connect(using: .udp)
//
//        guard maybeConn != nil
//        else
//        {
//            XCTFail()
//            return
//        }
//        clientConnected.fulfill()
//
//        /*
//        let data: Data = "GET / HTTP/1.0\n\n".data
//        let context=NWConnection.ContentContext()
//
//        print("sending")
//        conn.send(content: data, contentContext: context, isComplete: true, completion: NWConnection.SendCompletion.contentProcessed({
//            (maybeError) in
//
//            guard maybeError==nil else {
//                XCTAssertNil(maybeError)
//                return
//            }
//
//            print("sent")
//        }))
//
//        conn.receive(minimumIncompleteLength: 1, maximumLength: 1024)
//        {
//            (maybeData, maybeContext, isComplete, maybeError) in
//
//            guard maybeError==nil else
//            {
//                XCTAssertNil(maybeError)
//                return
//            }
//
//            guard let data = maybeData else
//            {
//                XCTAssertNotNil(maybeData)
//                return
//            }
//
//            print("data: \(data)")
//            clientReceived.fulfill()
//        }
// */
//
//        waitForExpectations(timeout: 5)
//        {
//            (maybeError) in
//
//            if let error = maybeError
//            {
//                print("Expectation completed with error: \(error.localizedDescription)")
//            }
//        }
//    }
}
