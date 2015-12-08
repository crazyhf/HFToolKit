//
//  HFAppHelper.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <sys/sysctl.h>
#import <sys/errno.h>

#import "HFAppHelper.h"

#import "HFInnerLog.h"
#import "HFSystemUtil.h"


@implementation HFAppHelper

/**
 *  @extension
 *    int sysctl(int * name, u_int namelen, void * oldp, size_t * oldlenp, void * newp, size_t newlen)
 *
 *    MIB(Management Information Base)
 *
 *    retrieves system information and allows processes with appropriate privileges to set system information.
 *    The size of the available data can be determined by calling sysctl() with the NULL argument for oldp.
 *    The size of the available data will be returned in the location pointed to by oldlenp.
 *
 *    name   : 一个整形数组, 代表了从sysfs根目录开始到目标文件的路径
 *    namelen: name参数中数组元素的个数
 *    oldp   : 一个缓冲区, 内核将信息(也就是name所指定的目标文件内容)保存在这个缓冲区里返回给用户
 *    oldlenp: 传入oldp缓冲区的大小, 返回后被内核用实际返回的信息长度所覆盖
 *    newp   : 如果想要修改该变量, 把新值从这里传入(若name所指定的目标文件是不可修改的, 则该值必须为NULL)
 *    newlen : newp的长度(当newp为NULL时, 这里传入0)
 *    后面四个参数(oldp, oldlenp, newp, newlen)都可以为NULL和0
 *
 *    return : 0(Success)  -1(Error)
 */
+ (BOOL)isAppBeingTraced
{
    int mib[4] = { CTL_KERN, KERN_PROC, KERN_PROC_PID, [HFSystemUtil processID]};
    
//  int mibp[4]; size_t miblen = 4;
//  if (0 == sysctlnametomib("kern.proc.pid", mibp, &miblen)) {
//      HFInnerLogi(@"sysctlnametomib kern.proc.pid");
//  }
//  mib[3] = [HFSystemUtil processID]; //getpid();
    
    BOOL isTraced = NO;
    
    size_t pinfolen;
    if (0 == sysctl(mib, 4, NULL, &pinfolen, NULL, 0)) {
        struct kinfo_proc * pinfo = malloc(pinfolen);
        if (NULL != pinfo) {
            if (0 == sysctl(mib, 4, pinfo, &pinfolen, NULL, 0)) {
                isTraced = (pinfo->kp_proc.p_flag & P_TRACED) ? YES : NO;
            } else {
                int errval = errno;
                HFInnerLoge(@"sysctl failed, error value : %d", errval);
            }
            free(pinfo);
        }
    } else {
        int errval = errno;
        HFInnerLoge(@"sysctl with oldp[NULL] failed, error value : %d", errval);
    }
    return isTraced;
}

+ (BOOL)isDebugingOrSuspension
{
    int mib[4] = { CTL_KERN, KERN_PROC, KERN_PROC_PID, [HFSystemUtil processID] };
    
    BOOL isDebuging = NO;
    
    size_t pinfolen;
    if (0 == sysctl(mib, 4, NULL, &pinfolen, NULL, 0)) {
        struct kinfo_proc * pinfo = malloc(pinfolen);
        if (NULL != pinfo) {
            if (0 == sysctl(mib, 4, pinfo, &pinfolen, NULL, 0)) {
                isDebuging = (SSTOP == pinfo->kp_proc.p_stat) ? YES : NO;
            } else {
                int errval = errno;
                HFInnerLoge(@"sysctl failed, error value : %d", errval);
            }
            free(pinfo);
        }
    } else {
        int errval = errno;
        HFInnerLoge(@"sysctl with oldp[NULL] failed, error value : %d", errval);
    }
    return isDebuging;
}

@end
