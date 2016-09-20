//
//  HFHttpQueue.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/2.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFTaskQueue.h"
#import "HFHttpRequest.h"

@interface HFHttpQueue : NSObject <HFSingleton>

- (void)addRequest:(void(^)(HFHttpRequest * httpRequest))requestBlock
          finished:(void(^)(NSInteger respCode, NSData * respData, NSError * respErr))finishedBlock;

@end
