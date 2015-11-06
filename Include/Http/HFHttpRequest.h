//
//  HFHttpRequest.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/5.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFHttpParam.h"

@interface HFHttpRequest : NSObject

@property (nonatomic, assign, readonly) NSInteger responseCode;

@property (nonatomic, strong, readonly) NSData * responseData;

@property (nonatomic, strong, readonly) NSError * responseError;


- (void)httpGET:(NSString *)httpUrl param:(HFHttpParam *)httpParam;

- (void)httpPOST:(NSString *)httpUrl param:(HFHttpParam *)httpParam;

@end
