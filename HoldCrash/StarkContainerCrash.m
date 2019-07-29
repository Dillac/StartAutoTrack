//
//  StarkContainerCrash.m
//  Stark
//
//  Created by Burke on 2019/7/29.
//  Copyright © 2019 Burke. All rights reserved.
//

#import "StarkContainerCrash.h"
#import "NSObject+SwizzledMethod.h"
#import "StarkCrashServiceMarcos.h"
#import <UIKit/UIKit.h>


//============================ interface category ===========================//
@interface NSArray (InterceptCrash)
+ (void)startMethodSwizzle;
@end

@interface NSMutableArray (InterceptCrash)
+ (void)startMethodSwizzle;
@end

@interface NSDictionary (InterceptCrash)
+ (void)startMethodSwizzle;
@end

@interface NSMutableDictionary (InterceptCrash)
+ (void)startMethodSwizzle;
@end

#pragma mark - StarkContainerCrash
//============================ StarkContainerCrash ===========================//
@implementation StarkContainerCrash

+ (void)interceptObjectCrashInContainer{
    [NSArray  startMethodSwizzle];
    [NSMutableArray startMethodSwizzle];
    [NSDictionary startMethodSwizzle];
    [NSMutableDictionary startMethodSwizzle];
}
@end


//========================== implementation category =========================//
@implementation NSArray (InterceptCrash)
#pragma  mark - implementation + NSArray
+ (void)startMethodSwizzle{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // exchange
        [NSArray swizzledClassMethodWithClass:[self class] originalSelector:@selector(arrayWithObjects:count:) swizzledMethod:@selector(swizzled_arrayWithObjects:count:)];
        
        Class __NSArray = NSClassFromString(@"NSArray");
        Class __NSArrayI = NSClassFromString(@"__NSArrayI");
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
        Class __NSArray0 = NSClassFromString(@"__NSArray0");
        
        [self swizzledInstanceMethodWithClass:__NSArray originalSelector:@selector(objectsAtIndexes:) swizzledMethod:@selector(swizzled_objectsAtIndexes:)];
        
        [self swizzledInstanceMethodWithClass:__NSArrayI originalSelector:@selector(objectAtIndex:) swizzledMethod:@selector(__NSArray_swizzled_objectAtIndex:)];
        
        [self swizzledInstanceMethodWithClass:__NSSingleObjectArrayI originalSelector:@selector(objectAtIndex:) swizzledMethod:@selector(__NSSingleObjectArrayI_swizzled_objectAtIndex:)];
        
        [self swizzledInstanceMethodWithClass:__NSArray0 originalSelector:@selector(objectAtIndex:) swizzledMethod:@selector(__NSArray0_swizzled_objectAtIndex:)];
        
        //objectAtIndexedSubscript:
        
        if (AboveVersion(11.0)) {
            [NSArray swizzledInstanceMethodWithClass:__NSArrayI originalSelector:@selector(objectAtIndexedSubscript:) swizzledMethod:@selector(__NSArrayI_swizzled_objectAtIndexedSubscript:)];
        }
        
        
        //getObjects:range:
        [NSArray swizzledInstanceMethodWithClass:__NSArray originalSelector:@selector(getObjects:range:) swizzledMethod:@selector(swizzled_getObjects:range:)];
        
        [NSArray swizzledInstanceMethodWithClass:__NSSingleObjectArrayI originalSelector:@selector(getObjects:range:) swizzledMethod:@selector(__NSSingleObjectArrayI_swizzled_getObjects:range:)];
        
        [NSArray swizzledInstanceMethodWithClass:__NSArrayI originalSelector:@selector(getObjects:range:) swizzledMethod:@selector(__NSArrayI_swizzled_getObjects:range:)];
    });
}
+ (instancetype)swizzled_arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self swizzled_arrayWithObjects:objects count:cnt];
    } @catch (NSException *exception) {
        
    } @finally {
        return instance;
    }
}
- (NSArray *)swizzled_objectsAtIndexes:(NSIndexSet *)indexes {
    NSArray * instanceArray = nil;
    @try {
        instanceArray = [self swizzled_objectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    } @finally {
        return instanceArray;
    }
}
- (id)__NSArray_swizzled_objectAtIndex:(NSUInteger)index {
    NSArray * instanceArray = nil;
    @try {
        instanceArray = [self __NSArray_swizzled_objectAtIndex:index];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    } @finally {
        return instanceArray;
    }
}

- (id)__NSSingleObjectArrayI_swizzled_objectAtIndex:(NSUInteger)index{
    NSArray * instanceArray = nil;
    @try {
        instanceArray = [self __NSSingleObjectArrayI_swizzled_objectAtIndex:index];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    } @finally {
        return instanceArray;
    }
}
- (id)__NSArray0_swizzled_objectAtIndex:(NSUInteger)index{
    NSArray * instanceArray = nil;
    @try {
        instanceArray = [self __NSArray0_swizzled_objectAtIndex:index];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    } @finally {
        return instanceArray;
    }
}
- (id)__NSArrayI_swizzled_objectAtIndexedSubscript:(NSIndexSet *)indexes{
    NSArray * instanceArray = nil;
    @try {
        instanceArray = [self __NSArrayI_swizzled_objectAtIndexedSubscript:indexes];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    } @finally {
        return instanceArray;
    }
}

- (void)swizzled_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self swizzled_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    } @finally {
    }
}

