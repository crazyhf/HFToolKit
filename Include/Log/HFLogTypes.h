//
//  HFLogTypes.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFCommon.h"

///=================================================================

#pragma mark - log level type

HF_ENUM_HEAD(NSUInteger, HFLogLevel)
    
    HFLogLevel_VERBOSE,
    HFLogLevel_DEBUG,
    
    HFLogLevel_INFORMATION,
    
    HFLogLevel_WARNING,
    HFLogLevel_ERROR,
    HFLogLevel_FATAL,

HF_ENUM_TAIL(HFLogLevel)


///=================================================================

#pragma mark - log content type

@interface HFLogContent : NSObject

@property (nonatomic, strong) NSString * tag;

@property (nonatomic, strong) NSString * file;

@property (nonatomic, assign) HFLogLevel level;

@property (nonatomic, strong) NSString * content;

@property (nonatomic, strong) NSString * selector;

@property (nonatomic, strong) NSNumber * lineNumber;


/// 日志内容格式化后的字符串表示
- (NSString *)formatString;

@end
