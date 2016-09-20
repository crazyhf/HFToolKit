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

- (void)addRequest:(void(^)(HFHttpRequest *))requestBlock
          finished:(void(^)(NSInteger, NSData *, NSError *))finishedBlock
{
    HFTaskBase * httpTask = [[HFTaskBase alloc] init];
    httpTask.actionParamBlock = (id)^(void){
        return [[HFHttpRequest alloc] init];
    };
    httpTask.actionBlock = (id)^(HFHttpRequest * request) {
        requestBlock(request);
        return request;
    };
    httpTask.finishedBlock = ^(HFHttpRequest * request) {
        finishedBlock(request.responseCode, request.responseData, request.responseError);
    };
    
    [self.concurrentQueue pushTask:httpTask];
}


#pragma mark - singleton

- (id)init
{
    if (self = [super init]) {
        self.concurrentQueue = [[HFTaskQueue alloc] initWithQueueType:HFTaskQueue_Concurrent finishedDispatch:dispatch_get_main_queue()];
    }
    return self;
}

@singleton

@end
