//
//  HFSystemUtil.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

///=================================================================

#pragma mark - IOS System Version Macro

#define HF_IOSSystem6_0Later    ([HFSystemUtil systemVersion].doubleValue >= 6.0)
#define HF_IOSSystem7_0Later    ([HFSystemUtil systemVersion].doubleValue >= 7.0)
#define HF_IOSSystem8_0Later    ([HFSystemUtil systemVersion].doubleValue >= 8.0)
#define HF_IOSSystem9_0Later    ([HFSystemUtil systemVersion].doubleValue >= 9.0)


///=================================================================

#pragma mark - HFSystemUtil

@interface HFSystemUtil : NSObject

+ (NSString *)systemVersion;

+ (NSString *)processName;

+ (uint32_t)processID;

+ (uint64_t)threadID;

@end
