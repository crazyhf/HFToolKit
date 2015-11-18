//
//  HFHttpRequest.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/5.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFHttpParam.h"

/**
 *  @brief
 *       POST form Content-Type : application/x-www-form-urlencoded or multipart/form-data
 *       application/x-www-form-urlencoded is default value
 *
 *  @see
 *       HTTP/1.1 : http://www.ietf.org/rfc/rfc2616.txt
 *       Multipart Types : http://www.ietf.org/rfc/rfc2046.txt
 *       HTTP POST : https://en.wikipedia.org/wiki/POST_(HTTP)
 *       multipart/form-data : https://www.ietf.org/rfc/rfc1867.txt
 *       HTTP FORM : http://www.w3.org/TR/html401/interact/forms.html
 *       FORM Content-Type : http://www.w3.org/TR/html401/interact/forms.html#h-17.13.4
 */

typedef NS_ENUM(NSUInteger, HFFormEnctype) {
    HFForm_URLEncode,
    HFForm_MultipartData,
};

@interface HFHttpRequest : NSObject

@property (nonatomic, assign, readonly) NSInteger responseCode;

@property (nonatomic, strong, readonly) NSData * responseData;

@property (nonatomic, strong, readonly) NSError * responseError;


#pragma mark - http GET

/**
 *  @brief
 *     default timeout interval : 60 seconds
 */
- (void)httpGET:(NSString *)httpUrl param:(HFHttpParam *)httpParam;

- (void)httpGET:(NSString *)httpUrl param:(HFHttpParam *)httpParam timeoutInterval:(NSTimeInterval)timeoutInterval;


#pragma mark - http POST

/**
 *  @brief
 *     default timeout interval : 60 seconds
 *     default form enctype : HFForm_URLEncode
 */
- (void)httpPOST:(NSString *)httpUrl param:(HFHttpParam *)httpParam;

/**
 *  @brief
 *     default timeout interval : 60 seconds
 */
- (void)httpPOST:(NSString *)httpUrl param:(HFHttpParam *)httpParam formEnctype:(HFFormEnctype)formEnctype;

- (void)httpPOST:(NSString *)httpUrl param:(HFHttpParam *)httpParam formEnctype:(HFFormEnctype)formEnctype timeoutInterval:(NSTimeInterval)timeoutInterval;

@end
