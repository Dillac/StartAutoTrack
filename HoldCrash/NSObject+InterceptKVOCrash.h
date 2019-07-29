//
//  NSObject+InterceptKVOCrash.h
//  Stark
//
//  Created by Burke on 2019/7/23.
//  Copyright © 2019 Burke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (InterceptKVOCrash)

+ (void)interceptObjectCrashInKVO;

@end

NS_ASSUME_NONNULL_END
