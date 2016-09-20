//
//  HFANRDetection.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/24.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFANRDetection.h"

#import "HFInnerLog.h"
#import "HFAppHelper.h"

#define IHFANRDetectionInterval      (2)
#define IHFANRDetectionBlockCount    (2)


///=================================================================

#pragma mark - HFANRDetection

@implementation HFANRDetection
{
    BOOL _isDetecting;
    
    NSLock * _lockHandler;
    
    NSMutableArray * _detectRecords;
    
    dispatch_queue_t _detectionQueue;
    
    
    anr_notify_block_t _anrNotifyBlock;
    dispatch_queue_t   _notifyDispatchQueue;
}

- (void)enableDetection
{
    if (NO == [NSThread isMainThread]) {
        HFInnerLoge(@"enableDetection must be called in main thread!");
    } else if (YES == _isDetecting) {
        HFInnerLogw(@"is detecting");
    } else {
        _isDetecting = YES;
        HFInnerLogi(@"begin to detect");
        
        [self responseDetection];
        
        [self scheduleDetection];
    }
}

- (void)setANRNotifyBlock:(void(^)(void))anrNotifyBlock
            dispatchQueue:(dispatch_queue_t)dispatchQueue
{
    _anrNotifyBlock = anrNotifyBlock;
    _notifyDispatchQueue = dispatchQueue;
}


#pragma mark - detection and response

- (void)scheduleDetection
{
    dispatch_async(_detectionQueue, ^{
        NSTimer * scheduleTimer = [NSTimer timerWithTimeInterval:IHFANRDetectionInterval target:self selector:@selector(realANRDetection) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:scheduleTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)responseDetection
{
    [self performSelector:_cmd withObject:nil afterDelay:IHFANRDetectionInterval];
    
    [self replyDetectRecord];
}

- (void)realANRDetection
{
    NSMutableArray * aRecordList = [self detectRecordsCopy];
    
    [self sendDetectRecord];
    
    if (aRecordList.count >= IHFANRDetectionBlockCount) {
        HFInnerLogi(@"unprocessed ANR detection records : %lu", (unsigned long)aRecordList.count);
        
        [self regressDetectRecord];
        
        if (YES == [HFAppHelper isAppBeingTraced]) {
            HFInnerLogi(@"the app is being traced, don't need to notify the anr");
        }
        else if (nil != _anrNotifyBlock && nil != _notifyDispatchQueue) {
            anr_notify_block_t aNotifyBlock = _anrNotifyBlock;
            dispatch_async(_notifyDispatchQueue, ^{
                aNotifyBlock();
            });
        }
    }
}


#pragma mark - handle detect record

- (void)sendDetectRecord
{
    [_lockHandler lock];
    
    unsigned long aRecordIdentifier = [NSDate date].timeIntervalSince1970 * 1000;
    [_detectRecords addObject:[NSString stringWithFormat:@"%lu", aRecordIdentifier]];
    
    [_lockHandler unlock];
}

- (void)replyDetectRecord
{
    [_lockHandler lock];
    
    if (0 != _detectRecords.count) {
        [_detectRecords removeObjectAtIndex:0];
    }
    
    [_lockHandler unlock];
}

- (void)regressDetectRecord
{
    [_lockHandler lock];
    
    if (_detectRecords.count > IHFANRDetectionBlockCount) {
        [_detectRecords removeObjectsInRange:NSMakeRange(0, _detectRecords.count - IHFANRDetectionBlockCount)];
    }
    
    [_lockHandler unlock];
}

- (NSMutableArray *)detectRecordsCopy
{
    NSMutableArray * recordsCopy = nil;
    
    [_lockHandler lock];
    recordsCopy = [[NSMutableArray alloc] initWithArray:_detectRecords copyItems:YES];
    [_lockHandler unlock];
    
    return recordsCopy;
}


#pragma mark - singleton

- (id)init
{
    if (self = [super init]) {
        _detectRecords  = [NSMutableArray array];
        
        _lockHandler    = [[NSLock alloc] init];
        
        _isDetecting    = NO;
        _detectionQueue = dispatch_queue_create(ReverseDNSIdentify(HFANRDetection_Queue), DISPATCH_QUEUE_SERIAL);
        
        _anrNotifyBlock = nil;
        _notifyDispatchQueue = nil;
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


@singleton

@end
