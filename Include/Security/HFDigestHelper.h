//
//  HFDigestHelper.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/30.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief wrapper for ios digest algorithm.
 *         MD2, MD4, MD5, SHA1, SHA224, SHA256, SHA384, SHA512
 */
@interface HFDigestHelper : NSObject

#pragma mark - mdx digest algorithm wrapper

+ (NSData *)MD2Hash:(NSData *)sourceData;

+ (NSString *)MD2HexHash:(NSData *)sourceData;

+ (NSData *)MD4Hash:(NSData *)sourceData;

+ (NSString *)MD4HexHash:(NSData *)sourceData;

+ (NSData *)MD5Hash:(NSData *)sourceData;

+ (NSString *)MD5HexHash:(NSData *)sourceData;


#pragma mark - shax digest algorithm wrapper

+ (NSData *)SHA1Hash:(NSData *)sourceData;

+ (NSString *)SHA1HexHash:(NSData *)sourceData;

+ (NSData *)SHA224Hash:(NSData *)sourceData;

+ (NSString *)SHA224HexHash:(NSData *)sourceData;

+ (NSData *)SHA256Hash:(NSData *)sourceData;

+ (NSString *)SHA256HexHash:(NSData *)sourceData;

+ (NSData *)SHA384Hash:(NSData *)sourceData;

+ (NSString *)SHA384HexHash:(NSData *)sourceData;

+ (NSData *)SHA512Hash:(NSData *)sourceData;

+ (NSString *)SHA512HexHash:(NSData *)sourceData;


#pragma mark - hex string

+ (NSString *)HexString:(NSData *)sourceData;

@end
