//
//  ACAvoidLockTaskQueue.h
//  AvoidCrashDemo
//
//  Created by YHMacMini on 2025/10/20.
//  Copyright © 2025 chenfanfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <os/lock.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACAvoidLockTask : NSObject

@property (nonatomic, copy) NSString *taskId;          // 唯一标识
@property (nonatomic, copy) dispatch_block_t block;    // 实际任务

- (instancetype)initWithBlock:(dispatch_block_t)block;

@end

@interface ACAvoidLockTaskQueue : NSObject

@property (nonatomic, assign, readonly) os_unfair_lock unfairLock;
@property (nonatomic, strong) NSMutableArray<ACAvoidLockTask *> *pendingTasks;
@property (nonatomic, strong) dispatch_source_t timer;
- (void)executeTask:(ACAvoidLockTask *)task;

@end

NS_ASSUME_NONNULL_END
