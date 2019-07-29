//
//  NSObject+InterceptCrash.h
//  Stark
//
//  Created by Burke on 2019/7/22.
//  Copyright © 2019 Burke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (InterceptCrash)

/**
 object UnrecognizedSelector crash
 */

+ (void)interceptObjectCrashInUnrecognizedSelector;


@end

NS_ASSUME_NONNULL_END
