//
//  NSMutableDictionary+AvoidCrash.h
//  https://github.com/chenfanfang/AvoidCrash
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvoidCrashProtocol.h"

@interface NSMutableDictionary (AvoidCrash)<AvoidCrashProtocol>

- (NSMutableDictionary *)needSafe;
- (NSMutableDictionary *)needSafeV2;
- (NSMutableDictionary *)needSafeV3;

@end
