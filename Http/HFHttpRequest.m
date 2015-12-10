//
//  HFHttpRequest.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/5.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFHttpRequest.h"

#import "HFInnerLog.h"

#import "HFFileUtil.h"
#import "HFRandomUtil.h"
#import "HFEncodeHelper.h"
#import "HFCompressHelper.h"


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
    
    if (0 != httpParam.fileParamDictionary.count) {
        formEnctype = HFForm_MultipartData;
    }
    
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
    if (0 != entityData.length) {
        [entityData appendData:[fieldEnd dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
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
 *             | 'mpeg4' | 'mpeg' | 'mpg' | 'avi'
 *             | 'mp1' | 'mp2' | 'mp3' | 'mid' | 'wav' | 'aiff'
 *             | 'octet-stream' | 'zip'
 */
- (NSMutableData *)multipartFormData:(NSString *)fieldHead httpParam:(HFHttpParam *)httpPram
{
    static NSString * const fieldFormat0 = @"%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n";
    static NSString * const fieldFormat1 = @"%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n";
    
    NSMutableData * entityData = [NSMutableData data];
    
    for (NSString * paramKey in httpPram.paramDictionary.allKeys)
    {
        NSString * paramValue = httpPram.paramDictionary[paramKey];
        
        NSString * entityField = [NSString stringWithFormat:fieldFormat0, fieldHead, paramKey, paramValue];
        
        [entityData appendData:[entityField dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for (NSString * fileParamKey in httpPram.fileParamDictionary.allKeys)
    {
        NSArray * fileParamValue = httpPram.fileParamDictionary[fileParamKey];
        
        if (0 != fileParamValue.count)
        {
            HFPOSTFileParam * aFileParam = fileParamValue.firstObject;
            
            HFPOSTMimeType postMime = HFPOSTMime_UnknownType;
            NSString * postFileName = @"";
            
            NSMutableArray * filePathList = [NSMutableArray arrayWithCapacity:fileParamValue.count];
            for (aFileParam in fileParamValue) {
                if (0 != aFileParam.filePath.length
                    && YES == [HFFileUtil isFileExisted:aFileParam.filePath]) {
                    [filePathList addObject:aFileParam.filePath];
                    postMime = aFileParam.mimeType;
                    postFileName = aFileParam.fileName;
                }
            }
            
            NSData * postFileData = nil;
            if (filePathList.count > 1) {
                postFileData = [HFCompressHelper gzipCompress:filePathList];
                postFileName = [NSString stringWithFormat:@"%lx.zip", (unsigned long)([NSDate date].timeIntervalSince1970 * 1000)];
                postMime = HFPOSTMime_ZipArchive;
            } else {
                postFileData = [NSData dataWithContentsOfFile:filePathList.firstObject];
                if (0 == postFileName.length) {
                    postFileName = [filePathList.firstObject lastPathComponent];
                }
            }
            
            if (0 != postFileData.length) {
                NSString * entityField = [NSString stringWithFormat:fieldFormat1, fieldHead, fileParamKey, postFileName, [self MIMETypeString:postMime]];
                
                [entityData appendData:[entityField dataUsingEncoding:NSUTF8StringEncoding]];
                [entityData appendData:postFileData];
                [entityData appendBytes:"\r\n" length:2];
            }
        }
    }
    
    return entityData;
}

- (NSString *)MIMETypeString:(HFPOSTMimeType)mimeType
{
    if (NO == is_HFPOSTMimeType_valid(mimeType)) {
        HFInnerLogw(@"the mimeType[%@] is invalid, return 'application/octet-stream' as the result", @(mimeType));
    }
    
    switch (mimeType) {
        case HFPOSTMime_TextPlain:  return @"text/plain";
        case HFPOSTMime_TextHtml:   return @"text/html";
        case HFPOSTMime_TextXml:    return @"text/xml";
            
        case HFPOSTMime_ImageJPEG:  return @"image/jpeg";
        case HFPOSTMime_ImagePNG:   return @"image/png";
        case HFPOSTMime_ImageGIF:   return @"image/gif";
            
        case HFPOSTMime_VideoMPEG4: return @"video/mpeg4";
        case HFPOSTMime_VideoMPEG:  return @"video/mpeg";
        case HFPOSTMime_VideoMPG:   return @"video/mpg";
        case HFPOSTMime_VideoAVI:   return @"video/avi";
            
        case HFPOSTMime_AudioAIFF:  return @"audio/aiff";
        case HFPOSTMime_AudioMP1:   return @"audio/mp1";
        case HFPOSTMime_AudioMP2:   return @"audio/mp2";
        case HFPOSTMime_AudioMP3:   return @"audio/mp3";
        case HFPOSTMime_AudioMID:   return @"audio/mid";
        case HFPOSTMime_AudioWAV:   return @"audio/wav";
            
        case HFPOSTMime_ZipArchive: return @"application/zip";
        default: return @"application/octet-stream";
    }
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
