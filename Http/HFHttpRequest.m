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

#pragma mark - http GET

- (void)httpGET:(NSString *)httpUrl param:(HFHttpParam *)httpParam
{
    [self httpGET:httpUrl param:httpParam timeoutInterval:60];
}

- (void)httpGET:(NSString *)httpUrl param:(HFHttpParam *)httpParam timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSString * reqUrlString  = httpUrl;
    
    NSString * encodedString = [self URLEncodeHttpParam:httpParam];
    if (0 != encodedString.length) {
        reqUrlString = [httpUrl stringByAppendingFormat:@"?%@", encodedString];
    }
    
    HFInnerLogi(@"http get with real request url[%@], httpUrl[%@] param : %@ ",
                reqUrlString, httpUrl, httpParam.paramDictionary);
    
    NSURL * requestURL = [NSURL URLWithString:reqUrlString];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:timeoutInterval];
    
    NSError * error = nil;
    NSHTTPURLResponse * response = nil;
    _responseData  = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response
                                                       error:&error];
    _responseError = error;
    _responseCode  = response.statusCode;
}


#pragma mark - http POST

- (void)httpPOST:(NSString *)httpUrl param:(HFHttpParam *)httpParam
{
    [self httpPOST:httpUrl param:httpParam formEnctype:HFForm_URLEncode timeoutInterval:60];
}

- (void)httpPOST:(NSString *)httpUrl param:(HFHttpParam *)httpParam formEnctype:(HFFormEnctype)formEnctype
{
    [self httpPOST:httpUrl param:httpParam formEnctype:formEnctype timeoutInterval:60];
}

- (void)httpPOST:(NSString *)httpUrl param:(HFHttpParam *)httpParam formEnctype:(HFFormEnctype)formEnctype timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSURL * requestURL = [NSURL URLWithString:httpUrl];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:timeoutInterval];
    
    if (HFForm_URLEncode == formEnctype) {
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        NSString * encodedString = [self URLEncodeHttpParam:httpParam];
        [request setHTTPBody:[encodedString dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        NSString * boundary = [NSString stringWithFormat:@"----------%lx", (unsigned long)([NSDate date].timeIntervalSince1970 * 1000)];
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
        
        /// ...
    }
    
    NSError * error = nil;
    NSHTTPURLResponse * response = nil;
    
    _responseData = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    _responseCode  = response.statusCode;
    _responseError = error;
}


#pragma mark - url utils

- (NSString *)URLEncodeHttpParam:(HFHttpParam *)httpParam
{
    NSMutableString * targetString = [NSMutableString string];
    if (0 != httpParam.paramDictionary.count)
    {
        NSDictionary * aDictionary  = httpParam.paramDictionary;
        NSArray      * allParamKeys = aDictionary.allKeys;
        
        for (NSUInteger index = 0; index < allParamKeys.count; index++) {
            NSString * aParamKey = [HFEncodeHelper URLEncode:allParamKeys[index]];
            NSString * aParamVal = [HFEncodeHelper URLEncode:aDictionary[aParamKey]];
            
            if (index > 0) {
                [targetString appendFormat:@"&%@=%@", aParamKey, aParamVal];
            } else {
                [targetString appendFormat:@"%@=%@", aParamKey, aParamVal];
            }
        }
    }
    return targetString;
}

@end
