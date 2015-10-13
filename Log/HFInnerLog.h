//
//  HFInnerLog.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/13.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#ifndef HFInnerLog_h
#define HFInnerLog_h

#import "HFLogUtil.h"

///=================================================================

#pragma mark - log macro

#if DEBUG
#define HFInnerLogv(...) HFLogv(@"HFToolKit", __VA_ARGS__)

#define HFInnerLogd(...) HFLogd(@"HFToolKit", __VA_ARGS__)
#else
#define HFInnerLogv(...)
#define HFInnerLogd(...)
#endif

#define HFInnerLogi(...) HFLogi(@"HFToolKit", __VA_ARGS__)

#define HFInnerLogw(...) HFLogw(@"HFToolKit", __VA_ARGS__)

#define HFInnerLoge(...) HFLoge(@"HFToolKit", __VA_ARGS__)

#define HFInnerLogf(...) HFLogf(@"HFToolKit", __VA_ARGS__)

#endif /* HFInnerLog_h */
