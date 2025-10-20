//
//  NSMutableArray+AvoidCrash.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "NSMutableArray+AvoidCrash.h"
#import "AvoidCrash.h"
#import "ACAvoidLockTaskQueue.h"
#import <os/lock.h>

static const void *AvoidCrashNSMutableArrayyKey = &AvoidCrashNSMutableArrayyKey;
static const void *AvoidCrashNSMutableArrayyKeyV3 = &AvoidCrashNSMutableArrayyKeyV3;
@implementation NSMutableArray (AvoidCrash)

- (NSMutableArray *)needSafe {
    objc_setAssociatedObject(self, AvoidCrashNSMutableArrayyKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

- (NSMutableArray *)needSafeV2 {
    objc_setAssociatedObject(self, AvoidCrashNSMutableArrayyKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

- (NSMutableArray *)needSafeV3 {
    ACAvoidLockTaskQueue *queue = [[ACAvoidLockTaskQueue alloc] init];
    objc_setAssociatedObject(self, AvoidCrashNSMutableArrayyKeyV3, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

- (ACAvoidLockTaskQueue *)queue {
    ACAvoidLockTaskQueue *queue = objc_getAssociatedObject(self, AvoidCrashNSMutableArrayyKeyV3);
    return queue;
}

- (BOOL)isNeedSafe {
    id obj = objc_getAssociatedObject(self, AvoidCrashNSMutableArrayyKeyV3);
    id obj1 = objc_getAssociatedObject(self, AvoidCrashNSMutableArrayyKey);
    return obj || obj1;
}

+ (void)avoidCrashExchangeMethod {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class arrayMClass = NSClassFromString(@"__NSArrayM");
        
        [AvoidCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(objectAtIndex:) method2Sel:@selector(avoidCrashObjectAtIndex:)];
        
        if (AvoidCrashIsiOS(11.0)) {
            [AvoidCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(objectAtIndexedSubscript:) method2Sel:@selector(avoidCrashObjectAtIndexedSubscript:)];
        }
        
        [AvoidCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(setObject:atIndexedSubscript:) method2Sel:@selector(avoidCrashSetObject:atIndexedSubscript:)];
        
        [AvoidCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(removeObjectAtIndex:) method2Sel:@selector(avoidCrashRemoveObjectAtIndex:)];
        
        [AvoidCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(insertObject:atIndex:) method2Sel:@selector(avoidCrashInsertObject:atIndex:)];
        
        [AvoidCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(getObjects:range:) method2Sel:@selector(avoidCrashGetObjects:range:)];
    });
}

#pragma mark - get object from array
- (void)avoidCrashSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    
    @try {
        threadSafe_mutex(^{
            [self avoidCrashSetObject:obj atIndexedSubscript:idx];
        }, self.mutex_lock, [self isNeedSafe], [self queue]);
    }
    @catch (NSException *exception) {
        [AvoidCrash noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}

#pragma mark - removeObjectAtIndex:
- (void)avoidCrashRemoveObjectAtIndex:(NSUInteger)index {
    @try {
        threadSafe_mutex(^{
            [self avoidCrashRemoveObjectAtIndex:index];
        }, self.mutex_lock, [self isNeedSafe], [self queue]);
    }
    @catch (NSException *exception) {
        [AvoidCrash noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}

#pragma mark - set方法
- (void)avoidCrashInsertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        threadSafe_mutex(^{
            [self avoidCrashInsertObject:anObject atIndex:index];
        }, self.mutex_lock, [self isNeedSafe], [self queue]);
    }
    @catch (NSException *exception) {
        [AvoidCrash noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}

#pragma mark - objectAtIndex:

- (id)avoidCrashObjectAtIndex:(NSUInteger)index {
    __block id object = nil;
    
    @try {
        threadSafe_mutex(^{
            object = [self avoidCrashObjectAtIndex:index];
        }, self.mutex_lock, [self isNeedSafe], [self queue]);
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        return object;
    }
}

#pragma mark - objectAtIndexedSubscript:
- (id)avoidCrashObjectAtIndexedSubscript:(NSUInteger)idx {
    __block id object = nil;
    
    @try {
        threadSafe_mutex(^{
            object = [self avoidCrashObjectAtIndexedSubscript:idx];
        }, self.mutex_lock, [self isNeedSafe], [self queue]);
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        return object;
    }
    
}

#pragma mark - getObjects:range:
- (void)avoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self avoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
}

@end
