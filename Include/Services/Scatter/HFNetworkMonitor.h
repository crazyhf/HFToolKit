//
//  HFNetworkMonitor.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/11.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFCommon.h"

ExternNotificationName(STRHFNetworkMonitorNotify, brief("nofity when the network type changed"));

HF_ENUM_HEAD(NSUInteger, HFNetworkType)
    HFNetwork_NotReachable,
    HFNetwork_WIFI,
    HFNetwork_4G,
    HFNetwork_3G,
    HFNetwork_2G,
HF_ENUM_TAIL(HFNetworkType)


/**
 *  @brief network state monitor
 */
@interface HFNetworkMonitor : NSObject

@property (nonatomic, assign) BOOL isMonitoring;

@property (nonatomic, assign) HFNetworkType networkType;


- (BOOL)enableMonitor;

- (BOOL)disableMonitor;


- (HFNetworkType)forceDetectNetwork;


#pragma mark - singleton

HF_DECLARE_SINGLETON()

@end
