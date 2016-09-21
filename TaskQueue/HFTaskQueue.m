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

@property (nonatomic, strong) dispatch_queue_t finishedQueue;

@property (nonatomic, strong) dispatch_queue_t taskQueue;

@property (nonatomic, strong) NSMutableArray * taskList;

@property (nonatomic, strong) NSLock * mutexLock;

@end


@implementation HFTaskQueue

- (void)recycleScheduleTask
{
    if (YES == self.isTaskListEmpty) return;
    
    @weakSelf();
    dispatch_async(self.taskQueue, ^{
        HFTaskBase * taskBase = [weakSelf popTask];
        while (nil != taskBase)
        {
            id taskResult = nil;
            if (nil != taskBase.actionBlock) {
                if (nil == taskBase.actionParamBlock) {
                    taskResult = taskBase.actionBlock(nil);
                } else {
                    taskResult = taskBase.actionBlock(taskBase.actionParamBlock());
                }
            }
            
            if (nil != taskBase.finishedBlock) {
                dispatch_async(weakSelf.finishedQueue, ^{
                    taskBase.finishedBlock(taskResult);
                });
            }
            
            taskBase = [weakSelf popTask];
        }
    });
}


#pragma mark - task list handle

- (void)pushTask:(HFTaskBase *)taskBase
{
    [self.mutexLock lock];
    [self.taskList addObject:taskBase.copy];
    [self.mutexLock unlock];
    
    [self recycleScheduleTask];
}

- (HFTaskBase *)popTask
{
    HFTaskBase * taskBase = nil;
    
    [self.mutexLock lock];
    
    if (0 != self.taskList.count) {
        taskBase = self.taskList.firstObject;
        [self.taskList removeObjectAtIndex:0];
    }
    
    [self.mutexLock unlock];
    
    return taskBase;
}

- (BOOL)isTaskListEmpty
{
    BOOL isEmpty = YES;
    
    [self.mutexLock lock];
    isEmpty = (0 == self.taskList.count);
    [self.mutexLock unlock];
    
    return isEmpty;
}


#pragma mark - initialization

- (id)init
{
    return [self initWithQueueType:HFTaskQueue_Serial
                  finishedDispatch:dispatch_get_main_queue()];
}

- (id)initWithQueueType:(HFTaskQueueType)queueType finishedDispatch:(dispatch_queue_t)finishedQueue
{
    if (self = [super init]) {
        if (NO == is_HFTaskQueueType_valid(queueType)) {
            queueType = HFTaskQueue_Serial;
        }
        
        self.taskList = [NSMutableArray array];
        
        self.mutexLock = [[NSLock alloc] init];
        
        if (HFTaskQueue_Serial == queueType) {
            self.taskQueue = dispatch_queue_create(ReverseDNSIdentify(HFTaskQueue_SerialQueue), DISPATCH_QUEUE_SERIAL);
        } else {
            self.taskQueue = dispatch_queue_create(ReverseDNSIdentify(HFTaskQueue_ConcurrentQueue), DISPATCH_QUEUE_CONCURRENT);
        }
        
        self.finishedQueue = finishedQueue;
    }
    return self;
}

@end
