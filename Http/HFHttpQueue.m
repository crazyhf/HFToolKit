//
//  HFHttpQueue.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/2.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFHttpQueue.h"

@interface HFHttpQueue()

@property (nonatomic, strong) HFTaskQueue * concurrentQueue;

@end

@implementation HFHttpQueue

- (id)init
{
    if (self = [super init]) {
        self.concurrentQueue = [[HFTaskQueue alloc] initWithQueueType:HFTaskQueue_Concurrent finishedDispatch:dispatch_get_main_queue()];
    }
    return self;
}

@end
