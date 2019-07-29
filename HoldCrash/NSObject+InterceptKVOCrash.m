//
//  NSObject+InterceptKVOCrash.m
//  Stark
//
//  Created by Burke on 2019/7/23.
//  Copyright © 2019 Burke. All rights reserved.
//

#import "NSObject+InterceptKVOCrash.h"
#import "NSObject+SwizzledMethod.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface NSKVOItem : NSObject

@property (nonatomic,weak)id target;

@property (nonatomic,weak)NSObject * observer;

@property (nonatomic,copy)NSString * keyPath;

@property (nonatomic,assign)NSKeyValueObservingOptions options;

@property (nonatomic,assign)void * context;

@end

@implementation NSKVOItem

- (void)dealloc{
    NSLog(@"===================");
}

@end

@implementation NSObject (InterceptKVOCrash)

static const char Stark_InterceptCrash_In_KVO_ItemContainer_Key;
static const char Stark_InterceptCrash_In_KVO_ObserverTable_Key;


+ (void)interceptObjectCrashInKVO{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*
         *! 表现为：1.不成对的观察者和被观察者 2.观察者/被观察者释放的时候没有断开与观察者关系。
         KVO Crash 的几个函数为：
         addObserver:forKeyPath:options:context:
         observeValueForKeyPath:ofObject:change:context:
         removeObserver:forKeyPath:
         removeObserver:forKeyPath:context:
         *!解决思路：
         建立一个哈希表，用来保存观察者、keyPath的信息，如果哈希表里已经有了相关的观察者/keyPath信息，那么继续添加观察者的话，就不载进行添加，同样移除观察的时候，也现在哈希表中进行查找，如果存在观察者，keypath信息，那么移除，如果没有的话就不执行相关的移除操作。要实现这样的思路就需要用到methodSwizzle来进行方法交换
         
         */
        [self swizzledInstanceMethodWithClass:[self class] originalSelector:@selector(addObserver:forKeyPath:options:context:) swizzledMethod:@selector(swizzled_addObserver:forKeyPath:options:context:)];
        [self swizzledInstanceMethodWithClass:[self class] originalSelector:@selector(observeValueForKeyPath:ofObject:change:context:) swizzledMethod:@selector(swizzled_observeValueForKeyPath:ofObject:change:context:)];
        [self swizzledInstanceMethodWithClass:[self class] originalSelector:@selector(removeObserver:forKeyPath:) swizzledMethod:@selector(swizzled_removeObserver:forKeyPath:)];
        [self swizzledInstanceMethodWithClass:[self class] originalSelector:@selector(removeObserver:forKeyPath:context:) swizzledMethod:@selector(swizzled_removeObserver:forKeyPath:context:)];
        
    });
}
- (void)swizzled_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{

    if (!(observer && keyPath && [keyPath isKindOfClass:[NSString class]]) ) {
        return;
    }
    if ([self filterSpecialThirdPartLibrary:observer]) {
        [self swizzled_addObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }
    
    NSKVOItem * item = [NSKVOItem new];
    item.target = self;
    item.observer = observer;
    item.keyPath = keyPath;
    item.context = context;
    item.options = options;
    NSMutableSet * itemContainer = (NSMutableSet *)objc_getAssociatedObject(self, &Stark_InterceptCrash_In_KVO_ItemContainer_Key);
    if (!itemContainer) {
        itemContainer = [NSMutableSet new];
    }else{
        if (![itemContainer containsObject:item]) {
            @synchronized (itemContainer) {
                [itemContainer addObject:item];
                objc_setAssociatedObject(self, &Stark_InterceptCrash_In_KVO_ItemContainer_Key, itemContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self swizzled_addObserver:observer forKeyPath:keyPath options:options context:context];
        }
    }
    NSHashTable * observerTable = (NSHashTable *)objc_getAssociatedObject(self, &Stark_InterceptCrash_In_KVO_ObserverTable_Key);
    if (!observerTable) {
        @synchronized (observerTable) {
            observerTable = [NSHashTable new];
            [observerTable addObject:item];
            objc_setAssociatedObject(self, &Stark_InterceptCrash_In_KVO_ObserverTable_Key, observerTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }else{
        @synchronized (observerTable) {
            [observerTable addObject:item];
            objc_setAssociatedObject(self, &Stark_InterceptCrash_In_KVO_ObserverTable_Key, observerTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    //3. dealloc
    swizzled_dealloc(self.class);
    swizzled_dealloc(observer.class);
    
}
- (void)swizzled_observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    
}
- (void)swizzled_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context{
}
- (void)swizzled_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    [self swizzled_removeObserver:observer forKeyPath:keyPath context:nil];
}
#pragma mark  private methods

void swizzled_dealloc(Class class){
    
}
#pragma mark - 过滤三方库（RAC/AMap等），保持框架健壮
- (BOOL)filterSpecialThirdPartLibrary:(id)object{
    //过滤三方库（RAC/AMap），保持框架健壮
    if (object_getClassName(object) == object_getClassName(@"RACKVOProxy") ||object_getClassName(object) == object_getClassName(@"AMap") ) {
        return YES;
    }
    return NO;
}
@end
