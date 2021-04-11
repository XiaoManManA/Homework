package eud.geekbang.xmm.week004;

import java.util.concurrent.atomic.AtomicReference;

/**
 * @author XiaoManMan
 */
public class SleepTest {

    public static void main(String[] args) throws InterruptedException {
        // 通过让主线程等待的方式获取到返回值，简单粗暴家人们都爱用
        AtomicReference<String> result = new AtomicReference<>();
        Thread t1 = new Thread(()->{
            result.set("hi，manman");
        });
        t1.start();
        Thread.sleep(1000L);
        System.out.println(result.get());
    }
}
