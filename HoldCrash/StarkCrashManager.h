//
//  StarkCrashManager.h
//  Stark
//
//  Created by Burke on 2019/7/19.
//  Copyright © 2019 Burke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StarkCrashServiceMarcos.h"

NS_ASSUME_NONNULL_BEGIN
@protocol  StarkCrashManagerDelegate<NSObject>

@end

/**
 crash 上报 protocol
 */
@protocol StarkCrashReporterDelegate <NSObject>



@end

/**
 crash 拦截 protocol
 */
@protocol StarkCrashInterceptDelegate <NSObject>

/**
 开启 拦截 服务成功
 */
- (void)enableInterceptServiceWillReceiveCrashDetailInfo;

/**
 开启 拦截 服务 失败

 @param reason 启动失败原因
 @param error  错误信息
 注释：服务=开启失败因为 app loading/ thread / main etcs
 */
- (void)enableCrashInterceptServiceFailure:(NSString * )reason  error:(NSError *) error;

/**
 捕获crash 信息
 *! 即使框架拦截到crash，也会有详细信息抛出，实现功能解耦

 @param name 名称
 @param reason 错误原因
 @param type   类型
 @param stackArray 堆栈
 @param extraInfo 附加信息
 @param terminate 是否推出app进程
 */
- (void)catchCrashDetailInfoWithName:(NSString *)name reason:(NSString *)reason crashType:(StarkCrashType)type callStack:(NSArray *)stackArray extraInfo:(id)extraInfo terminateApp:(BOOL)terminate;

@end


__attribute__((objc_runtime_name("U3RhcmtDcmFzaE1hbmFnZXI=")))
@interface StarkCrashManager : NSObject

/**
 protocol 返回日志状态
 */
@property (nonatomic,weak)id<StarkCrashManagerDelegate> delegate;

@property (nonatomic,weak)id<StarkCrashReporterDelegate> reporterDelegate;

@property (nonatomic,weak)id<StarkCrashInterceptDelegate> interceptDelegate;

/**
 初始化工具，reporter / intercept 可自定义调用
 配合设备信息SDK联合使用，可返回当前设备环境信息供参考

 @return instancetype
 */
+ (instancetype)sharedManager;

- (instancetype)init NS_UNAVAILABLE;

/**
 *！开启crash 上报服务
 *！此服务每次会在本地写入一个文件，具体文件格式参考文档，API启动会每次做日志上报，
 
 */
- (void)enableCrashReporterService;

/**
 *! 开启crash 拦截服务
 *! DEBUG ：不开启拦截+lLog输出/RELEASE： 开启拦截+无Log输出
 *!
 */
- (void)enableCrashInterceptService;


@end

NS_ASSUME_NONNULL_END
