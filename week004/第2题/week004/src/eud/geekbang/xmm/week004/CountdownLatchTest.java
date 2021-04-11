package eud.geekbang.xmm.week004;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicReference;

/**
 * @author XiaoManMan
 */
public class CountdownLatchTest {

    public static void main(String[] args) throws InterruptedException {
        // CountdownLatch 可以阻塞主线程，N 个子线程满足条件时主线程继续。
        CountDownLatch countDownLatch = new CountDownLatch(1);
        AtomicReference<String> result = new AtomicReference<>();
        Thread t1 = new Thread(()->{
            result.set("hi，manman");
            // 等待数减少 1
            countDownLatch.countDown();
        });
        t1.start();
        // 阻塞
        countDownLatch.await();
        System.out.println(result.get());
    }

}
