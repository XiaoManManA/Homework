package edu.geekbang.xmm.week003.outbound;

import edu.geekbang.xmm.week003.filter.DefaultHttpResponseFilter;
import edu.geekbang.xmm.week003.filter.HttpResponseFilter;
import io.netty.buffer.Unpooled;
import io.netty.channel.*;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.handler.codec.http.HttpUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static io.netty.handler.codec.http.HttpHeaderNames.CONNECTION;
import static io.netty.handler.codec.http.HttpHeaderValues.KEEP_ALIVE;
import static io.netty.handler.codec.http.HttpResponseStatus.NO_CONTENT;
import static io.netty.handler.codec.http.HttpResponseStatus.OK;
import static io.netty.handler.codec.http.HttpVersion.HTTP_1_1;

/**
 * @author XiaoManMan
 */
public class DefaultHttpOutboundHandler {// extends ChannelOutboundHandlerAdapter {

    private static Logger logger = LoggerFactory.getLogger(DefaultHttpOutboundHandler.class);

    HttpResponseFilter responseFilter = new DefaultHttpResponseFilter();

    public void handler(ChannelHandlerContext ctx, FullHttpRequest fullHttpRequest, String result) {
        logger.info("DefaultHttpOutboundHandler handler...");
        FullHttpResponse response = null;
        try {
            response = new DefaultFullHttpResponse(HTTP_1_1, OK, Unpooled.wrappedBuffer(result.getBytes("UTF-8")));
            response.headers().set("Content-Type", "application/json");
            response.headers().setInt("Content-Length", response.content().readableBytes());
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            response = new DefaultFullHttpResponse(HTTP_1_1, NO_CONTENT);
        } finally {
            responseFilter.filter(response, ctx);
            if (fullHttpRequest != null) {
                if (!HttpUtil.isKeepAlive(fullHttpRequest)) {
                    ctx.write(response).addListener(ChannelFutureListener.CLOSE);
                } else {
                    response.headers().set(CONNECTION, KEEP_ALIVE);
                    ctx.write(response);
                }
            }
            ctx.flush();
        }
    }

//    @Override
//    public void write(ChannelHandlerContext ctx, Object msg, ChannelPromise promise) {
//        logger.info("write...");
//        FullHttpResponse fullHttpResponse = (FullHttpResponse) msg;
//        responseFilter.filter(fullHttpResponse, ctx);
//        ctx.write(msg, promise);
//        ctx.flush();
//    }

}
