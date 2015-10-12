//
//  HFLogUtil.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFLogTypes.h"

///=================================================================

#pragma mark - log macro

#if DEBUG
#define HFLogv(tag, ...) \
            [HFLogUtil log:HFLogLevel_VERBOSE logTag:tag file:@__FILE__ \
                      line:@(__LINE__) selector:__FUNCTION__ format:__VA_ARGS__]

#define HFLogd(tag, ...) \
            [HFLogUtil log:HFLogLevel_DEBUG logTag:tag file:@__FILE__ \
                      line:@(__LINE__) selector:__FUNCTION__ format:__VA_ARGS__]
#else
#define HFLogv(tag, ...)
#define HFLogd(tag, ...)
#endif

#define HFLogi(tag, ...) \
            [HFLogUtil log:HFLogLevel_INFORMATION logTag:tag file:@__FILE__ \
                      line:@(__LINE__) selector:__FUNCTION__ format:__VA_ARGS__]

#define HFLogw(tag, ...) \
            [HFLogUtil log:HFLogLevel_WARNING logTag:tag file:@__FILE__ \
                      line:@(__LINE__) selector:__FUNCTION__ format:__VA_ARGS__]

#define HFLoge(tag, ...) \
            [HFLogUtil log:HFLogLevel_ERROR logTag:tag file:@__FILE__ \
                      line:@(__LINE__) selector:__FUNCTION__ format:__VA_ARGS__]

#define HFLogf(tag, ...) \
            [HFLogUtil log:HFLogLevel_FATAL logTag:tag file:@__FILE__ \
                      line:@(__LINE__) selector:__FUNCTION__ format:__VA_ARGS__]


///=================================================================

#pragma mark - log util

/**
 *  @brief
 *      optional_log_block_t can't use to output the log content
 *      by means of customized method
 */
typedef void (^optional_log_block_t)(HFLogContent * logContent);


@interface HFLogUtil : NSObject

/// register the customized output method for log content
+ (void)registerOptionalLogBlock:(optional_log_block_t)logBlock;

/// register log file output path
+ (void)registerLogPath:(NSString *)logPath;


+ (NSString *)currentLogFilePath;


+ (void)log:(HFLogLevel)level
     logTag:(NSString *)logTag
       file:(NSString *)file
       line:(NSNumber *)line
   selector:(const char *)selector
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(6, 7);

@end
