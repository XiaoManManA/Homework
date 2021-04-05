@[toc]
## 测试环境
> java -jar -Xloggc:????-gc.log -XX:+PrintGCDetails
> -XX:+PrintGCDateStamps -Xms4G -Xmx4G -XX:+Use???? gateway-server-0.0.1-SNAPSHOT.jar

堆内存分配4g，使用wrk压测。8个线程40个并发连接60秒时间。
## SerialGC（串行GC）
### WRK Response

> Running 1m test @ http://localhost:8088/api/hello
  8 threads and 40 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    36.60ms  177.98ms   1.57s    96.13%
    Req/Sec     4.00k     1.51k    9.65k    64.89%
  1815140 requests in 1.00m, 216.71MB read
Requests/sec:  30228.14
Transfer/sec:      3.61MB
### GC和堆内存分析
#### GC情况
gc总次数为45次，暂停次数45次，最长gc暂停时间是130毫秒，暂停总时间400毫秒。

可以看出这里最长gc暂停时间是比较长的。

#### 堆内存情况
> CommandLine flags: -XX:InitialHeapSize=4294967296 -XX:MaxHeapSize=4294967296 -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseSerialGC 

初始化堆内存和最大堆内存都是 4G，没有看到在命令行显式设置年轻代和老年代

> Heap
 def new generation   total 1258304K, used 1069385K [0x00000006c0000000, 0x0000000715550000, 0x0000000715550000)
  eden space 1118528K,  95% used [0x00000006c0000000, 0x0000000701436188, 0x0000000704450000)
  from space 139776K,   0% used [0x000000070ccd0000, 0x000000070ccec5c0, 0x0000000715550000)
  to   space 139776K,   0% used [0x0000000704450000, 0x0000000704450000, 0x000000070ccd0000)
 tenured generation   total 2796224K, used 37099K [0x0000000715550000, 0x00000007c0000000, 0x00000007c0000000)
   the space 2796224K,   1% used [0x0000000715550000, 0x000000071798adc0, 0x000000071798ae00, 0x00000007c0000000)
 Metaspace       used 36726K, capacity 38826K, committed 39128K, reserved 1083392K
  class space    used 4604K, capacity 4954K, committed 5080K, reserved 1048576K

分析得出：
年轻代分配了 1228mb 左右内存，使用了 1044mb 左右内存，使用率为 85%。
老年代分配了 2730mb 左右内存，使用了 36mb 左右内存，使用率为 1% 不到。
元数据区当前分配了 38mb 左右内存，使用了 36mb 左右内存，其中 class space 使用了 4.5mb 内存。（这里的class space不好理解，看名称似乎是存放类信息的，和Copressed Class Space重合了？）

### 个人总结
#### 垃圾收集器介绍
串行GC对年轻代使用 mark-copy（标记-复制） 算法，对老年代使用 mark-sweep-compact（标记- 清除-整理） 算法。
两者都是单线程的垃圾收集器，不能进行并行处理，所以都会触发全线暂停（STW），停止所有的应用线程。因此这种GC算法不能充分利用多核CPU。不管有多少CPU内核，JVM 在垃圾收集时都只能使用单个核心。

#### 适用场景
只适合几百MB堆内存的JVM，而且是单核CPU时比较有用。 

## ParallelGC（并行GC）
### WRK Response
> Running 1m test @ http://localhost:8088/api/hello
  8 threads and 40 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    10.23ms   35.19ms 442.17ms   93.23%
    Req/Sec     4.39k     1.68k    9.19k    67.82%
  2035782 requests in 1.00m, 243.05MB read
Requests/sec:  33906.44
Transfer/sec:      4.05MB

### GC和堆内存分析
#### GC情况
gc总次数为44次，暂停次数44次，最长暂停时间是50毫秒，暂停总时间是220毫秒。

可以看出这里总的暂停时间比串行GC减少了一倍。

