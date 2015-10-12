//
//  HFSystemUtil.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFSystemUtil.h"

#import <pthread/pthread.h>


@implementation HFSystemUtil

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)processName
{
    return [NSProcessInfo processInfo].processName;
}

+ (uint32_t)processID
{
    return [NSProcessInfo processInfo].processIdentifier;
}

+ (uint64_t)threadID
{
    uint64_t _thread_id;
    pthread_threadid_np(pthread_self(), &_thread_id);
    return _thread_id;
}

@end