- (void)__NSSingleObjectArrayI_swizzled_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self __NSSingleObjectArrayI_swizzled_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    } @finally {
    }
}

- (void)__NSArrayI_swizzled_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self __NSArrayI_swizzled_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    } @finally {
    }
}

@end

@implementation NSMutableArray (InterceptCrash)
#pragma  mark - implementation + NSMutableArray
+ (void)startMethodSwizzle{
    Class __NSArrayM = NSClassFromString(@"__NSArrayM");

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzledInstanceMethodWithClass:__NSArrayM originalSelector:@selector(objectAtIndex:) swizzledMethod:@selector(swizzled_objectAtIndex:)];
        if (AboveVersion(11.0)) {
            [self swizzledInstanceMethodWithClass:__NSArrayM originalSelector:@selector(objectAtIndexedSubscript:) swizzledMethod:@selector(swizzled_objectAtIndexedSubscript:)];
        }
        [self swizzledInstanceMethodWithClass:__NSArrayM originalSelector:@selector(setObject:atIndexedSubscript:) swizzledMethod:@selector(swizzled_setObject:atIndexedSubscript:)];
        [self swizzledInstanceMethodWithClass:__NSArrayM originalSelector:@selector(removeObjectAtIndex:) swizzledMethod:@selector(swizzled_removeObjectAtIndex:)];
        [self swizzledInstanceMethodWithClass:__NSArrayM originalSelector:@selector(insertObject:atIndex:) swizzledMethod:@selector(swizzled_insertObject:atIndex:)];
        [self swizzledInstanceMethodWithClass:__NSArrayM originalSelector:@selector(getObjects:range:) swizzledMethod:@selector(swizzled_getObjects:range:)];
    });
}
- (id)swizzled_objectAtIndex:(NSUInteger)index {
    id instanceArrayM = nil;
    @try {
        instanceArrayM = [self swizzled_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
        return instanceArrayM;
    }
}
- (id)swizzled_objectAtIndexedSubscript:(NSUInteger)index {
    id instanceArrayM = nil;
    @try {
        instanceArrayM = [self swizzled_objectAtIndexedSubscript:index];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
        return instanceArrayM;
    }
}
- (void)swizzled_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    
    @try {
        [self swizzled_setObject:obj atIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
    }
}
- (void)swizzled_removeObjectAtIndex:(NSUInteger)index {
    @try {
        [self swizzled_removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
    }
}
- (void)swizzled_insertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self swizzled_insertObject:anObject atIndex:index];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
    }
}
- (void)swizzled_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self swizzled_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    } @finally {
    }
}

