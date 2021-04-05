package edu.geekbang.xmm.week003.router;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Random;

public class RandomHttpEndpointRouter implements HttpEndpointRouter {

    private static Logger logger = LoggerFactory.getLogger(RandomHttpEndpointRouter.class);

    @Override
    public String route(List<String> urls) {
        logger.info("route...");
        int size = urls.size();
        Random random = new Random(System.currentTimeMillis());
        return urls.get(random.nextInt(size));
    }
}
