//
//  HFGCDTimer.h
//  HFToolKit
//
//  Created by crazylhf on 16/8/31.
//  Copyright © 2016年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFCommon.h"


@interface HFGCDTimer : NSObject

+ (HFGCDTimer *)scheduleTimer:(NSTimeInterval)anInterval
                  actionBlock:(void(^)(void))anActionBlock
                   willRepeat:(BOOL)willRepeat;

+ (HFGCDTimer *)scheduleTimer:(NSTimeInterval)anInterval
                  actionBlock:(void(^)(void))anActionBlock
                   willRepeat:(BOOL)willRepeat
                dispatchQueue:(dispatch_queue_t)aDispatchQueue;

- (void)start;

- (void)stop;

- (void)suspend;

- (BOOL)isValid;


#pragma mark - initialization

- (id)initWithInterval:(NSTimeInterval)anInterval
           actionBlock:(void(^)(void))anActionBlock
            willRepeat:(BOOL)willRepeat;

- (id)initWithInterval:(NSTimeInterval)anInterval
           actionBlock:(void(^)(void))anActionBlock
            willRepeat:(BOOL)willRepeat
         dispatchQueue:(dispatch_queue_t)aDispatchQueue;

@end
