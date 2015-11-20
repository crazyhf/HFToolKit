//
//  HFRandomUtil.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/20.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFRandomUtil.h"

@implementation HFRandomUtil

+ (NSString *)randomAlphanumeric:(NSUInteger)count
{
    char random_buffer[count + 1];
    
    random_buffer[count] = 0;
    while (count-- > 0) {
        random_buffer[count] = self.randomAlphanumeric;
    }
    
    return [NSString stringWithUTF8String:random_buffer];
}

/// (10)0~9, (26)A~Z, (26)a~z
+ (char)randomAlphanumeric
{
    unsigned randomVal = arc4random() % (10 + 26 + 26);
    if (randomVal < 10) { // 0~9
        return '0' + randomVal;
    } else if (randomVal < (10 + 26)) { // A~Z
        return 'A' + randomVal - 10;
    } else {
        return 'a' + randomVal - 10 - 26;
    }
}

@end
