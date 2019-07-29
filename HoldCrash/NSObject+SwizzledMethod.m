//
//  NSObject+SwizzledMethod.m
//  Stark
//
//  Created by Burke on 2019/7/22.
//  Copyright © 2019 Burke. All rights reserved.
//

#import "NSObject+SwizzledMethod.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (SwizzledMethod)

+ (void)swizzledClassMethodWithClass:(Class)className originalSelector:(SEL)originalSelector swizzledMethod:(SEL)swizzledSelector{
    if (!className) {
        return;
    }
    Method originalMethod = class_getClassMethod(className, originalSelector);
    Method swizzledMethod = class_getClassMethod(className, swizzledSelector);
    
    Class metacls = objc_getMetaClass(NSStringFromClass(className).UTF8String);
    if (class_addMethod(metacls,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(metacls,
                            swizzledSelector,
                            class_replaceMethod(metacls,
                                                originalSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}
+ (void)swizzledInstanceMethodWithClass:(Class)className originalSelector:(SEL)originalSelector swizzledMethod:(SEL)swizzledSelector{
    if (!className) {
        return;
    }
    Method originalMethod = class_getInstanceMethod(className, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(className, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(className,
                    originalSelector,
                    method_getImplementation(swizzleMethod),
                    method_getTypeEncoding(swizzleMethod));
    if (didAddMethod){
        class_replaceMethod(className,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}
@end
