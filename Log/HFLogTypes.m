//
//  HFLogTypes.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFLogTypes.h"

#import "HFSystemUtil.h"
#import "NSDate+DisplayString.h"

@implementation HFLogContent

/// yyyy-MM-dd hh:mm:ss.SSS processName[pid:tid] [level][tag][file:line] selector content
- (NSString *)formatString
{
    return [NSString stringWithFormat:@"%@ %@[%u:%llu] [%@][%@][%@:%@] %@ %@", [NSDate formatCurrentDate:@"yyyy-MM-dd HH:mm:ss.SSS"], [HFSystemUtil processName], [HFSystemUtil processID], [HFSystemUtil threadID], self.levelName, self.tag, self.file.lastPathComponent, self.lineNumber, self.selector, self.content];
}

- (NSString *)description
{
    return [self formatString];
}


#pragma mark - private utils

- (NSString *)levelName
{
    switch (self.level) {
        case HFLogLevel_INFORMATION: return @"I";
            
        case HFLogLevel_VERBOSE: return @"V";
            
        case HFLogLevel_WARNING: return @"W";
            
        case HFLogLevel_DEBUG: return @"D";
        case HFLogLevel_ERROR: return @"E";
        case HFLogLevel_FATAL: return @"F";
        
        default: return @"Unknown";
    }
}

@end
