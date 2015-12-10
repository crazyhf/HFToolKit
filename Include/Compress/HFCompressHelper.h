//
//  HFCompressHelper.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/23.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFCompressHelper : NSObject

+ (NSData *)gzipCompress:(NSArray *)sourceList;


#pragma mark - inflate/deflate by means of zlib

+ (NSData *)zlibInflate:(NSData *)sourceData;

+ (NSData *)zlibDeflate:(NSData *)sourceData gzipHeader:(BOOL)gzipHeader;

@end
