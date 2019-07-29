StartAutoTrack

Feature 

目前支持如下模块的功能：

- KVO
- UnrecognizedSelector
- Container
- Notification

同时支持目前模块拦截和protocol 实现，可对接日志上报模块



KVO

建立一个哈希表，用来保存观察者、keyPath的信息，如果哈希表里已经有了相关的观察者/keyPath信息，那么继续添加观察者的话，就不载进行添加，同样移除观察的时候，也现在哈希表中进行查找，如果存在观察者，keypath信息，那么移除，如果没有的话就不执行相关的移除操作。要实现这样的思路就需要用到methodSwizzle来进行方法交换

 UnrecognizedSelector

参考Runtime中消息转发功能：

    - (id)forwardingTargetForSelector:(SEL)aSelector

Container

目前支持：NSArray/NSMutableArray/NSDictionary/NSMutableDictionary

     [NSArray  startMethodSwizzle];
     [NSMutableArray startMethodSwizzle];
     [NSDictionary startMethodSwizzle];
     [NSMutableDictionary startMethodSwizzle];



Notification

在 iOS8 及以下的操作系统中添加的观察者一般需要在 dealloc 的时候做移除，如果忘记移除，则在发送通知的时候会导致 Crash，iOS9 上系统做了优化， iOS9 之后系统将通知中心持有对象由 assign 变为了weak。此处可以忽略不看。



本文从项目抽离出部分代码，可能会产生未知问题，欢迎issue，增加AutoTrack健壮，谢谢
