//
//  HFRandomUtil.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/20.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFRandomUtil : NSObject

+ (NSString *)randomAlphanumeric:(NSUInteger)count;

/// (10)0~9, (26)A~Z, (26)a~z
+ (char)randomAlphanumeric;

@end
