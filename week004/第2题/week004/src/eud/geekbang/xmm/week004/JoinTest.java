package eud.geekbang.xmm.week004;

import java.util.concurrent.atomic.AtomicReference;

/**
 * @author XiaoManMan
 */
public class JoinTest {

    public static void main(String[] args) throws InterruptedException {
        // join 方法必须等 thread 执行完成后才能进行下一步
        AtomicReference<String> result = new AtomicReference<>("");
        Thread t1 = new Thread(()->{
            result.set("hi，manman");
        });
        t1.start();
        t1.join();
        System.out.println(result.get());
    }

}
