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

#define IHFLogDataCacheMaxSize       (1024)

#define IHFLogDataFlushInterval      (10)


@interface HFLogFileWriter()

@property (nonatomic, strong) NSString * logFilePath;

@property (nonatomic, strong) NSMutableData * logDataCache;

@property (nonatomic, strong) NSFileHandle * logFileHandler;

@property (nonatomic, strong) dispatch_queue_t logWriterQueue;

@end

@implementation HFLogFileWriter

#pragma mark - open/close writer

- (void)openLogWriter:(NSString *)logPath
{
    NSString * logFilePath = [self generateLogFilePath:logPath];
    if (![self.logFilePath isEqualToString:logFilePath]) {
        [self closeLogWriter];
        
        if (YES == [HFFileUtil createFile:logFilePath overwrite:NO]) {
            self.logFilePath = logFilePath;
            
            self.logFileHandler = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        }
    } else if (nil == self.logFileHandler){
        self.logFileHandler = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    }
}

- (void)closeLogWriter
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recycleAsyncFlushLogCache) object:nil];
    
    [self asyncFlushLogCache];
    
    if (nil != self.logFileHandler) {
        NSFileHandle * aLogFileHandler = self.logFileHandler;
        dispatch_async(self.logWriterQueue, ^{
            [aLogFileHandler closeFile];
        });
        
        self.logFileHandler = nil;
    }
}


#pragma mark - log

- (void)log:(HFLogContent *)logContent
{
    NSString * strContent = [NSString stringWithFormat:@"%@\n", logContent.formatString];
    
    fprintf(stdout, "%s", strContent.UTF8String);
    
    if (YES == [self isPermitted:logContent]) {
        [self.logDataCache appendBytes:strContent.UTF8String
                                length:[strContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (self.logDataCache.length >= IHFLogDataCacheMaxSize) {
        [self recycleAsyncFlushLogCache];
    }
}

- (void)recycleAsyncFlushLogCache
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
    
    [self asyncFlushLogCache];
    
    [self performSelector:_cmd withObject:nil afterDelay:IHFLogDataFlushInterval];
}

- (void)asyncFlushLogCache
{
    if (nil != self.logFileHandler && 0 != self.logDataCache.length) {
        NSData * logDataCopy = self.logDataCache.copy;
        self.logDataCache = [NSMutableData dataWithCapacity:IHFLogDataCacheMaxSize];
        
        NSFileHandle * aLogFileHandler = self.logFileHandler;
        dispatch_async(self.logWriterQueue, ^{
            [aLogFileHandler seekToEndOfFile];
            [aLogFileHandler writeData:logDataCopy];
            [aLogFileHandler synchronizeFile];
        });
    }
}


#pragma mark - is permitted to write out

- (BOOL)isPermitted:(HFLogContent *)logContent
{
    return is_HFLogLevel_valid(logContent.level)
           && logContent.level > HFLogLevel_DEBUG;
}


#pragma mark - current log file path

- (NSString *)currentLogFilePath
{
    return self.logFilePath;
}


#pragma mark - generate log file path

- (NSString *)generateLogFilePath:(NSString *)logPath
{
    return [logPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%u.log", [NSDate formatCurrentDate:@"yyyy_MM_dd/HH_mm_ss_SSS"], [HFSystemUtil processID]]];
}


#pragma mark - initialization

- (id)init
{
    if (self = [super init]) {
        self.logDataCache = [NSMutableData dataWithCapacity:IHFLogDataCacheMaxSize];
        self.logWriterQueue = dispatch_queue_create(ReverseDNSIdentify(HFLogFileWriter_Queue), DISPATCH_QUEUE_SERIAL);
        
        [self recycleAsyncFlushLogCache];
    }
    return self;
}

@end
