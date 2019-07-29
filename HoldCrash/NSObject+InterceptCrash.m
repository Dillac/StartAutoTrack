//
//  NSObject+InterceptCrash.m
//  Stark
//
//  Created by Burke on 2019/7/22.
//  Copyright © 2019 Burke. All rights reserved.
//

#import "NSObject+InterceptCrash.h"
#import "NSObject+SwizzledMethod.h"
#import "StarkCrashServiceMarcos.h"

@implementation NSObject (InterceptCrash)

+ (void)interceptObjectCrashInUnrecognizedSelector{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //1. unrecognized selector
        [self swizzledInstanceMethodWithClass:[self class] originalSelector:@selector(methodSignatureForSelector:) swizzledMethod:@selector(swizzled_methodSignatureForSelector:)];
        [self swizzledInstanceMethodWithClass:[self class] originalSelector:@selector(forwardInvocation:) swizzledMethod:@selector(swizzeld_forwardInvocation:)];
        
        
    });
}
#pragma mark - private method

- (NSMethodSignature *)swizzled_methodSignatureForSelector:(SEL)selector{
    NSMethodSignature *methodSign = [self swizzled_methodSignatureForSelector:selector];
    if ([self respondsToSelector:selector] || methodSign){
        return methodSign;
    }
    else{
        return [NSObject instanceMethodSignatureForSelector:@selector(emptyFunction)];
    }
}
- (void)swizzeld_forwardInvocation:(NSInvocation *)invocation{
    @try {
        [self swizzeld_forwardInvocation:invocation];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInUnrecognizedSelector)}];
        
    } @finally {

    }
}
- (void)emptyFunction{
    NSLog(@"");
}
@end
