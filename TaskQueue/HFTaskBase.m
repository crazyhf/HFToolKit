//
//  HFTaskBase.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/2.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFTaskBase.h"

@implementation HFTaskBase

- (id)copyWithZone:(NSZone *)zone
{
    HFTaskBase * copyInstance = [HFTaskBase allocWithZone:zone];
    if (nil != copyInstance)
    {
        copyInstance.actionParamBlock = self.actionParamBlock;
        copyInstance.finishedBlock = self.finishedBlock;
        copyInstance.actionBlock = self.actionBlock;
    }
    return copyInstance;
}

@end
