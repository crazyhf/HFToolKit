//
//  HFDigestHelper.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/30.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "HFDigestHelper.h"


@implementation HFDigestHelper

#pragma mark - mdx digest algorithm wrapper

+ (NSData *)MD2Hash:(NSData *)sourceData
{
    unsigned char md2[CC_MD2_DIGEST_LENGTH];
    CC_MD2(sourceData.bytes, sourceData.length, md2);
    return [NSData dataWithBytes:md2 length:CC_MD2_DIGEST_LENGTH];
}

+ (NSString *)MD2HexHash:(NSData *)sourceData
{
    return [self HexString:[self MD2Hash:sourceData]];
}

+ (NSData *)MD4Hash:(NSData *)sourceData
{
    unsigned char md4[CC_MD4_DIGEST_LENGTH];
    CC_MD4(sourceData.bytes, sourceData.length, md4);
    return [NSData dataWithBytes:md4 length:CC_MD4_DIGEST_LENGTH];
}

+ (NSString *)MD4HexHash:(NSData *)sourceData
{
    return [self HexString:[self MD4Hash:sourceData]];
}

+ (NSData *)MD5Hash:(NSData *)sourceData
{
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5(sourceData.bytes, sourceData.length, md5);
    return [NSData dataWithBytes:md5 length:CC_MD5_DIGEST_LENGTH];
}

+ (NSString *)MD5HexHash:(NSData *)sourceData
{
    return [self HexString:[self MD5Hash:sourceData]];
}


#pragma mark - shax digest algorithm wrapper

+ (NSData *)SHA1Hash:(NSData *)sourceData
{
    unsigned char sha1[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(sourceData.bytes, sourceData.length, sha1);
    return [NSData dataWithBytes:sha1 length:CC_SHA1_DIGEST_LENGTH];
}

+ (NSString *)SHA1HexHash:(NSData *)sourceData
{
    return [self HexString:[self SHA1Hash:sourceData]];
}

+ (NSData *)SHA224Hash:(NSData *)sourceData
{
    unsigned char sha224[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(sourceData.bytes, sourceData.length, sha224);
    return [NSData dataWithBytes:sha224 length:CC_SHA224_DIGEST_LENGTH];
}

+ (NSString *)SHA224HexHash:(NSData *)sourceData
{
    return [self HexString:[self SHA224Hash:sourceData]];
}

+ (NSData *)SHA256Hash:(NSData *)sourceData
{
    unsigned char sha256[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(sourceData.bytes, sourceData.length, sha256);
    return [NSData dataWithBytes:sha256 length:CC_SHA256_DIGEST_LENGTH];
}

+ (NSString *)SHA256HexHash:(NSData *)sourceData
{
    return [self HexString:[self SHA256Hash:sourceData]];
}

+ (NSData *)SHA384Hash:(NSData *)sourceData
{
    unsigned char sha384[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(sourceData.bytes, sourceData.length, sha384);
    return [NSData dataWithBytes:sha384 length:CC_SHA384_DIGEST_LENGTH];
}

+ (NSString *)SHA384HexHash:(NSData *)sourceData
{
    return [self HexString:[self SHA384Hash:sourceData]];
}

+ (NSData *)SHA512Hash:(NSData *)sourceData
{
    unsigned char sha512[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(sourceData.bytes, sourceData.length, sha512);
    return [NSData dataWithBytes:sha512 length:CC_SHA512_DIGEST_LENGTH];
}

+ (NSString *)SHA512HexHash:(NSData *)sourceData
{
    return [self HexString:[self SHA512Hash:sourceData]];
}


#pragma mark - hex string

+ (NSString *)HexString:(NSData *)sourceData
{
    char hex_string[sourceData.length * 2 + 1];
    for (NSUInteger index = 0; index < sourceData.length; index++) {
        sprintf(hex_string + index * 2, "%02x", ((const unsigned char *)sourceData.bytes)[index]);
    }
    return [NSString stringWithUTF8String:hex_string];
}

@end
