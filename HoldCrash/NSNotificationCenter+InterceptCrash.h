//
//  NSNotificationCenter+InterceptCrash.h
//  Stark
//
//  Created by Burke on 2019/7/24.
//  Copyright © 2019 Burke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (InterceptCrash)
/*
 
 iOS9.0后 系统对objc没有移除observer 做了处理，不会产生crash
 *! noti 产生的crash虽然系统层做了优化，但是良好的代码编写素养至关重要，亡羊补牢虽未为晚也，与诸君共勉。
 */

+ (void)interceptObjectCrashInNotification;

@end

NS_ASSUME_NONNULL_END
