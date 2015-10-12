//
//  HFLogUtil.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFLogUtil.h"

#import "HFLogFileWriter.h"

@interface HFLogUtil()

@property (nonatomic, strong) optional_log_block_t logBlock;

@property (nonatomic, strong) HFLogFileWriter * logWriter;

@end

@implementation HFLogUtil

#pragma mark - register

+ (void)registerOptionalLogBlock:(optional_log_block_t)logBlock
{
    [HFLogUtil sharedInstance].logBlock = logBlock;
}

+ (void)registerLogPath:(NSString *)logPath
{
    [[HFLogUtil sharedInstance].logWriter openLogWriter:logPath];
}


#pragma mark -

+ (NSString *)currentLogFilePath
{
    return [HFLogUtil sharedInstance].logWriter.currentLogFilePath;
}


#pragma mark - log

+ (void)log:(HFLogLevel)level
     logTag:(NSString *)logTag
       file:(NSString *)file
       line:(NSNumber *)line
   selector:(const char *)selector
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(6, 7)
{
    HFLogContent * logContent = [[HFLogContent alloc] init];
    
    logContent.level = level;
    logContent.tag   = logTag;
    
    logContent.file       = file;
    logContent.lineNumber = line;
    logContent.selector   = [NSString stringWithUTF8String:selector];
    
    va_list args;
    va_start(args, format);
    logContent.content = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    if (nil != [HFLogUtil sharedInstance].logBlock) {
        [HFLogUtil sharedInstance].logBlock(logContent);
    } else {
        [[HFLogUtil sharedInstance].logWriter log:logContent];
    }
}


#pragma mark - singleton

- (id)init
{
    if (self = [super init]) {
        self.logWriter = [[HFLogFileWriter alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self.logWriter closeLogWriter];
    self.logWriter = nil;
}

HF_IMPLEMENTATION_SINGLETON()

@end
