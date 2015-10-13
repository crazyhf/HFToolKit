//
//  HFLogFileWriter.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFLogFileWriter.h"

#import "HFFileUtil.h"
#import "HFSystemUtil.h"
#import "NSDate+DisplayString.h"

@interface HFLogFileWriter()

@property (nonatomic, strong) NSString * logFilePath;

@property (nonatomic, strong) NSFileHandle * logFileHandler;

@end

@implementation HFLogFileWriter

#pragma mark - open/close writer

- (void)openLogWriter:(NSString *)logPath
{
    NSString * logFilePath = [self generateLogFilePath:logPath];
    if (![self.logFilePath isEqualToString:logFilePath]) {
        self.logFilePath = logFilePath;
        
        if (YES == [HFFileUtil createFile:logFilePath overwrite:NO]) {
            [self.logFileHandler closeFile];
            
            self.logFileHandler = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
            [self.logFileHandler seekToEndOfFile];
        }
    }
}

- (void)closeLogWriter
{
    [self.logFileHandler closeFile];
    self.logFileHandler = nil;
}


#pragma mark - log

- (void)log:(HFLogContent *)logContent
{
    [super log:logContent];
}

- (void)asyncFlushLogWriter
{
    ;
}


#pragma mark - current log file path

- (NSString *)currentLogFilePath
{
    return self.logFilePath;
}


#pragma mark - generate log file path

- (NSString *)generateLogFilePath:(NSString *)logPath
{
    return [logPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u/%@.log", [HFSystemUtil processID], [NSDate formatCurrentDate:@"yyyy_MM_dd_HH_mm_ss"]]];
}

@end
