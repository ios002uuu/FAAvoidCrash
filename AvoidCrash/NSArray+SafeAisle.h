//
//  NSArray+SafeAisle.h
//  AvoidCrashDemo
//
//  Created by YHMacMini on 2025/10/20.
//  Copyright © 2025 chenfanfang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (SafeAisle)

- (ObjectType)sfoIndex:(NSUInteger)index;
+ (NSArray *)sortWithKey:(NSString *)key useArray:(NSArray *)array ascending:(BOOL)ascending;
- (ObjectType)pop;

@end

@interface NSMutableArray<ObjectType> (SafeAisle)

- (void)sfaObject:(ObjectType)object;

@end

NS_ASSUME_NONNULL_END
