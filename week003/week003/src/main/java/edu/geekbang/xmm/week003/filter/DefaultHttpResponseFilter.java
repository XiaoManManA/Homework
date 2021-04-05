package edu.geekbang.xmm.week003.filter;

import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.FullHttpResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author XiaoManMan
 */
public class DefaultHttpResponseFilter implements HttpResponseFilter {

    private static Logger logger = LoggerFactory.getLogger(DefaultHttpResponseFilter.class);

    @Override
    public void filter(FullHttpResponse httpResponse, ChannelHandlerContext ctx) {
        logger.info("DefaultHttpResponseFilter filter...");
        httpResponse.headers().add("DefaultHttpResponseFilter", "xmm");
    }
}
