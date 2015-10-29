//
//  HFSystemUtil.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFSystemUtil : NSObject

+ (NSString *)systemVersion;

+ (NSString *)processName;

+ (uint32_t)processID;

+ (uint64_t)threadID;

@end
