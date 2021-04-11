package eud.geekbang.xmm.week004;

import java.util.concurrent.atomic.AtomicReference;
import java.util.concurrent.locks.LockSupport;

/**
 * @author XiaoManMan
 */
public class LockSupportTest {

    public static void main(String[] args) {
        // LockSupport.park 方法可以暂停当前线程
        AtomicReference<String> result = new AtomicReference<>();
        Thread t1 = new Thread(()->{
            result.set("hi，manman");
        });
        t1.start();
        LockSupport.parkNanos(1000L);
        System.out.println(result.get());
    }
}
