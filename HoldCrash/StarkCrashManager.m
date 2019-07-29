//
//  StarkCrashManager.m
//  Stark
//
//  Created by Burke on 2019/7/19.
//  Copyright © 2019 Burke. All rights reserved.
//

#import "StarkCrashManager.h"
#import "NSObject+InterceptCrash.h"
#import "NSObject+InterceptKVOCrash.h"
#import "NSNotificationCenter+InterceptCrash.h"
#import "StarkContainerCrash.h"

@interface StarkCrashManager ()

@property (nonatomic,assign)BOOL isEnabledReporterService;

@end

@implementation StarkCrashManager

+ (void)initialize{
    
}
+ (instancetype)sharedManager{
    static StarkCrashManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [StarkCrashManager new];
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {
        // 注册noti
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCrash:) name:STARK_CRASH_BORN_NOTI_NAME object:nil];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STARK_CRASH_BORN_NOTI_NAME object:nil];
}
- (void)enableCrashReporterService{
    //标记日志上报服务
    //后期准备加入上报接口
    self.isEnabledReporterService = YES;

   
    
}
- (void)enableCrashInterceptService{
   
#ifdef DEBUG
    NSLog(@"===================================\n");
    NSLog(@"enableCrashInterceptService is opened ,please pay attention to Log\n");
    NSLog(@"===================================\n");
#else
    
#endif
    /*
     *! 此处没有对NSObject重写类方法的模式，是因为会产生额外问题，具体参考Method Swizzle 黑魔法问题
     **/
    //1.
    [NSObject interceptObjectCrashInUnrecognizedSelector];
    //2.
    [NSObject interceptObjectCrashInKVO];
    //3.
    if (AboveVersion(9.0)) {
        [NSNotificationCenter interceptObjectCrashInNotification];
    }
    //4.
    [StarkContainerCrash interceptObjectCrashInContainer];
}
#pragma mark - 将要收到crash info 
- (void)willReceiveCrashDetailInfo:(NSNotification *)noti{
    if (self.interceptDelegate && [self.interceptDelegate respondsToSelector:@selector(enableInterceptServiceWillReceiveCrashDetailInfo)]) {
        [self.interceptDelegate enableInterceptServiceWillReceiveCrashDetailInfo];
    }
}

- (void)receiveCrash:(NSNotification *)noti{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 堆栈数据
        NSArray * stackSymbols = [NSThread callStackSymbols];
        NSDictionary * userInfo = noti.userInfo;
        StarkCrashType type = [userInfo[STARK_CRASH_BORN_TYPE_NOTI_KEY] integerValue];
        NSException * exception = noti.object;
        if (self.interceptDelegate && [self.interceptDelegate respondsToSelector:@selector(catchCrashDetailInfoWithName:reason:crashType:callStack:extraInfo:terminateApp:)]) {
            [self.interceptDelegate catchCrashDetailInfoWithName:exception.name reason:exception.reason crashType:type callStack:stackSymbols extraInfo:exception.userInfo terminateApp:NO];
        }
        dispatch_semaphore_signal(semaphore);

    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
   
#if DEBUG
    // 结束进程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        abort();
    });
#else
    // 生产环境
    // do nothing
#endif

}
- (void)handleExceptionAndStackInfo{
    
}

@end
