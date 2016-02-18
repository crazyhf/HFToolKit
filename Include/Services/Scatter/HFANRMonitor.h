//
//  HFANRMonitor.h
//  HFToolKit
//
//  Created by crazylhf on 16/2/18.
//  Copyright © 2016年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFCommon.h"


typedef void(^anr_notify_handle_t)(NSTimeInterval blockDuration);


/**
 *  @brief detection for ANR(application not responding) by means of CFRunLoopAddObserver
 */
@interface HFANRMonitor : NSObject

@property (nonatomic, assign) NSTimeInterval anrThreshold;

- (void)setANRNotifyHandler:(anr_notify_handle_t)anrNotifyHandler
              dispatchQueue:(dispatch_queue_t)dispatchQueue;

- (void)enableMonitor;

- (void)disableMonitor;

HF_DECLARE_SINGLETON()

@end
