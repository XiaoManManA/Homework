package edu.geekbang.xmm.week003.inbound;

import edu.geekbang.xmm.week003.filter.DefaultHttpRequestFilter;
import edu.geekbang.xmm.week003.filter.HttpRequestFilter;
import edu.geekbang.xmm.week003.outbound.DefaultHttpOutboundHandler;
import edu.geekbang.xmm.week003.router.HttpEndpointRouter;
import edu.geekbang.xmm.week003.router.RandomHttpEndpointRouter;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.util.ReferenceCountUtil;
import okhttp3.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.*;

/**
 * @author XiaoManMan
 */
public class DefaultHttpInboundHandler extends ChannelInboundHandlerAdapter {

    private static Logger logger = LoggerFactory.getLogger(DefaultHttpInboundHandler.class);

    private ExecutorService proxyService;
    private HttpRequestFilter requestFilter = new DefaultHttpRequestFilter();
    private HttpEndpointRouter httpEndpointRouter = new RandomHttpEndpointRouter();
    private DefaultHttpOutboundHandler defaultHttpOutboundHandler = new DefaultHttpOutboundHandler();
    private List<String> backendUrls;
    public DefaultHttpInboundHandler(List<String> backendUrls) {
        this.backendUrls = backendUrls;
        this.initProxyService();
    }

    private void initProxyService() {
        int cores = Runtime.getRuntime().availableProcessors();
        long keepAliveTime = 1000;
        int queueSize = 2048;
        RejectedExecutionHandler handler = new ThreadPoolExecutor.CallerRunsPolicy();
        proxyService = new ThreadPoolExecutor(cores, cores,
                keepAliveTime, TimeUnit.MILLISECONDS, new ArrayBlockingQueue<>(queueSize),
                new NamedThreadFactory("proxyService"), handler);
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) {
        try {
            logger.info("channelRead...");
            // Do something with msg
            FullHttpRequest fullHttpRequest = (FullHttpRequest) msg;
            requestFilter.filter(fullHttpRequest, ctx);
            // Random Router
            final String backendUrl = httpEndpointRouter.route(backendUrls);
            proxyService.submit(()-> {
                final String result = okHttpClientFetchGet(backendUrl);
                defaultHttpOutboundHandler.handler(ctx, fullHttpRequest, result);
            });
        } finally {
            ReferenceCountUtil.release(msg);
        }
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        // Close the connection when an exception is raised.
        cause.printStackTrace();
        ctx.close();
    }

    private String okHttpClientFetchGet(String url) {
        String result = null;
        OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder().url(url).build();
        try (Response response = client.newCall(request).execute()) {
            result = response.body().string();
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
        return result;
    }

}
