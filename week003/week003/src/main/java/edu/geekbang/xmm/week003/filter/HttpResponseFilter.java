package edu.geekbang.xmm.week003.filter;

import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.FullHttpResponse;

/**
 * @author XiaoManMan
 */
public interface HttpResponseFilter {

    /**
     * http response filter
     * @param httpResponse
     * @param ctx
     */
    void filter(FullHttpResponse httpResponse, ChannelHandlerContext ctx);
}
