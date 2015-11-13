//
//  HFHttpRequest.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/5.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFHttpRequest.h"

#import "HFInnerLog.h"

#import "HFEncodeHelper.h"


@implementation HFHttpRequest

- (void)httpGET:(NSString *)httpUrl param:(HFHttpParam *)httpParam
{
    NSString * reqUrlString = [self spliceHttpUrl:httpUrl param:httpParam];
    
    HFInnerLogi(@"http get with real request url[%@], httpUrl[%@] param : %@ ",
                reqUrlString, httpUrl, httpParam.paramDictionary);
    
    NSURL * requestURL = [NSURL URLWithString:reqUrlString];
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
            NSString * aParamKey = [HFEncodeHelper URLEncode:allParamKeys[index]];
            NSString * aParamVal = [HFEncodeHelper URLEncode:aDictionary[aParamKey]];
            
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
