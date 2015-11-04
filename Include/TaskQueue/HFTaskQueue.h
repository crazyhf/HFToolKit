//
//  HFTaskQueue.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/2.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFTaskBase.h"
#import "HFCommon.h"

HF_ENUM_HEAD(NSUInteger, HFTaskQueueType)
    HFTaskQueue_Serial,
    HFTaskQueue_Concurrent,
HF_ENUM_TAIL(HFTaskQueueType)


@interface HFTaskQueue : NSObject

- (void)pushTask:(HFTaskBase *)taskBase;

- (id)initWithQueueType:(HFTaskQueueType)queueType
       finishedDispatch:(dispatch_queue_t)finishedQueue;

@end
