//
//  NWListener.swift
//  Network
//
//  Created by Brandon Wiley on 9/4/18.
//

import Foundation
import NIO
import Dispatch

public class NWListener
{
    public enum State
    {
        case cancelled
        case failed(NWError)
        case ready
        case setup
        case waiting(NWError)
    }
    
    public var debugDescription: String = "[NWListener]"
    public var newConnectionHandler: ((NWConnection) -> Void)?
    public let parameters: NWParameters
    public var port: NWEndpoint.Port?
    public var queue: DispatchQueue?
    public var stateUpdateHandler: ((NWListener.State) -> Void)?

    private var usingUDP: Bool
    private var channel: Channel?
    
    public required init(using: NWParameters, on: NWEndpoint.Port) throws
    {
        self.parameters=using
        self.port=on
        
        print("Port: \(self.port)")
        
        usingUDP = false
        
        if let prot = using.defaultProtocolStack.internetProtocol
        {
            if let _ = prot as? NWProtocolUDP.Options {
                usingUDP = true
            }
        }
        
        if(usingUDP)
        {
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            let bootstrap = DatagramBootstrap(group: group)
                // Enable SO_REUSEADDR.
                .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
                .channelInitializer
                {
                    channel in
                    
                    channel.pipeline.add(handler: Handler<ByteBuffer>())
                }
            
            defer
            {
                try! group.syncShutdownGracefully()
            }
            
            channel = try! bootstrap.bind(host: "127.0.0.1", port: 2079).wait()
            /* the Channel is now ready to send/receive datagrams */
        }
        else
        {
        }
    }
    
    public func start(queue: DispatchQueue)
    {
        if let state = stateUpdateHandler {
            state(.ready)
        }
        
        queue.async
        {
            do
            {
                try self.channel?.closeFuture.wait()  // Wait until the channel un-binds.
            }
            catch
            {
                print("Failed to wait for unbind")
            }
        }
    }
    
    public func cancel()
    {
        if let state = stateUpdateHandler {
            state(.cancelled)
        }
    }
    
    private class Handler<DataType>: ChannelInboundHandler
    {
        typealias InboundIn = AddressedEnvelope<DataType>
        typealias InboundOut = AddressedEnvelope<DataType>
        
        enum State {
            case fresh
            case registered
            case active
        }
        
        var reads: [AddressedEnvelope<DataType>] = []
        var loop: EventLoop? = nil
        var state: State = .fresh

        var readWaiters: [Int: EventLoopPromise<[AddressedEnvelope<DataType>]>] = [:]
        
        func channelRegistered(ctx: ChannelHandlerContext) {
            print("channel registered")
            self.state = .registered
            self.loop = ctx.eventLoop
        }
        
        func channelActive(ctx: ChannelHandlerContext) {
            print("channel registered")
            self.state = .active
        }
        
        func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
            print("channel read")
            let data = self.unwrapInboundIn(data)
            reads.append(data)
            
            if let promise = readWaiters.removeValue(forKey: reads.count) {
                promise.succeed(result: reads)
            }
            
            ctx.fireChannelRead(self.wrapInboundOut(data))
        }
        
        func notifyForDatagrams(_ count: Int) -> EventLoopFuture<[AddressedEnvelope<DataType>]> {
            print("notify for datagrams")
            guard reads.count < count else {
                return loop!.newSucceededFuture(result: .init(reads.prefix(count)))
            }
            
            readWaiters[count] = loop!.newPromise()
            return readWaiters[count]!.futureResult
        }
    }
}
