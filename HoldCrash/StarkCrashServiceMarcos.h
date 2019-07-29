//
//  StarkCrashServiceMarcos.h
//  Stark
//
//  Created by Burke on 2019/7/22.
//  Copyright © 2019 Burke. All rights reserved.
//

#ifndef StarkCrashServiceMarcos_h
#define StarkCrashServiceMarcos_h

/**
 crash type
 - StarkCrashTypeInUnkown : Unkown
 - StarkCrashTypeInUnrecognizedSelector: UnrecognizedSelector
 - StarkCrashTypeInContainer: Container
 - StarkCrashTypeInKVO: KVO
 - StarkCrashTypeInNotification: Notification
 - StarkCrashTypeInTimer: Timer
 - StarkCrashTypeInPointerException: Pointer
 - StarkCrashTypeInOOM: OOM
 */
typedef NS_OPTIONS(NSUInteger, StarkCrashType) {
    StarkCrashTypeInUnkown = 1 << 0,
    StarkCrashTypeInUnrecognizedSelector = 1 << 1,
    StarkCrashTypeInContainer = 1 << 2,
    StarkCrashTypeInKVO = 1 << 3,
    StarkCrashTypeInNotification = 1 << 4,
    StarkCrashTypeInTimer = 1 << 5,
    StarkCrashTypeInPointerException = 1 << 6,
    StarkCrashTypeInOOM = 1 << 7
};
/// crash ing
static NSString * STARK_CRASH_BORN_NOTI_NAME = @"starkCrashBornNotiName";
static NSString * STARK_CRASH_BORN_TYPE_NOTI_KEY = @"starkCrashBornTypeNotiKey";

#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"function:%s line:%d content:%s", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#define AboveVersion(version)  ([[UIDevice currentDevice].systemVersion floatValue] >= version)



#endif /* StarkCrashServiceMarcos_h */
