
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

//category
#import "NSObject+AvoidCrash.h"

#import "NSArray+AvoidCrash.h"
#import "NSMutableArray+AvoidCrash.h"

#import "NSDictionary+AvoidCrash.h"
#import "NSMutableDictionary+AvoidCrash.h"

#import "NSString+AvoidCrash.h"
#import "NSMutableString+AvoidCrash.h"

#import "NSAttributedString+AvoidCrash.h"
#import "NSMutableAttributedString+AvoidCrash.h"

//define
#import "AvoidCrashStubProxy.h"
#import <os/lock.h>
#import "pthread.h"
#import "ACAvoidLockTaskQueue.h"

NS_ASSUME_NONNULL_BEGIN
static inline void threadSafe(dispatch_block_t block,os_unfair_lock * _Nonnull lock, bool needLock) {
    if (needLock && os_unfair_lock_trylock(lock)) {
        block();
        os_unfair_lock_unlock(lock);
    } else {
        block();
    }
}

static inline void threadSafe_mutex(dispatch_block_t block, pthread_mutex_t * _Nonnull lock, bool needLock, ACAvoidLockTaskQueue *_Nullable queue) {
    if (queue) {
        ACAvoidLockTask *task = [[ACAvoidLockTask alloc] initWithBlock:block];
        [queue executeTask:task];
    } else {
        if (needLock) {
            pthread_mutex_lock(lock);
            block();
            pthread_mutex_unlock(lock);
        } else {
            block();
        }
    }
}

@interface AvoidCrash : NSObject

+ (void)becomeEffective;


/** 
 *  相比于becomeEffective，增加
 *  对”unrecognized selector sent to instance”防止崩溃的处理
 *
 *  但是必须配合:
 *            setupClassStringsArr:和
 *            setupNoneSelClassStringPrefixsArr
 *            这两个方法可以同时使用
 */
+ (void)makeAllEffective;

+ (void)setupNoneSelClassStringsArr:(NSArray<NSString *> *_Nullable)classStrings;

+ (void)setupNoneSelClassStringPrefixsArr:(NSArray<NSString *> *)classStringPrefixs;

+ (void)exchangeClassMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel;

+ (void)exchangeInstanceMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel;

+ (void)noteErrorWithException:(NSException *)exception defaultToDo:(NSString *)defaultToDo;


@end
NS_ASSUME_NONNULL_END