@end
@implementation NSDictionary (InterceptCrash)
#pragma  mark - implementation + NSDictionary
+ (void)startMethodSwizzle{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzledClassMethodWithClass:[self class] originalSelector:@selector(dictionaryWithObjects:forKeys:count:) swizzledMethod:@selector(swizzled_dictionaryWithObjects:forKeys:count:)];
        Class __NSPlaceholderDictionary = NSClassFromString(@"__NSPlaceholderDictionary");
        //NSMutableDictionary和NSDictionary ==》 __NSPlaceholderDictionary
        [self swizzledInstanceMethodWithClass:__NSPlaceholderDictionary originalSelector:@selector(initWithObjects:forKeys:count:) swizzledMethod:@selector(swizzled_initWithObjects:forKeys:count:)];
        [self swizzledInstanceMethodWithClass:__NSPlaceholderDictionary originalSelector:@selector(initWithObjects:forKeys:) swizzledMethod:@selector(swizzled_initWithObjects:forKeys:)];
        
    });
}
+ (instancetype)swizzled_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    id instanceDictionary = nil;
    
    @try {
        instanceDictionary = [self swizzled_dictionaryWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
       
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instanceDictionary = [self swizzled_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instanceDictionary;
    }
}
- (instancetype)swizzled_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt{
    
    id instanceDictionary = nil;
    @try {
        instanceDictionary = [self swizzled_initWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
        //处理错误的数据，重新初始化一个字典
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instanceDictionary = [self swizzled_initWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instanceDictionary;
    }
}
- (instancetype)swizzled_initWithObjects:(NSArray *)objects forKeys:(NSArray<id<NSCopying>> *)keys{
    id instanceDictionary = nil;
    @try {
        instanceDictionary = [self swizzled_initWithObjects:objects forKeys:keys];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
        //处理错误的数据，重新初始化一个字典
        NSUInteger count = MIN(objects.count, keys.count);
        NSMutableArray *newObjs = [NSMutableArray array];
        NSMutableArray *newKeys = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            if (objects[i] && keys[i]) {
                [newObjs addObject:objects[i]];
                [newKeys addObject:keys[i]];
            }
        }
        instanceDictionary = [self swizzled_initWithObjects:newObjs forKeys:newKeys];
    }
    @finally {
        return instanceDictionary;
    }
}


@end
#pragma  mark - implementation + NSMutableDictionary
@implementation  NSMutableDictionary (InterceptCrash)
+ (void)startMethodSwizzle{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSDictionaryM = NSClassFromString(@"__NSDictionaryM");

        [self swizzledInstanceMethodWithClass:__NSDictionaryM originalSelector:@selector(setObject:forKey:) swizzledMethod:@selector(swizzled_setObject:forKey:)];
        [self swizzledInstanceMethodWithClass:__NSDictionaryM originalSelector:@selector(removeObjectForKey:) swizzledMethod:@selector(swizzled_removeObjectForKey:)];

        if (AboveVersion(11.0)) {
            [self swizzledInstanceMethodWithClass:__NSDictionaryM originalSelector:@selector(setObject:forKeyedSubscript:) swizzledMethod:@selector(swizzled_setObject:forKeyedSubscript:)];
        }
        Class __NSCFDictionary = NSClassFromString(@"__NSCFDictionary");
        [self swizzledInstanceMethodWithClass:__NSCFDictionary originalSelector:@selector(setObject:forKey:) swizzledMethod:@selector(__NSCFDictionary_swizzled_setObject:forKey:)];
        [self swizzledInstanceMethodWithClass:__NSCFDictionary originalSelector:@selector(removeObjectForKey:) swizzledMethod:@selector(__NSCFDictionary_swizzled_removeObjectForKey:)];
    });
}
- (void)swizzled_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self swizzled_setObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
    }
}
- (void)swizzled_removeObjectForKey:(id)aKey {
    
    @try {
        [self swizzled_removeObjectForKey:aKey];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
    }
}
- (void)swizzled_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {

    @try {
        [self swizzled_setObject:obj forKey:key];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
        
    }
}
- (void)__NSCFDictionary_swizzled_setObject:(id)anObject forKey:(id<NSCopying>)key {
    
    @try {
        [self __NSCFDictionary_swizzled_setObject:anObject forKey:key];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
    }
}
- (void)__NSCFDictionary_swizzled_removeObjectForKey:(id)key{
    @try {
        [self __NSCFDictionary_swizzled_removeObjectForKey:key];
    }
    @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STARK_CRASH_BORN_NOTI_NAME object:exception userInfo:@{STARK_CRASH_BORN_TYPE_NOTI_KEY:@(StarkCrashTypeInContainer)}];
    }
    @finally {
    }
}
@end
