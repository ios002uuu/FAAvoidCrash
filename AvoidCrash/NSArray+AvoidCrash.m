//
//  NSArray+AvoidCrash.m
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "NSArray+AvoidCrash.h"

#import "AvoidCrash.h"

@implementation NSArray (AvoidCrash)


+ (void)avoidCrashExchangeMethod {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        [AvoidCrash exchangeClassMethod:[self class] method1Sel:@selector(arrayWithObjects:count:) method2Sel:@selector(AvoidCrashArrayWithObjects:count:)];

        Class __NSArray = NSClassFromString(@"NSArray");
        Class __NSArrayI = NSClassFromString(@"__NSArrayI");
        Class __NSConstantArray = NSClassFromString(@"NSConstantArray");
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
        Class __NSArray0 = NSClassFromString(@"__NSArray0");
        
        [AvoidCrash exchangeInstanceMethod:__NSArray method1Sel:@selector(objectsAtIndexes:) method2Sel:@selector(avoidCrashObjectsAtIndexes:)];
        
        [AvoidCrash exchangeInstanceMethod:__NSArrayI method1Sel:@selector(objectAtIndex:) method2Sel:@selector(__NSArrayIAvoidCrashObjectAtIndex:)];
        
        [AvoidCrash exchangeInstanceMethod:__NSSingleObjectArrayI method1Sel:@selector(objectAtIndex:) method2Sel:@selector(__NSSingleObjectArrayIAvoidCrashObjectAtIndex:)];
        
        [AvoidCrash exchangeInstanceMethod:__NSArray0 method1Sel:@selector(objectAtIndex:) method2Sel:@selector(__NSArray0AvoidCrashObjectAtIndex:)];
        
        //objectAtIndexedSubscript:
        if (AvoidCrashIsiOS(11.0)) {
            [AvoidCrash exchangeInstanceMethod:__NSArrayI method1Sel:@selector(objectAtIndexedSubscript:) method2Sel:@selector(__NSArrayIAvoidCrashObjectAtIndexedSubscript:)];
            [AvoidCrash exchangeInstanceMethod:__NSConstantArray method1Sel:@selector(objectAtIndexedSubscript:) method2Sel:@selector(__NSConstantArrayIAvoidCrashObjectAtIndexedSubscript:)];
        }
        
        [AvoidCrash exchangeInstanceMethod:__NSArray method1Sel:@selector(getObjects:range:) method2Sel:@selector(NSArrayAvoidCrashGetObjects:range:)];
        [AvoidCrash exchangeInstanceMethod:__NSConstantArray method1Sel:@selector(getObjects:range:) method2Sel:@selector(__NSConstantArrayAvoidCrashGetObjects:range:)];
        
        [AvoidCrash exchangeInstanceMethod:__NSSingleObjectArrayI method1Sel:@selector(getObjects:range:) method2Sel:@selector(__NSSingleObjectArrayIAvoidCrashGetObjects:range:)];
        
        [AvoidCrash exchangeInstanceMethod:__NSArrayI method1Sel:@selector(getObjects:range:) method2Sel:@selector(__NSArrayIAvoidCrashGetObjects:range:)];
    });
}

#pragma mark - instance array
+ (instancetype)AvoidCrashArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
        instance = [self AvoidCrashArrayWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        
        NSString *defaultToDo = @"AvoidCrash default is to remove nil object and instance a array.";
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
        //以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self AvoidCrashArrayWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}

#pragma mark - objectAtIndexedSubscript:
- (id)__NSArrayIAvoidCrashObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    
    @try {
        object = [self __NSArrayIAvoidCrashObjectAtIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        return object;
    }

}

- (id)__NSConstantArrayIAvoidCrashObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    
    @try {
        object = [self __NSConstantArrayIAvoidCrashObjectAtIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        return object;
    }

}

#pragma mark - objectsAtIndexes:
- (NSArray *)avoidCrashObjectsAtIndexes:(NSIndexSet *)indexes {
    
    NSArray *returnArray = nil;
    @try {
        returnArray = [self avoidCrashObjectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        return returnArray;
    }
}

#pragma mark - objectAtIndex:
- (id)__NSArrayIAvoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self __NSArrayIAvoidCrashObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        return object;
    }
}

- (id)__NSSingleObjectArrayIAvoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self __NSSingleObjectArrayIAvoidCrashObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *defaultToDo = AvoidCrashDefaultReturnNil;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        return object;
    }
}

- (id)__NSArray0AvoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self __NSArray0AvoidCrashObjectAtIndex:index];
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
- (void)NSArrayAvoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self NSArrayAvoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
}

- (void)__NSConstantArrayAvoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self __NSConstantArrayAvoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

- (void)__NSSingleObjectArrayIAvoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self __NSSingleObjectArrayIAvoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
}

- (void)__NSArrayIAvoidCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self __NSArrayIAvoidCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = AvoidCrashDefaultIgnore;
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
}

@end
