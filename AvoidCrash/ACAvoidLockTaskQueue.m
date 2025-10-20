//
//  ACAvoidLockTaskQueue.m
//  AvoidCrashDemo
//
//  Created by YHMacMini on 2025/10/20.
//  Copyright © 2025 chenfanfang. All rights reserved.
//

#import "ACAvoidLockTaskQueue.h"
#import "pthread.h"
#import "NSArray+SafeAisle.h"

@implementation ACAvoidLockTask

- (instancetype)initWithBlock:(dispatch_block_t)block {
    if (self = [super init]) {
        _taskId = [[NSUUID UUID] UUIDString];
        _block = [block copy];
    }
    return self;
}

@end

@interface ACAvoidLockTaskQueue ()

@property (nonatomic, assign) os_unfair_lock unfairLock;
@property (nonatomic, assign) pthread_mutex_t *mutex_lock_r;
@property (nonatomic, strong) dispatch_queue_t timerQueue;

@end

@implementation ACAvoidLockTaskQueue

- (void)dealloc {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    
    // 安全地销毁互斥锁
    if (_mutex_lock_r) {
        // 确保互斥锁没有被其他线程占用
        int result = pthread_mutex_trylock(_mutex_lock_r);
        if (result == 0) {
            // 如果成功获取锁，立即释放
            pthread_mutex_unlock(_mutex_lock_r);
        }
        
        pthread_mutex_destroy(_mutex_lock_r);
        free(_mutex_lock_r);
        _mutex_lock_r = NULL;
    }
    NSLog(@"执行了吗");
}

- (instancetype)init {
    if (self = [super init]) {
        _unfairLock = OS_UNFAIR_LOCK_INIT;
        _pendingTasks = [NSMutableArray array];
        [self setupTimer];
    }
    return self;
}

- (void)setupTimer {
    if (!_timerQueue) {
        _timerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _timerQueue);
    dispatch_source_set_timer(_timer,
                              dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_MSEC),
                              30 * NSEC_PER_MSEC,
                              1 * NSEC_PER_MSEC); // leeway
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        [weakSelf tryExecutePendingTasks];
    });

    dispatch_resume(_timer);
}

- (void)tryExecutePendingTasks {
    
    if (os_unfair_lock_trylock(&_unfairLock)) {
        
        if (self.pendingTasks.count <= 0) {
            os_unfair_lock_unlock(&_unfairLock);
            return;
        }
        ACAvoidLockTask *task = self.pendingTasks.pop;
        task.block();
        os_unfair_lock_unlock(&_unfairLock);
    }
}

- (void)executeTask:(ACAvoidLockTask *)task {
    if (os_unfair_lock_trylock(&_unfairLock)) {
        task.block();
        os_unfair_lock_unlock(&_unfairLock);
    } else {
        
        if (!self.mutex_lock_r) {
            task.block();
            return;
        }
        
        pthread_mutex_lock(self.mutex_lock_r);
        
        BOOL exists = [self.pendingTasks indexesOfObjectsPassingTest:^BOOL(ACAvoidLockTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.taskId isEqualToString:task.taskId];
        }].count > 0;
        if (!exists) {
            [self.pendingTasks addObject:task];
        }        
        pthread_mutex_unlock(self.mutex_lock_r);
    }
}

- (pthread_mutex_t *)mutex_lock_r {
    if (!_mutex_lock_r) {
        _mutex_lock_r = malloc(sizeof(pthread_mutex_t));
        if (_mutex_lock_r) {
            pthread_mutexattr_t attr;
            pthread_mutexattr_init(&attr);
            pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
            
            int result = pthread_mutex_init(_mutex_lock_r, &attr);
            if (result != 0) {
                // 初始化失败，清理资源
                free(_mutex_lock_r);
                _mutex_lock_r = NULL;
                NSLog(@"Mutex initialization failed: %d", result);
            }
            pthread_mutexattr_destroy(&attr);
        }
    }
    return _mutex_lock_r;
}

@end