#### 堆内存情况
> CommandLine flags: -XX:InitialHeapSize=4294967296 -XX:MaxHeapSize=4294967296 -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseParallelGC 

初始化堆内存和最大堆内存都是 4G，没有看到在命令行显式设置年轻代和老年代。

> Heap
 PSYoungGen      total 1393152K, used 549155K [0x000000076ab00000, 0x00000007c0000000, 0x00000007c0000000)
  eden space 1388032K, 39% used [0x000000076ab00000,0x000000078c308d00,0x00000007bf680000)
  from space 5120K, 5% used [0x00000007bfb00000,0x00000007bfb40000,0x00000007c0000000)
  to   space 4608K, 0% used [0x00000007bf680000,0x00000007bf680000,0x00000007bfb00000)
 ParOldGen       total 2796544K, used 29912K [0x00000006c0000000, 0x000000076ab00000, 0x000000076ab00000)
  object space 2796544K, 1% used [0x00000006c0000000,0x00000006c1d36070,0x000000076ab00000)
 Metaspace       used 36616K, capacity 38568K, committed 38744K, reserved 1083392K
  class space    used 4572K, capacity 4901K, committed 4952K, reserved 1048576K

分析得出：
年轻代分配了 1360.5mb 内存，使用了 526.28mb 内存，使用率为 38.6%。
老年代分配了 2731mb 内存，使用了 29.21mb 内存，使用率为 1% 左右。
元数据区分配了 37.66mb 内存，使用了 35.7mb 内存。

### 个人总结
#### 垃圾收集器介绍
并行垃圾收集器这一类组合，在年轻代使用 标记-复制（mark-copy）算法 ，在老年代使用 标记-清除- 整理（mark-sweep-compact）算法 。年轻代和老年代的垃圾回收都会触发STW事件，暂停所有的应用线程来执行垃圾收集。两者在执行标记和 复制/整理 阶段时都使用多个线程，因此得名“（Parallel）”。通过并行执行，使得GC时间大幅减少。
#### 适用场景
并行垃圾收集器适用于多核服务器，主要目标是增加吞吐量。因为对系统资源的有效使用，能达到更高的吞吐量。总的暂停时间也会更短。（如果系统主要目标是最低的停顿时间/延迟，应该选择其他垃圾收集器，因为并行垃圾收集器单次暂停时间很容易出现比较长的情况几十几百毫秒）

## CMS（并发GC）
### WRK Response
> Running 1m test @ http://localhost:8088/api/hello
  8 threads and 40 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    10.84ms   41.90ms 630.89ms   94.30%
    Req/Sec     3.59k     1.52k    8.79k    65.15%
  1671281 requests in 1.00m, 199.53MB read
Requests/sec:  27814.71
Transfer/sec:      3.32MB
### GC和堆内存分析
#### GC情况
通过分析日志：gc总次数为85次，最长暂停gc时间为70毫秒？？？暂停总时间是1秒150毫秒。（似乎并没有达到预期的效果，怀疑是参数没有调优）

#### 堆内存情况
> CommandLine flags: -XX:InitialHeapSize=4294967296 -XX:MaxHeapSize=4294967296 -XX:MaxNewSize=697933824 -XX:MaxTenuringThreshold=6 -XX:NewSize=697933824 -XX:OldPLABSize=16 -XX:OldSize=1395867648 -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseConcMarkSweepGC -XX:+UseParNewGC 

可以看出，CMS垃圾收集器的命令行参数比较多，初始化堆内存和最大堆内存都是 4G，设置了年轻代内存为 665.5mb，老年代内存大小为 1331.2mb。老年代 PLAB 区域大小为 16mb。还设置了年轻代和老年代使用不同的垃圾回收器，开启了指针压缩等。

