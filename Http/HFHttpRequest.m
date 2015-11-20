//
//  HFHttpRequest.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/5.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFHttpRequest.h"

#import "HFInnerLog.h"

#import "HFRandomUtil.h"
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
        [self generateMultipartFormData:request httpPram:httpParam];
    }
    
    NSError * error = nil;
    NSHTTPURLResponse * response = nil;
    
    _responseData = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    _responseCode  = response.statusCode;
    _responseError = error;
}


#pragma mark - multipart/form-data

- (void)generateMultipartFormData:(NSMutableURLRequest *)request httpPram:(HFHttpParam *)httpPram
{
    NSString * boundary = [NSString stringWithFormat:@"----------%@%lx", [HFRandomUtil randomAlphanumeric:10], (unsigned long)([NSDate date].timeIntervalSince1970 * 1000)];
    
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSString * fieldHead = [@"--" stringByAppendingString:boundary];
    NSString * fieldEnd  = [boundary stringByAppendingString:@"--"];
    
    NSMutableData * entityData = [self multipartFormData:fieldHead httpParam:httpPram];
    [entityData appendData:[fieldEnd dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:entityData];
}


/**
 *  multipart/form-data format
 *
 *     --boundary\r\n
 *     Content-Disposition: form-data; name="xxx"\r\n
 *     \r\n
 *     yyy\r\n
 *     --boundary\r\n
 *     Content-Disposition: form-data; name="xxx"; filename="xxx.xxx"\r\n
 *     Content-Type: text/plain\r\n
 *     \r\n
 *     .....
 *     .....\r\n
 *     --boundary--
 *
 *  Content-Type definition
 *     Content-Type = "Content-Type" ":" media-type
 *     media-type   = type "/" subtype *( ";" parameter )
 *     type = 'text' | 'image' | 'video' | 'audio' | 'application'
 *     subtype = 'plain' | 'html' | 'xml'
 *             | 'png' | 'jpeg' | 'gif'
 *             | 'mpeg4' | 'mpeg' | 'mpg' | 'avi' | 'x-ms-wmv'
 *             | 'mp1' | 'mp2' | 'mp3' | 'mid' | 'wav' | 'aiff'
 *             | 'octet-stream'
 */
- (NSMutableData *)multipartFormData:(NSString *)fieldHead httpParam:(HFHttpParam *)httpPram
{
    return nil;
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
