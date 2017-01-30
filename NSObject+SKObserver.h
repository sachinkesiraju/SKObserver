//
//  NSObject+SKObserver.h
//  SKObserver
//
//  Created by Sachin Kesiraju on 1/19/17.
//  Copyright © 2017 Sachin Kesiraju. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SKObserver)

typedef void (^SKObserverBlock)(NSDictionary <NSKeyValueChangeKey, id>  *change);

- (id) sk_addObserverForKeyPath:(NSString *) keyPath withBlock:(SKObserverBlock) block;

- (void) sk_removeObserver:(id) observer;
- (void) sk_removeAllObservers;

@end

NS_ASSUME_NONNULL_END
