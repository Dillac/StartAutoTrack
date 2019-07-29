//
//  NSNotificationCenter+InterceptCrash.m
//  Stark
//
//  Created by Burke on 2019/7/24.
//  Copyright © 2019 Burke. All rights reserved.
//

#import "NSNotificationCenter+InterceptCrash.h"
#import "NSObject+SwizzledMethod.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "StarkCrashServiceMarcos.h"

@interface NSObject (addNotificationCenterSignal)

@end

@implementation NSObject (addNotificationCenterSignal)

static const char * Stark_NSNotificationCenterIng_Key;

#pragma mark - private methods
- (BOOL)isNSNotification{
    NSNumber *number = objc_getAssociatedObject(self, &Stark_NSNotificationCenterIng_Key);;
    return  [number boolValue];
}
- (void)setIsNSNotification:(BOOL)yesOrNo{
    objc_setAssociatedObject(self, &Stark_NSNotificationCenterIng_Key, @(yesOrNo), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


static NSMutableSet *NotificationCenteSwizzledClassesSet() {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    
    return swizzledClasses;
}
- (void)swizzled_deallocSignal{
  
    Class classToSwizzle = [self class];
    @synchronized (NotificationCenteSwizzledClassesSet()) {
        NSString *className = NSStringFromClass(classToSwizzle);
        if ([NotificationCenteSwizzledClassesSet() containsObject:className]) return;
        
        SEL deallocSelector = sel_registerName("dealloc");
        
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        id newDealloc = ^(__unsafe_unretained id self) {
            [self swizzled_dealloc];
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            } else {
                originalDealloc(self, deallocSelector);
            }
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        
        if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "v@:")) {
            // The class already contains a method implementation.
            Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
            
            // We need to store original implementation before setting new implementation
            // in case method is called at the time of setting.
            originalDealloc = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
            
            // We need to store original implementation again, in case it just changed.
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        
        [NotificationCenteSwizzledClassesSet() addObject:className];
    }
}
- (void)swizzled_dealloc{
    if ([self isNSNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
@end
@implementation NSNotificationCenter (InterceptCrash)

+ (void)interceptObjectCrashInNotification{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzledInstanceMethodWithClass:[self class] originalSelector:@selector(addObserver:selector:name:object:) swizzledMethod:@selector(swizzled_addObserver:selector:name:object:)];
    });
}
- (void)swizzled_addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject{
    [observer setIsNSNotification:YES];
    [observer swizzled_deallocSignal];
    [self swizzled_addObserver:observer selector:aSelector name:aName object:anObject];
    
}


@end
