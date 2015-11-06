//
//  HFHttpRequest.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/5.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFHttpRequest.h"

@implementation HFHttpRequest

- (void)httpGET:(NSString *)httpUrl param:(HFHttpParam *)httpParam
{
    NSURL * requestURL = [NSURL URLWithString:httpUrl];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    NSError * error = nil;
    NSHTTPURLResponse * response = nil;
    _responseData  = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response
                                                       error:&error];
    _responseError = error;
    _responseCode  = response.statusCode;
}

- (void)httpPOST:(NSString *)httpUrl param:(HFHttpParam *)httpParam
{
    ;
}

@end
