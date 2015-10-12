//
//  NSDate+DisplayString.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "NSDate+DisplayString.h"

@implementation NSDate (DisplayString)

+ (NSString *)formatCurrentDate:(NSString *)dateFormat
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)formatDate:(NSString *)dateFormat
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:self];
}

@end
