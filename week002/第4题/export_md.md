
## 测试环境

> java -jar -Xloggc:????-gc.log -XX:+PrintGCDetails
> -XX:+PrintGCDateStamps -Xms4G -Xmx4G -XX:+Use???? gateway-server-0.0.1-SNAPSHOT.jar

堆内存分配4g，使用wrk压测。8个线程40个并发连接60秒时间。
### SerialGC（串行GC）
### WRK Response

> Running 1m test @ http://localhost:8088/api/hello
  8 threads and 40 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    36.60ms  177.98ms   1.57s    96.13%
    Req/Sec     4.00k     1.51k    9.65k    64.89%
  1815140 requests in 1.00m, 216.71MB read
Requests/sec:  30228.14
Transfer/sec:      3.61MB

#### 介绍
串行GC对年轻代使用 mark-copy（标记-复制） 算法，对老年代使用 mark-sweep-compact（标记- 清除-整理） 算法。
两者都是单线程的垃圾收集器，不能进行并行处理，所以都会触发全线暂停（STW），停止所有的应用线程。因此这种GC算法不能充分利用多核CPU。不管有多少CPU内核，JVM 在垃圾收集时都只能使用单个核心。

#### 适用场景
只适合几百MB堆内存的JVM，而且是单核CPU时比较有用。 

#### GC日志
gc总次数为45次，暂停次数45次，最长gc暂停时间是130毫秒，暂停总时间400毫秒。


###  ParallelGC（并行GC）
### WRK Response

> Running 1m test @ http://localhost:8088/api/hello
  8 threads and 40 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    10.23ms   35.19ms 442.17ms   93.23%
    Req/Sec     4.39k     1.68k    9.19k    67.82%
  2035782 requests in 1.00m, 243.05MB read
Requests/sec:  33906.44
Transfer/sec:      4.05MB

#### 介绍
并行垃圾收集器这一类组合，在年轻代使用 标记-复制（mark-copy）算法 ，在老年代使用 标记-清除- 整理（mark-sweep-compact）算法 。年轻代和老年代的垃圾回收都会触发STW事件，暂停所有的应用线程来执行垃圾收集。两者在执行标记和 复制/整理 阶段时都使用多个线程，因此得名“（Parallel）”。通过并行执行，使得GC时间大幅减少。

#### 适用场景
并行垃圾收集器适用于多核服务器，主要目标是增加吞吐量。因为对系统资源的有效使用，能达到更高的吞吐量。总的暂停时间也会更短。（如果系统主要目标是最低的停顿时间/延迟，应该选择其他垃圾收集器，因为并行垃圾收集器单次暂停时间很容易出现比较长的情况几十几百毫秒）

#### GC日志
gc总次数为44次，暂停次数44次，最长暂停时间是50毫秒，暂停总时间是220毫秒。

### CMS（并发GC）
### WRK Response
> Running 1m test @ http://localhost:8088/api/hello
  8 threads and 40 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    10.84ms   41.90ms 630.89ms   94.30%
    Req/Sec     3.59k     1.52k    8.79k    65.15%
  1671281 requests in 1.00m, 199.53MB read
Requests/sec:  27814.71
Transfer/sec:      3.32MB

#### 介绍
CMS GC的官方名称为 “Mostly Concurrent Mark and Sweep Garbage Collector”（最大并发-标记-清除-垃圾收集器）。其对年轻代采用并行 STW方式的 mark-copy (标记-复制)算法 ，对老年代主要使用并发 mark-sweep (标记-清除)算法 。

#### 适用场景
CMS GC的设计目标是避免在老年代垃圾收集时出现长时间的卡顿。如果服务器是多核CPU，并且主要调优目标是降低GC停顿导致的系统延迟，那么使用CMS是个很明智的选择。

#### GC日志
通过分析日志：gc总次数为85次，最长暂停gc时间为70毫秒？？？暂停总时间是1秒150毫秒。（似乎并没有达到预期的效果，怀疑是参数没有调优）

### G1

> Running 1m test @ http://localhost:8088/api/hello
  8 threads and 40 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    21.91ms  123.37ms   1.51s    97.35%
    Req/Sec     3.96k     1.48k   11.24k    69.23%
  1821601 requests in 1.00m, 217.48MB read
Requests/sec:  30308.27
Transfer/sec:      3.62MB

#### 介绍
G1的全称是 Garbage-First ，意为垃圾优先，哪一块的垃圾最多就优先清理。

#### 适用场景
G1 GC最主要的设计目标是：将STW停顿的时间和分布，变成可预期且可配置的（有很大概率会满足，但并不完全确定）。G1适合大内存（超过4g），需要较低延迟的场景。

#### GC日志
gc总次数为28次，最长暂停时间为30毫秒，暂停总时间为340毫秒。

## 总结
- 如果系统考虑吞吐量优先，最少的暂停总时间，那么应该考虑ParallelGC（并行GC），这也是JDK8默认的垃圾收集器
- G1作为CMS的替代者出现，如果系统内存堆比较大（超过4g），同时希望较低延迟，平均GC时间可控制，使用G1 GC
