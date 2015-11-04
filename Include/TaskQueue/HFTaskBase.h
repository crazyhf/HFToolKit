//
//  HFTaskBase.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/2.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HFTaskBase : NSObject <NSCopying>

@property (nonatomic, weak) id(^actionParamBlock)(void);

@property (nonatomic, strong) id(^actionBlock)(id actionParam);

@property (nonatomic, strong) void(^finishedBlock)(id taskResult);

@end
