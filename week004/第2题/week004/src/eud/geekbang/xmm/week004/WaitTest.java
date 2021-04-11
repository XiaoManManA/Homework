package eud.geekbang.xmm.week004;

import java.util.concurrent.atomic.AtomicReference;

/**
 * @author XiaoManMan
 */
public class WaitTest {

    public static void main(String[] args) throws InterruptedException {
        Object lock = new Object();
        /**
         * 设计一把锁，将主线程设置为 wait，在另外一个线程 notify
         * 注意，wait notify 都必须放在 synchronized 同步块里面，否则会抛出异常
         */
        AtomicReference<String> result = new AtomicReference<>();
        Thread t1 = new Thread(() -> {
            synchronized (lock) {
                result.set("hi，manman");
                // 唤醒陷入等待的另外一个线程
                lock.notify();
            }
        });
        t1.start();
        synchronized (lock) {
            // 释放掉锁，让自己陷入等待状态
            lock.wait();
            System.out.println(result.get());
        }
    }

}
