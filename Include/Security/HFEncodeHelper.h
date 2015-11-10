//
//  HFEncodeHelper.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/10.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFEncodeHelper : NSObject

#pragma mark - url encode/decode

+ (NSString *)URLEncode:(NSString *)sourceString;

+ (NSString *)URLDecode:(NSString *)encodedString;


@end
