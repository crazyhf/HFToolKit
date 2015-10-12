//
//  HFLogStdOutWriter.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFLogStdOutWriter.h"

@implementation HFLogStdOutWriter

- (void)openLogWriter:(id)option {}

- (void)closeLogWriter {}


- (void)log:(HFLogContent *)logContent
{
    if (YES == [self isPermitted:logContent]) {
        fprintf(stdout, "%s\n", logContent.formatString.UTF8String);
    }
}

#pragma mark - is permitted to write out

- (BOOL)isPermitted:(HFLogContent *)logContent
{
    return is_HFLogLevel_valid(logContent.level);
}

@end
