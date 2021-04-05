package edu.geekbang.xmm.week003.filter;

import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.FullHttpRequest;

/**
 * @author XiaoManMan
 */
public interface HttpRequestFilter {

    /**
     * http request filter
     * @param httpRequest
     * @param ctx
     */
    void filter(FullHttpRequest httpRequest, ChannelHandlerContext ctx);
}
