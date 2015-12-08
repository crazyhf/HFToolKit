//
//  HFAppHelper.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFAppHelper : NSObject

/**
 *  @brief debug check or anti-debug
 *
 *  @see http://web.mit.edu/freebsd/head/sys/compat/linux/linux_sysctl.c
 *  @see https://developer.apple.com/library/ios/documentation/System/Conceptual/ManPages_iPhoneOS/man3/sysctl.3.html
 *  @see http://www.qnx.com/developers/docs/660/index.jsp?topic=%2Fcom.qnx.doc.neutrino.lib_ref%2Ftopic%2Fs%2Fsysctl.html
 */
+ (BOOL)isAppBeingTraced;

/// check process[processID] is debuging or suspension
+ (BOOL)isDebugingOrSuspension:(uint32_t)processID;

@end
