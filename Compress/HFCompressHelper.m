//
//  HFCompressHelper.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/23.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFCompressHelper.h"

#import "HFInnerLog.h"
#import <zlib.h>


@implementation HFCompressHelper

+ (NSData *)gzipCompress:(NSArray *)sourceList
{
    return [NSData data];
}


#pragma mark - inflate/deflate by means of zlib

+ (NSData *)zlibInflate:(NSData *)sourceData
{
    return [NSData data];
}

/**
 *  @see https://www.ietf.org/rfc/rfc1950.txt
 *       zlib data format
 *
 *          0   1
 *          +---+---+
 *          |CMF|FLG|   (more-->)
 *          +---+---+
 *          0   1   2   3
 *          +---+---+---+---+
 *          |     DICTID    |   (more-->)
 *          +---+---+---+---+
 *
 *          +=====================+---+---+---+---+
 *          |...compressed data...|    ADLER32    |
 *          +=====================+---+---+---+---+
 */
+ (NSData *)zlibDeflate:(NSData *)sourceData gzipHeader:(BOOL)gzipHeader
{
    z_stream zlibStream;
    
    zlibStream.zalloc    = Z_NULL;
    zlibStream.zfree     = Z_NULL;
    zlibStream.opaque    = Z_NULL;
    
    zlibStream.next_in   = (Bytef *)sourceData.bytes;
    zlibStream.avail_in  = (uInt)sourceData.length;
    
    int state = Z_OK;
    if (YES == gzipHeader) {
        /**
         *  deflateInit2(strm, level, method, windowBits, memLevel, strategy)
         *
         *  windowBits can also be greater than 15 for optional gzip encoding.
         *  Add 16 to windowBits to write a simple gzip header and trailer
         *  around the compressed data instead of a zlib wrapper.
         */
        state = deflateInit2(&zlibStream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, 15 + 16, 8, Z_DEFAULT_STRATEGY);
    } else {
        state = deflateInit(&zlibStream, Z_DEFAULT_COMPRESSION);
    }
    
    if (Z_MEM_ERROR == state) {
        HFInnerLoge(@"Z_MEM_ERROR, msg : %s", zlibStream.msg);
    } else if (Z_STREAM_ERROR == state) {
        HFInnerLoge(@"Z_STREAM_ERROR, msg : %s", zlibStream.msg);
    } else if (Z_VERSION_ERROR == state) {
        HFInnerLoge(@"Z_VERSION_ERROR, msg : %s", zlibStream.msg);
    } else if (Z_OK != state) {
        HFInnerLoge(@"Unknown Error[%d], msg : %s", state, zlibStream.msg);
    }
    else {
        const NSUInteger increaseLen = 100;
        NSMutableData * deflateData  = [NSMutableData dataWithLength:sourceData.length];
        
        zlibStream.next_out  = (Bytef *)deflateData.mutableBytes;
        zlibStream.avail_out = (uInt)deflateData.length;
        
        do {
            state = deflate(&zlibStream, Z_FINISH);
            if (Z_STREAM_END == state) {
                HFInnerLogi(@"deflate Z_STREAM_END, avail_in : %u", zlibStream.avail_in);
                break;
            } else if (Z_OK != state) {
                HFInnerLoge(@"deflate error[%d], msg : %s", state, zlibStream.msg);
                break;
            }
            
            if (0 == zlibStream.avail_out) {
                [deflateData increaseLengthBy:increaseLen];
                zlibStream.avail_out = increaseLen;
                zlibStream.next_out  = deflateData.mutableBytes + zlibStream.total_out;
            }
        } while (Z_OK == state);
        
        int endResult = deflateEnd(&zlibStream);
        HFInnerLogi(@"deflateEnd result[%d], msg : %s", endResult, zlibStream.msg);
        
        if (Z_STREAM_END == state || Z_OK == state) {
            deflateData.length = zlibStream.total_out;
            return deflateData;
        }
    }
    
    return [NSData data];
}

@end
