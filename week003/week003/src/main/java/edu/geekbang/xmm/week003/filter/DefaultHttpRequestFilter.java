package edu.geekbang.xmm.week003.filter;

import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.FullHttpRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author XiaoManMan
 */
public class DefaultHttpRequestFilter implements HttpRequestFilter {

    private static Logger logger = LoggerFactory.getLogger(DefaultHttpRequestFilter.class);

    @Override
    public void filter(FullHttpRequest httpRequest, ChannelHandlerContext ctx) {
        logger.info("DefaultHttpRequestFilter filter...");
        httpRequest.headers().add("DefaultHttpRequestFilter", "xmm");
    }
}
