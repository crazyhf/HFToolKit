//
//  HFGCDTimer.m
//  HFToolKit
//
//  Created by crazylhf on 16/8/31.
//  Copyright © 2016年 crazylhf. All rights reserved.
//

#import "HFGCDTimer.h"


@interface HFGCDTimer()

@property (nonatomic, strong) dispatch_source_t dispatchTimer;

@property (nonatomic, assign) NSTimeInterval interval;

@property (nonatomic, assign) BOOL isSuspended;

@property (nonatomic, assign) BOOL willRepeat;

@end

@implementation HFGCDTimer

+ (HFGCDTimer *)scheduleTimer:(NSTimeInterval)anInterval
                  actionBlock:(void(^)(void))anActionBlock
                   willRepeat:(BOOL)willRepeat
{
    HFGCDTimer * aGCDTimer = [[self alloc] initWithInterval:anInterval
                                                actionBlock:anActionBlock
                                                 willRepeat:willRepeat];
    [aGCDTimer start];
    return aGCDTimer;
}

+ (HFGCDTimer *)scheduleTimer:(NSTimeInterval)anInterval
                  actionBlock:(void(^)(void))anActionBlock
                   willRepeat:(BOOL)willRepeat
                dispatchQueue:(dispatch_queue_t)aDispatchQueue
{
    HFGCDTimer * aGCDTimer = [[self alloc] initWithInterval:anInterval
                                                actionBlock:anActionBlock
                                                 willRepeat:willRepeat
                                              dispatchQueue:aDispatchQueue];
    [aGCDTimer start];
    return aGCDTimer;
}

- (void)start
{
    if (NO == self.isValid || NO == self.isSuspended) return;
    
    self.isSuspended = NO;
    
    uint64_t anInterval = self.interval * NSEC_PER_SEC;
    
    dispatch_time_t aStartTime = dispatch_time(DISPATCH_TIME_NOW,
                                               (int64_t)anInterval);
    if (YES == self.willRepeat) {
        dispatch_source_set_timer(self.dispatchTimer,
                                  aStartTime,
                                  anInterval, 0);
    } else {
        dispatch_source_set_timer(self.dispatchTimer,
                                  aStartTime,
                                  DISPATCH_TIME_FOREVER, 0);
    }
    
    dispatch_resume(self.dispatchTimer);
}

- (void)stop
{
    if (YES == self.isValid) {
        dispatch_source_cancel(self.dispatchTimer);
    }
}

- (void)suspend
{
    if (YES == self.isValid && NO == self.isSuspended) {
        dispatch_suspend(self.dispatchTimer);
        self.isSuspended = YES;
    }
}

- (BOOL)isValid
{
    return (nil != self.dispatchTimer
            && 0 == dispatch_source_testcancel(self.dispatchTimer));
}


#pragma mark - initialization

- (id)init
{
    if (self = [super init]) {
        _dispatchTimer = nil;
        _willRepeat    = NO;
        _interval      = 0;
        _isSuspended   = NO;
    }
    return self;
}

- (id)initWithInterval:(NSTimeInterval)anInterval
           actionBlock:(void(^)(void))anActionBlock
            willRepeat:(BOOL)willRepeat
{
    return [self initWithInterval:anInterval
                      actionBlock:anActionBlock
                       willRepeat:willRepeat
                    dispatchQueue:dispatch_get_main_queue()];
}

- (id)initWithInterval:(NSTimeInterval)anInterval
           actionBlock:(void(^)(void))anActionBlock
            willRepeat:(BOOL)willRepeat
         dispatchQueue:(dispatch_queue_t)aDispatchQueue
{
    if (self = [super init]) {
        _dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                0, 0, aDispatchQueue);
        
        dispatch_source_t aDispatchTimer = _dispatchTimer;
        dispatch_source_set_event_handler(aDispatchTimer, ^{
            if (NO == willRepeat) {
                dispatch_source_cancel(aDispatchTimer);
            }
            
            HFInvoke4Block(anActionBlock) {
                anActionBlock();
            };
        });
        
        _willRepeat  = willRepeat;
        _interval    = anInterval;
        _isSuspended = YES;
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

@end
