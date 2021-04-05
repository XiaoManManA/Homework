package edu.geekbang.xmm.week003;

import edu.geekbang.xmm.week003.inbound.DefaultHttpInboundHandler;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.buffer.PooledByteBufAllocator;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.epoll.EpollChannelOption;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.http.HttpObjectAggregator;
import io.netty.handler.codec.http.HttpServerCodec;

import java.util.ArrayList;
import java.util.List;

/**
 * @author XiaoManMan
 */
public class Week003Application {

	private final int port;
	private final List<String> backendUrl;

	public Week003Application(int port, List<String> backendUrl) {
		this.port = port;
		this.backendUrl = backendUrl;
	}

	public void run() throws Exception {
		EventLoopGroup bossGroup = new NioEventLoopGroup(1);
		EventLoopGroup workerGroup = new NioEventLoopGroup(8);
		try {
			ServerBootstrap b = new ServerBootstrap();
			b.group(bossGroup, workerGroup)
					.channel(NioServerSocketChannel.class)
					.childHandler(new ChannelInitializer<SocketChannel>() {
						@Override
						public void initChannel(SocketChannel ch) {
							ch.pipeline().addLast(new HttpServerCodec(),
									new HttpObjectAggregator(1024 * 1024),
									new DefaultHttpInboundHandler(backendUrl));
						}
					})
					.option(ChannelOption.SO_BACKLOG, 128)
					.childOption(ChannelOption.TCP_NODELAY, true)
					.childOption(ChannelOption.SO_KEEPALIVE, true)
					.childOption(ChannelOption.SO_REUSEADDR, true)
					.childOption(ChannelOption.SO_RCVBUF, 32 * 1024)
					.childOption(ChannelOption.SO_SNDBUF, 32 * 1024)
					.childOption(EpollChannelOption.SO_REUSEPORT, true)
					.childOption(ChannelOption.SO_KEEPALIVE, true)
					.childOption(ChannelOption.ALLOCATOR, PooledByteBufAllocator.DEFAULT);

			// Bind and start to accept incoming connections.
			ChannelFuture f = b.bind(port).sync();
			// Wait until the server socket is closed.
			// In this example, this does not happen, but you can do that to gracefully
			// shut down your server.
			f.channel().closeFuture().sync();
		} finally {
			workerGroup.shutdownGracefully();
			bossGroup.shutdownGracefully();
		}
	}

	public static void main(String[] args) throws Exception {
		// 1. 声明服务端
		// 2. 声明入站
		// 2.1. 初始化路由表
		// 2.2. 声明线程池
		// 3. 声明出站
		// 4. 编写过滤器类
		int port = 8080;
		List<String> backendUrl = new ArrayList<>(3);
		backendUrl.add("http://localhost:8801");
		backendUrl.add("http://localhost:8802");
		backendUrl.add("http://localhost:8803");
		backendUrl.add("http://localhost:8808/test");
		new Week003Application(port, backendUrl).run();
	}

}
