//
//  HFANRDetection.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/24.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFCommon.h"

typedef void(^anr_notify_block_t)(void);


/**
 *  @brief detection for ANR(application not responding)
 */
@interface HFANRDetection : NSObject

- (void)enableDetection;

- (void)setANRNotifyBlock:(anr_notify_block_t)anrNotifyBlock
            dispatchQueue:(dispatch_queue_t)dispatchQueue;


HF_DECLARE_SINGLETON()

@end
