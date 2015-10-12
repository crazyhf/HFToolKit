//
//  NSDate+DisplayString.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief NSDate Extension : generate format string for display
 */
@interface NSDate (DisplayString)

+ (NSString *)formatCurrentDate:(NSString *)dateFormat;

- (NSString *)formatDate:(NSString *)dateFormat;

@end
