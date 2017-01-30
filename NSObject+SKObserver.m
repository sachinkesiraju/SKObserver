//
//  NSObject+SKObserver.m
//  SKObserver
//
//  Created by Sachin Kesiraju on 1/19/17.
//  Copyright © 2017 Sachin Kesiraju. All rights reserved.
//

#import "NSObject+SKObserver.h"
#import <objc/runtime.h>

static void * SKObserverContext = &SKObserverContext;
static void * SKObserverAssosciatedObjectKey = &SKObserverAssosciatedObjectKey;

#pragma mark - SKObserver

@interface SKObserver : NSObject

@property (assign, nonatomic) __unsafe_unretained id observedObject;
@property (copy, nonatomic) NSString *keyPath;
@property (copy, nonatomic) SKObserverBlock observerBlock;

@end

@implementation SKObserver

- (id) initForObject:(id) object keyPath:(NSString *) keyPath block:(SKObserverBlock) block
{
    NSParameterAssert(object);
    NSParameterAssert(keyPath);
    NSParameterAssert(block);
    
    self = [super init];
    if (self) {
        _observedObject = object;
        _keyPath = keyPath;
        _observerBlock = block;
        [_observedObject addObserver:self forKeyPath:_keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:SKObserverContext];
    }
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == SKObserverContext) {
        _observerBlock(change);
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end

#pragma mark - NSObject category

@implementation NSObject (SKObserver)

- (NSMutableArray *) currentKeyPathObservers
{
    @synchronized (self) {
        NSMutableArray *keyPathObservers = objc_getAssociatedObject(self, SKObserverAssosciatedObjectKey);
        if (!keyPathObservers) {
            keyPathObservers = [NSMutableArray array];
            objc_setAssociatedObject(self, SKObserverAssosciatedObjectKey, keyPathObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return keyPathObservers;
    }
}

- (id) sk_addObserverForKeyPath:(NSString *)keyPath withBlock:(SKObserverBlock)block
{
    NSParameterAssert(block);
    
    SKObserver *observer = [[SKObserver alloc] initForObject:self keyPath:keyPath block:block];
    NSMutableArray *currentObservers = [self currentKeyPathObservers];
    @synchronized (currentObservers) {
        [currentObservers addObject:observer];
    }
    return observer;
}

- (void) sk_removeObserver:(id)observer
{
    if (observer && [observer isKindOfClass:[SKObserver class]]) {
        SKObserver *sk_observer = (SKObserver *) observer;
        [self removeObserver:sk_observer forKeyPath:sk_observer.keyPath];
        NSMutableArray *currentObservers = [self currentKeyPathObservers];
        @synchronized (currentObservers) {
            [currentObservers removeObjectIdenticalTo:sk_observer];
        }
    }
}

- (void) sk_removeAllObservers
{
    NSMutableArray *currentObservers = [self currentKeyPathObservers];
    @synchronized (currentObservers) {
        for (SKObserver *observer in currentObservers) {
            [self sk_removeObserver:observer];
        }
    }
}

@end
