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
 *
 *       zlib data format : CMF is 0x78
 *       CMF (Compression Method and flags)
 *       This byte is divided into a 4-bit compression method and a 4-bit information
 *       field depending on the compression method.
 *       bits 0 to 3  CM     Compression method
 *       bits 4 to 7  CINFO  Compression info
 *
 *       CM (Compression method)
 *       This identifies the compression method used in the file. CM = 8 denotes the "deflate"
 *       compression method with a window size up to 32K.  This is the method used by gzip
 *       and PNG (see references [1] and [2] in Chapter 3, below, for the reference documents).
 *       CM = 15 is reserved.  It might be used in a future version of this specification to
 *       indicate the presence of an extra field before the compressed data.
 *
 *       CINFO (Compression info)
 *       For CM = 8, CINFO is the base-2 logarithm of the LZ77 window size, minus eight
 *       (CINFO=7 indicates a 32K window size). Values of CINFO above 7 are not allowed
 *       in this version of the specification.  CINFO is not defined in this specification
 *       for CM not equal to 8.
 *
 *       zlib data format : FLG is 0x01 or 0x5E or 0x9C or 0xDA (when FDICT is 0)
 *                          FLG is 0x20 or 0x7D or 0xBB or 0xF9 (when FDICT is 1)
 *       FLG (FLaGs)
 *       This flag byte is divided as follows:
 *       bits 0 to 4  FCHECK  (check bits for CMF and FLG)
 *       bit  5       FDICT   (preset dictionary)
 *       bits 6 to 7  FLEVEL  (compression level)
 *
 *       The FCHECK value must be such that CMF and FLG, when viewed as a 16-bit unsigned
 *       integer stored in MSB order (CMF*256 + FLG), is a multiple of 31.
 *
 *       FDICT (Preset dictionary) If FDICT is set, a DICT dictionary identifier is present
 *       immediately after the FLG byte. The dictionary is a sequence of bytes which are
 *       initially fed to the compressor without producing any compressed output. DICT is
 *       the Adler-32 checksum of this sequence of bytes (see the definition of ADLER32
 *       below).  The decompressor can use this identifier to determine which dictionary
 *       has been used by the compressor.
 *
 *       FLEVEL (Compression level) These flags are available for use by specific compression
 *       methods.  The "deflate" method (CM = 8) sets these flags as follows:
 *       0 - compressor used fastest algorithm
 *       1 - compressor used fast algorithm
 *       2 - compressor used default algorithm
 *       3 - compressor used maximum compression, slowest algorithm
 *       The information in FLEVEL is not needed for decompression; it is there to indicate
 *       if recompression might be worthwhile.
 *
 *       the zlib data header is follows:(when FDICT is 0)
 *       00011110 ***** *** -> 0x78** -> 28672 + 2048 + * = 30720 + *
 *
 *       (FLEVEL = 0)0x78 ***** 000 = 30720                -> 31 * 991 = 30721 -> 0x7801
 *       (FLEVEL = 1)0x78 ***** 010 = 30720 + 64  = 30784  -> 31 * 994 = 30814 -> 0x785E
 *       (FLEVEL = 2)0x78 ***** 001 = 30720 + 128 = 30848  -> 31 * 996 = 30876 -> 0x789C
 *       (FLEVEL = 3)0x78 ***** 011 = 30720 + 192 = 30912  -> 31 * 998 = 30938 -> 0x78DA
 *
 *       the zlib data header is follows:(when FDICT is 1)
 *
 *       (FLEVEL = 0)0x78 ***** 100 = 30720 + 32  = 30752  -> 31 * 992 = 30752 -> 0x7820
 *       (FLEVEL = 1)0x78 ***** 110 = 30720 + 96  = 30816  -> 31 * 995 = 30845 -> 0x787D
 *       (FLEVEL = 2)0x78 ***** 101 = 30720 + 160 = 30880  -> 31 * 997 = 30907 -> 0x78BB
 *       (FLEVEL = 3)0x78 ***** 111 = 30720 + 224 = 30944  -> 31 * 999 = 30969 -> 0x78F9
 *
 *  @see https://www.ietf.org/rfc/rfc1951.txt
 *       compressed data "DEFLATE Compressed Data Format Specification"
 *  @see https://en.wikipedia.org/wiki/DEFLATE
 */
@implementation HFCompressHelper

+ (NSData *)gzipCompress:(NSArray *)sourceList
{
    return [NSData data];
}


#pragma mark - inflate/deflate by means of zlib

/**
 *  zlib data format : CMF is 0x78
 *                     FLG is 0x01 or 0x5E or 0x9C or 0xDA (when FDICT is 0)
 *                     FLG is 0x20 or 0x7D or 0xBB or 0xF9 (when FDICT is 1)
 */
+ (BOOL)isZlibFile:(NSData *)sourceData
{
    unsigned char * sourceBytes = (unsigned char *)sourceData.bytes;
    
    unsigned char zlibByte0 = sourceBytes[0], zlibByte1 = sourceBytes[1];
    if (0x78 == zlibByte0
        && (0x01 == zlibByte1 || 0x5E == zlibByte1
            || 0x9C == zlibByte1 || 0xDA == zlibByte1
            || 0x20 == zlibByte1 || 0x7D == zlibByte1
            || 0xBB == zlibByte1 || 0xF9 == zlibByte1)) {
        return YES;
    }
    
    return NO;
}

+ (NSData *)zlibInflate:(NSData *)sourceData
{
    return [NSData data];
}


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
        state = deflateInit2(&zlibStream, 0, Z_DEFLATED, 15 + 16, 8, Z_DEFAULT_STRATEGY);
    } else {
        state = deflateInit(&zlibStream, 0);
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


#pragma mark - private

/**
 *  FDICT (Preset dictionary) If FDICT is set, a DICT dictionary identifier is present
 *  immediately after the FLG byte. The dictionary is a sequence of bytes which are
 *  initially fed to the compressor without producing any compressed output. DICT is
 *  the Adler-32 checksum of this sequence of bytes (see the definition of ADLER32
 *  below).  The decompressor can use this identifier to determine which dictionary
 *  has been used by the compressor.
 *
 *  the zlib data header is follows:(when FDICT is 1)
 *
 *  (FLEVEL = 0)0x78 ***** 100 = 30720 + 32  = 30752  -> 31 * 992 = 30752 -> 0x7820
 *  (FLEVEL = 1)0x78 ***** 110 = 30720 + 96  = 30816  -> 31 * 995 = 30845 -> 0x787D
 *  (FLEVEL = 2)0x78 ***** 101 = 30720 + 160 = 30880  -> 31 * 997 = 30907 -> 0x78BB
 *  (FLEVEL = 3)0x78 ***** 111 = 30720 + 224 = 30944  -> 31 * 999 = 30969 -> 0x78F9
 */
+ (BOOL)isDICTIDFieldEnabled:(NSData *)sourceData
{
    if (YES == [self isZlibFile:sourceData]) {
        unsigned char zlibByte1 = ((unsigned char *)sourceData.bytes)[1];
        if (0x20 == zlibByte1 || 0x7D == zlibByte1
            || 0xBB == zlibByte1 || 0xF9 == zlibByte1) {
            return YES;
        }
    }
    return NO;
}

@end
