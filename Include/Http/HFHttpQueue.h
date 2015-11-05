//
//  HFHttpQueue.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/2.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFTaskQueue.h"
#import "HFHttpRequest.h"

@interface HFHttpQueue : NSObject

- (void)getRequest:(void(^)(HFHttpRequest *))requestBlock finished:(void(^)(id))finishedBlock;

- (void)postRequest:(void(^)(HFHttpRequest *))requestBlock finished:(void(^)(id))finishedBlock;

@end
