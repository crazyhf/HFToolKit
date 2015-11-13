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
    NSURL * requestURL = [NSURL URLWithString:[self spliceHttpUrl:httpUrl param:httpParam]];
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


#pragma mark - url utils

- (NSString *)spliceHttpUrl:(NSString *)httpUrl param:(HFHttpParam *)httpParam
{
    NSMutableString * targetUrl = [NSMutableString stringWithFormat:@"%@", httpUrl];
    if (0 != httpParam.paramDictionary.count)
    {
        NSDictionary * aDictionary  = httpParam.paramDictionary;
        NSArray      * allParamKeys = aDictionary.allKeys;
        
        for (NSUInteger index = 0; index < allParamKeys.count; index++) {
            NSString * aParamKey = allParamKeys[index];
            NSObject * aParamVal = aDictionary[aParamKey];
            
            if (index > 0) {
                [targetUrl appendFormat:@"&%@=%@", aParamKey, aParamVal];
            } else {
                [targetUrl appendFormat:@"?%@=%@", aParamKey, aParamVal];
            }
        }
    }
    return targetUrl;
}

@end
