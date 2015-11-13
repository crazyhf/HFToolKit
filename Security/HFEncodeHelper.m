//
//  HFEncodeHelper.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFEncodeHelper.h"

#import "HFInnerLog.h"


@implementation HFEncodeHelper

#pragma mark - url encode/decode

/**
 *  reserved characters : = , ! $ & ' ( ) * + ; @ ? # : / [ ]
 *  @see https://en.wikipedia.org/wiki/Percent-encoding
 */
+ (NSString *)URLEncode:(NSString *)sourceString
{
    if (NO == [sourceString isKindOfClass:[NSString class]]) {
        HFInnerLoge(@"sourceString[%@] isn't NSString, url encode failed !", sourceString);
        return @"";
    }
    
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)sourceString, NULL, CFSTR(":/#@?&+=!;',[]()*$ \n\t\"<>%"), kCFStringEncodingUTF8));
}

+ (NSString *)URLDecode:(NSString *)encodedString
{
    if (NO == [encodedString isKindOfClass:[NSString class]]) {
        HFInnerLoge(@"encodedString[%@] isn't NSString, url decode failed !", encodedString);
        return @"";
    }
    
    return CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodedString, NULL, kCFStringEncodingUTF8));
}


@end
