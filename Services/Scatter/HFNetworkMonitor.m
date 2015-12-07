//
//  HFNetworkMonitor.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/11.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <netinet/in.h>

#import "HFNetworkMonitor.h"

#import "HFSystemUtil.h"
#import "HFInnerLog.h"

DefineNotificationName(STRHFNetworkMonitorNotify);

@interface HFNetworkMonitor()

- (void)notifyNetworkReachabilityChanged:(SCNetworkConnectionFlags)flags;

@end


///=================================================================

#pragma mark - Network Reachability Callback

static void HFNetworkReachabilityCallback(SCNetworkReachabilityRef target,
                                          SCNetworkReachabilityFlags flags, void * info)
{
    [[HFNetworkMonitor sharedInstance] notifyNetworkReachabilityChanged:flags];
}


///=================================================================

#pragma mark - HFNetworkMonitor

@implementation HFNetworkMonitor
{
    SCNetworkReachabilityRef _networkReachabilityRef;
}

- (BOOL)enableMonitor
{
    if (NO == self.isMonitoring) {
        SCNetworkReachabilityContext reachabilityContext = {0, (__bridge void *)self, NULL, NULL, NULL};
        
        if (TRUE == SCNetworkReachabilitySetCallback(_networkReachabilityRef, HFNetworkReachabilityCallback, &reachabilityContext)) {
            if (TRUE == SCNetworkReachabilitySetDispatchQueue(_networkReachabilityRef, dispatch_get_main_queue())) {
                self.isMonitoring = YES;
            } else {
                HFInnerLoge(@"SCNetworkReachabilitySetDispatchQueue(%p, dispatch_get_main_queue()) failed", _networkReachabilityRef);
            }
        } else {
            HFInnerLoge(@"SCNetworkReachabilitySetCallback failed, _networkReachabilityRef : %p", _networkReachabilityRef);
        }
        return self.isMonitoring;
    }
    
    HFInnerLogw(@"HFNetworkMonitor isMonitoring[YES]");
    return self.isMonitoring;
}

- (BOOL)disableMonitor
{
    if (YES == self.isMonitoring) {
        if (TRUE == SCNetworkReachabilitySetDispatchQueue(_networkReachabilityRef, nil)) {
            self.isMonitoring = NO;
        } else {
            HFInnerLoge(@"SCNetworkReachabilitySetDispatchQueue(%p, nil) failed", _networkReachabilityRef);
        }
    }
    return !self.isMonitoring;
}


#pragma mark - force detect network

- (HFNetworkType)forceDetectNetwork
{
    HFNetworkType aNetworkType = HFNetwork_NotReachable;
 
    SCNetworkReachabilityRef aReachabilityRef = [self NetworkReachability:@"www.baidu.com"];
    if (NULL != aReachabilityRef) {
        SCNetworkReachabilityFlags networkFlags;
        if (TRUE == SCNetworkReachabilityGetFlags(aReachabilityRef, &networkFlags)) {
            aNetworkType = [self parseNetworkReachabilityFlags:networkFlags];
            self.networkType = aNetworkType;
        } else {
            HFInnerLoge(@"SCNetworkReachabilityGetFlags failed");
        }
        CFRelease(aReachabilityRef);
    } else {
        HFInnerLoge(@"generate NetworkReachability with www.baidu.com failed");
    }
    return aNetworkType;
}


#pragma mark - generate network reachability

- (SCNetworkReachabilityRef)NetworkReachability
{
    struct sockaddr_in address;
    bzero(&address, sizeof(struct sockaddr_in));
    
    address.sin_len = sizeof(struct sockaddr_in);
    address.sin_family = AF_INET;
    
    return SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&address);
}

- (SCNetworkReachabilityRef)NetworkReachability:(NSString *)nodeName
{
    return SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, nodeName.UTF8String);
}


#pragma mark -

- (void)notifyNetworkReachabilityChanged:(SCNetworkConnectionFlags)flags
{
    self.networkType = [self parseNetworkReachabilityFlags:flags];
    
    [HF_NotifyCenter postNotificationName:STRHFNetworkMonitorNotify object:self];
}


#pragma mark - parse network reachability flags

- (HFNetworkType)parseNetworkReachabilityFlags:(SCNetworkReachabilityFlags)flags
{
    HFNetworkType aNetworkType = HFNetwork_NotReachable;
    
    if (flags & kSCNetworkReachabilityFlagsReachable)
    {
        if (0 == (flags & kSCNetworkReachabilityFlagsConnectionRequired)) {
            aNetworkType = HFNetwork_WIFI;
        }
        
        if ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) || (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)) {
            if (0 == (flags & kSCNetworkReachabilityFlagsInterventionRequired)) {
                aNetworkType = HFNetwork_WIFI;
            }
        }
        
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
            /**
             *  @see http://www.jianshu.com/p/845472a0293e
             */
            if (HF_IOSSystem7_0Later) {
                CTTelephonyNetworkInfo * aNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
                if (0 != aNetworkInfo.currentRadioAccessTechnology.length)
                {
                    if ([aNetworkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]
                        || [aNetworkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]
                        || [aNetworkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
                        aNetworkType = HFNetwork_2G;
                    } else if ([aNetworkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
                        aNetworkType = HFNetwork_4G;
                    } else {
                        /**
                         *  CTRadioAccessTechnologyWCDMA
                         *  CTRadioAccessTechnologyHSDPA
                         *  CTRadioAccessTechnologyHSUPA
                         *  CTRadioAccessTechnologyeHRPD
                         *  CTRadioAccessTechnologyCDMAEVDORev0
                         *  CTRadioAccessTechnologyCDMAEVDORevA
                         *  CTRadioAccessTechnologyCDMAEVDORevB
                         */
                        aNetworkType = HFNetwork_3G;
                    }
                    
                    return aNetworkType;
                }
            }
            
            aNetworkType = HFNetwork_2G;
            if (flags & kSCNetworkReachabilityFlagsTransientConnection) {
                aNetworkType = HFNetwork_3G;
                if (flags & kSCNetworkReachabilityFlagsIsLocalAddress || flags & kSCNetworkReachabilityFlagsConnectionRequired) {
                    aNetworkType = HFNetwork_2G;
                }
            }
        }
    }
    return aNetworkType;
}


#pragma mark - singleton

- (id)init
{
    if (self = [super init]) {
        self.networkType = HFNetwork_NotReachable;
        
        _networkReachabilityRef = [self NetworkReachability];
        HFInnerLogi(@"generate _networkReachabilityRef : %p", _networkReachabilityRef);
    }
    return self;
}

- (void)dealloc
{
    if (NULL != _networkReachabilityRef) {
        CFRelease(_networkReachabilityRef);
        _networkReachabilityRef = NULL;
    }
}

HF_IMPLEMENTATION_SINGLETON()

@end
