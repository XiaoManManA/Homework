package eud.geekbang.xmm.week004;

import java.util.concurrent.*;

/**
 * @author XiaoManMan
 */
public class FutureTest {

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        /*
         * Future，线程池的 submit(Callable task) 方法可以拿到返回值 Future，future.get() 方法是阻塞的, Executors 支持创建四种常见的线程池
         * Executors.newCachedThreadPool()
         * Executors.newSingleThreadExecutor()
         * Executors.newFixedThreadPool(1)
         * Executors.newScheduledThreadPool(1)
         */
        Callable<String> task = () -> "hi，manman";
        ExecutorService executorService = Executors.newScheduledThreadPool(1);
        Future future = executorService.submit(task);
        System.out.println(future.get());
        executorService.shutdown();

        // FutureTask
        FutureTask<String> futureTask = new FutureTask<>(() -> "hi，manman");
        new Thread(futureTask).start();
        System.out.println(futureTask.get());

        // CompletableFuture
        String result = CompletableFuture.supplyAsync(()-> "hi，manman").get();
        System.out.println(result);
    }

}