> Heap
 par new generation   total 613440K, used 148165K [0x00000006c0000000, 0x00000006e9990000, 0x00000006e9990000)
  eden space 545344K,  27% used [0x00000006c0000000, 0x00000006c908e940, 0x00000006e1490000)
  from space 68096K,   0% used [0x00000006e5710000, 0x00000006e5732d40, 0x00000006e9990000)
  to   space 68096K,   0% used [0x00000006e1490000, 0x00000006e1490000, 0x00000006e5710000)
 concurrent mark-sweep generation total 3512768K, used 22485K [0x00000006e9990000, 0x00000007c0000000, 0x00000007c0000000)
 Metaspace       used 36614K, capacity 38532K, committed 38764K, reserved 1083392K
  class space    used 4575K, capacity 4905K, committed 5004K, reserved 1048576K

分析得出：
年轻代分配了 599mb 内存，使用了 144.7mb 内存，使用率为 24% 。
老年代分配了 3430mb 内存，使用了 22mb 内存，使用率为 0.06% 。
元数据区分配了 37.6mb 内存，使用了 25.7 mb 内存。

### 个人总结
#### 垃圾收集器介绍
CMS GC的官方名称为 “Mostly Concurrent Mark and Sweep Garbage Collector”（最大并发-标记-清除-垃圾收集器）。其对年轻代采用并行 STW方式的 mark-copy (标记-复制)算法 ，对老年代主要使用并发 mark-sweep (标记-清除)算法 。

#### 适用场景
CMS GC的设计目标是避免在老年代垃圾收集时出现长时间的卡顿。如果服务器是多核CPU，并且主要调优目标是降低GC停顿导致的系统延迟，那么使用CMS是个很明智的选择。

## G1
### WRK Response
> Running 1m test @ http://localhost:8088/api/hello
  8 threads and 40 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    21.91ms  123.37ms   1.51s    97.35%
    Req/Sec     3.96k     1.48k   11.24k    69.23%
  1821601 requests in 1.00m, 217.48MB read
Requests/sec:  30308.27
Transfer/sec:      3.62MB
#### GC情况
通过分析日志：gc总次数为28次，最长暂停时间为30毫秒，暂停总时间为340毫秒。

#### 堆内存情况
> CommandLine flags: -XX:InitialHeapSize=4294967296 -XX:MaxHeapSize=4294967296 -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseG1GC 

初始化堆内存和最大堆内存都是 4G，没有在命令中显式设置暂停时间等。开启了指针压缩等。

> Heap
 garbage-first heap   total 4194304K, used 679089K [0x00000006c0000000, 0x00000006c0204000, 0x00000007c0000000)
  region size 2048K, 316 young (647168K), 1 survivors (2048K)
 Metaspace       used 36693K, capacity 38814K, committed 39040K, reserved 1083392K
  class space    used 4603K, capacity 4952K, committed 4992K, reserved 1048576K

分析得出：
堆分配了 4G内存，使用了  663mb 内存，使用率为 16% 左右。
每个region 的大小为 2mb，目前年轻代占用了 316 个 region，年轻代使用了 632mb 内存大小。存活区占用了 1 个 region，存活区使用了 2mb 内存大小。
元数据区分配了 37.9mb 内存，使用了 35.8mb 内存。
### 个人总结
#### 垃圾收集器介绍
G1的全称是 Garbage-First ，意为垃圾优先，哪一块的垃圾最多就优先清理。
### 适用场景
G1 GC最主要的设计目标是：将STW停顿的时间和分布，变成可预期且可配置的（有很大概率会满足，但并不完全确定）。G1适合大内存（超过4g），需要较低延迟的场景。

## 整体总结
- 如果系统考虑吞吐量优先，最少的暂停总时间，那么应该考虑ParallelGC（并行GC），这也是JDK8默认的垃圾收集器
- G1作为CMS的替代者出现，如果系统内存堆比较大（超过4g），同时希望较低延迟，平均GC时间可控制，使用G1 GC

G1牛逼。CMS有点迷。ParallelGC吞吐量优先。串行GC单机可以耍。