//
//  HFANRMonitor.m
//  HFToolKit
//
//  Created by crazylhf on 16/2/18.
//  Copyright © 2016年 crazylhf. All rights reserved.
//

#import "HFANRMonitor.h"
#import "HFInnerLog.h"

#import <mach/mach_time.h>

@interface HFANRMonitor()

@property (nonatomic, assign) uint64_t startTick;

@property (nonatomic, assign) NSTimeInterval secondsPerTick;

@property (nonatomic, assign) CFRunLoopObserverRef observerHandler;


@property (nonatomic, strong) anr_notify_handle_t anrNotifyHandler;
@property (nonatomic, strong) dispatch_queue_t   notifyDispatchQueue;

@end


@implementation HFANRMonitor

- (void)setANRNotifyHandler:(anr_notify_handle_t)anrNotifyHandler
              dispatchQueue:(dispatch_queue_t)dispatchQueue
{
    _anrNotifyHandler = anrNotifyHandler;
    
    if (nil != dispatchQueue) {
        _notifyDispatchQueue = dispatchQueue;
    }
}


#pragma mark - anr handle

- (void)addRunLoopANRObserver
{
    HFWeakSelf();
    _observerHandler = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        if (nil == hfWeakSelf) return;
        
        switch (activity) {
            case kCFRunLoopEntry: case kCFRunLoopBeforeTimers:
            case kCFRunLoopBeforeSources: case kCFRunLoopAfterWaiting:
            {
                if (0 == hfWeakSelf.startTick) {
                    hfWeakSelf.startTick = mach_absolute_time();
                }
                break;
            }
                
            case kCFRunLoopExit: case kCFRunLoopBeforeWaiting:
            {
                uint64_t elapsedTick = mach_absolute_time() - hfWeakSelf.startTick;
                
                NSTimeInterval elapsedDuration = (NSTimeInterval)elapsedTick * hfWeakSelf.secondsPerTick;
                if (elapsedDuration > hfWeakSelf.anrThreshold) {
                    [hfWeakSelf notifyMainThreadANR:elapsedDuration];
                }
                
                hfWeakSelf.startTick = 0;
                break;
            }
                
            default: break;
        }
    });
    
    if (NULL != _observerHandler) {
        CFRunLoopAddObserver(CFRunLoopGetMain(), _observerHandler, kCFRunLoopCommonModes);
    }
}


- (void)notifyMainThreadANR:(NSTimeInterval)blockDuration
{
    if (nil != self.anrNotifyHandler) {
        self.anrNotifyHandler(blockDuration);
    }
    HFInnerLogi(@"main thread was blocked for %lf seconds", blockDuration);
}

#pragma mark - calculate

- (BOOL)calculateSecondsPerTick
{
    mach_timebase_info_data_t timebaseData = {0, 0};
    kern_return_t kern_res = mach_timebase_info(&timebaseData);
    
    if (0 != timebaseData.denom) {
        _secondsPerTick = (NSTimeInterval)timebaseData.numer / (NSTimeInterval)timebaseData.denom / (NSTimeInterval)1.0e9;
    } else {
        _secondsPerTick = 0;
        HFInnerLogw(@"calculate seconds per tick failed, timebaseData.denom is 0, mach_timebase_info result is %d", kern_res);
    }
    
    return (_secondsPerTick != 0);
}


#pragma mark - initialization

- (id)init
{
    if (self = [super init]) {
        _anrThreshold    = 0.2;
        
        _startTick       = 0;
        _secondsPerTick  = 0;
        _observerHandler = NULL;
        
        _anrNotifyHandler    = nil;
        _notifyDispatchQueue = dispatch_queue_create(ReverseDNSIdentify(HFANRMonitor_Notify_Queue), DISPATCH_QUEUE_SERIAL);
        
        if (YES == [self calculateSecondsPerTick]) {
            [self addRunLoopANRObserver];
        }
    }
    return self;
}

- (void)dealloc
{
    if (NULL != _observerHandler) {
        CFRunLoopObserverInvalidate(_observerHandler);
    }
}

HF_IMPLEMENTATION_SINGLETON()

@end
