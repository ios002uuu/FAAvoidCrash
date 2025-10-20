//
//  NSArray+SafeAisle.m
//  AvoidCrashDemo
//
//  Created by YHMacMini on 2025/10/20.
//  Copyright © 2025 chenfanfang. All rights reserved.
//

#import "NSArray+SafeAisle.h"

@implementation NSArray (SafeAisle)

- (id)sfoIndex:(NSUInteger)index {
    
    if (index < self.count) {
        return self[index];
    } else {
        return nil;
    }
}

- (id)pop {
    if (self.count >= 0) {
        return self[0];
    }
    return nil;
}

+ (NSArray *)sortWithKey:(NSString *)key useArray:(NSArray *)array ascending:(BOOL)ascending {
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 floatValue] < [obj2 floatValue] ? NSOrderedAscending:NSOrderedDescending;
    }];
    NSArray *sortData = [array sortedArrayUsingDescriptors:@[sorter]];
    return sortData;
}

@end


@implementation NSMutableArray (SafeAisle)

- (void)sfaObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

- (id)pop {
    if (self.count >= 0) {
        id obj = self[0];
        [self removeObjectAtIndex:0];
        return obj;
    }
    return nil;
}

@end
