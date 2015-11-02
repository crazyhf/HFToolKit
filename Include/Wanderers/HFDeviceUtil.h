//
//  HFDeviceUtil.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFCommon.h"


/**
 *  @brief
 *      4X      -->  iphone4, iphone4s          (320x480)
 *      5X      -->  iphone5, iphone5s          (320x568)
 *      6X      -->  iphone6, iphone6s          (375x667)
 *      6XPlus  -->  iphone6Plus, iphone6sPlus  (414x736)
 */
HF_ENUM_HEAD(NSUInteger, HFIPhoneType)
    HFIPhoneType_Unknown,
    HFIPhoneType_4X,
    HFIPhoneType_5X,
    HFIPhoneType_6X,
    HFIPhoneType_6XPlus,
HF_ENUM_TAIL(HFIPhoneType)


@interface HFDeviceUtil : NSObject

+ (CGRect)screenBounds;

+ (HFIPhoneType)iphoneType;

+ (CGRect)screenBounds:(HFIPhoneType)iphoneType;

@end
