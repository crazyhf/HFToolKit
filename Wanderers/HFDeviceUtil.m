//
//  HFDeviceUtil.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFDeviceUtil.h"

@implementation HFDeviceUtil

+ (CGRect)screenBounds { return [[UIScreen mainScreen] bounds]; }

+ (HFIPhoneType)iphoneType
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (CGRectEqualToRect(screenBounds, [self screenBounds:HFIPhoneType_4X])) {
        return HFIPhoneType_4X;
    } else if (CGRectEqualToRect(screenBounds, [self screenBounds:HFIPhoneType_5X])) {
        return HFIPhoneType_5X;
    } else if (CGRectEqualToRect(screenBounds, [self screenBounds:HFIPhoneType_6X])) {
        return HFIPhoneType_6X;
    } else if (CGRectEqualToRect(screenBounds, [self screenBounds:HFIPhoneType_6XPlus])) {
        return HFIPhoneType_6XPlus;
    } else {
        return HFIPhoneType_Unknown;
    }
}

+ (CGRect)screenBounds:(HFIPhoneType)iphoneType
{
    switch (iphoneType) {
        case HFIPhoneType_4X: return CGRectMake(0, 0, 320, 480);
        case HFIPhoneType_5X: return CGRectMake(0, 0, 320, 568);
        case HFIPhoneType_6X: return CGRectMake(0, 0, 375, 667);
        case HFIPhoneType_6XPlus: return CGRectMake(0, 0, 414, 736);
        default: return CGRectZero;
    }
}

@end
