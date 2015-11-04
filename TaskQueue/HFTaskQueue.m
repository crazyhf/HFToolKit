//
//  HFTaskQueue.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/2.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFTaskQueue.h"

#import "HFInnerLog.h"


@interface HFTaskQueue()

@property (nonatomic, strong) dispatch_queue_t taskQueue;

@end


@implementation HFTaskQueue

- (id)init
{
    return [self initWithQueueType:HFTaskQueue_Serial];
}

- (id)initWithQueueType:(HFTaskQueueType)queueType
{
    if (self = [super init]) {
        if (NO == is_HFTaskQueueType_valid(queueType)) {
            queueType = HFTaskQueue_Serial;
        }
        
        if (HFTaskQueue_Serial == queueType) {
            self.taskQueue = dispatch_queue_create(ReverseDNSIdentify(HFTaskQueue_SerialQueue), DISPATCH_QUEUE_SERIAL);
        } else {
            self.taskQueue = dispatch_queue_create(ReverseDNSIdentify(HFTaskQueue_ConcurrentQueue), DISPATCH_QUEUE_CONCURRENT);
        }
    }
    return self;
}

@end
