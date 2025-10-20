//
//  NSMutableDictionary+AvoidCrash.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "NSMutableDictionary+AvoidCrash.h"
#import "AvoidCrash.h"
#import "ACAvoidLockTaskQueue.h"
#import <objc/runtime.h>

static const void *AvoidCrashNSMutableDictionaryKey = &AvoidCrashNSMutableDictionaryKey;
static const void *AvoidCrashNSMutableDictionaryKeyV3 = &AvoidCrashNSMutableDictionaryKeyV3;
@implementation NSMutableDictionary (AvoidCrash)

- (NSMutableDictionary *)needSafe {
    objc_setAssociatedObject(self, AvoidCrashNSMutableDictionaryKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

- (NSMutableDictionary *)needSafeV2 {
    objc_setAssociatedObject(self, AvoidCrashNSMutableDictionaryKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

- (NSMutableDictionary *)needSafeV3 {
    ACAvoidLockTaskQueue *queue = objc_getAssociatedObject(self, AvoidCrashNSMutableDictionaryKeyV3);
    if (!queue) {
        queue = [[ACAvoidLockTaskQueue alloc] init];
        objc_setAssociatedObject(self, AvoidCrashNSMutableDictionaryKeyV3, queue, OBJC_ASSOCIATION_RETAIN);
    }
    return self;
}

- (ACAvoidLockTaskQueue *)queue {
    ACAvoidLockTaskQueue *queue = objc_getAssociatedObject(self, AvoidCrashNSMutableDictionaryKeyV3);
    return queue;
}

- (BOOL)isNeedSafe {
    id obj = objc_getAssociatedObject(self, AvoidCrashNSMutableDictionaryKeyV3);
    id obj1 = objc_getAssociatedObject(self, AvoidCrashNSMutableDictionaryKey);
    return obj || obj1;
}

+ (void)avoidCrashExchangeMethod {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
        
        [AvoidCrash exchangeInstanceMethod:dictionaryM method1Sel:@selector(setObject:forKey:) method2Sel:@selector(avoidCrashSetObject:forKey:)];
        
        //setObject:forKeyedSubscript:
        if (AvoidCrashIsiOS(11.0)) {
            [AvoidCrash exchangeInstanceMethod:dictionaryM method1Sel:@selector(setObject:forKeyedSubscript:) method2Sel:@selector(avoidCrashSetObject:forKeyedSubscript:)];
        }
                
        Method removeObjectForKey = class_getInstanceMethod(dictionaryM, @selector(removeObjectForKey:));
        Method avoidCrashRemoveObjectForKey = class_getInstanceMethod(dictionaryM, @selector(avoidCrashRemoveObjectForKey:));
        method_exchangeImplementations(removeObjectForKey, avoidCrashRemoveObjectForKey);
    });
}

#pragma mark - setObject:forKey:

- (void)avoidCrashSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    @try {
        [self avoidCrashSetObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        [AvoidCrash noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}

#pragma mark - setObject:forKeyedSubscript:
- (void)avoidCrashSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    @try {
        threadSafe_mutex(^{
            [self avoidCrashSetObject:obj forKeyedSubscript:key];
        }, self.mutex_lock, [self isNeedSafe], [self queue]);
    }
    @catch (NSException *exception) {
        [AvoidCrash noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}

#pragma mark - removeObjectForKey:
- (void)avoidCrashRemoveObjectForKey:(id)aKey {
    
    @try {
        threadSafe_mutex(^{
            [self avoidCrashRemoveObjectForKey:aKey];
        }, self.mutex_lock, [self isNeedSafe], [self queue]);
    }
    @catch (NSException *exception) {
        [AvoidCrash noteErrorWithException:exception defaultToDo:AvoidCrashDefaultIgnore];
    }
    @finally {
        
    }
}

@end
