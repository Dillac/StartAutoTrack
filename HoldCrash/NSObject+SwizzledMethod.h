//
//  NSObject+SwizzledMethod.h
//  Stark
//
//  Created by Burke on 2019/7/22.
//  Copyright © 2019 Burke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SwizzledMethod)
/**
 NSObject 实例方法交换
 
 @param className 类
 @param originalSelector 原始方法
 @param swizzledSelector 交换方法
 */
+ (void)swizzledInstanceMethodWithClass:(Class)className originalSelector:(SEL)originalSelector swizzledMethod:(SEL)swizzledSelector;

/**
 NSObject 类方法交换

 @param className 类
 @param originalSelector 原始方法
 @param swizzledSelector 交换方法
 */
+ (void)swizzledClassMethodWithClass:(Class)className originalSelector:(SEL)originalSelector swizzledMethod:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
