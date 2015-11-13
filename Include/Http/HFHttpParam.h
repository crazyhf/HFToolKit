//
//  HFHttpParam.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/6.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFHttpParam : NSObject

/**
 *  @attention must be @{NSString : NSString}
 */
- (id)initWithParamDictionary:(NSDictionary *)dictionary;


#pragma mark - add http param

/**
 *  @attention must be @{NSString : NSString}
 */
- (void)addParamDictionary:(NSDictionary *)dictionary;

- (void)addFileParam:(NSString *)filePath paramKey:(NSString *)paramKey;

- (void)addParamKey:(NSString *)paramKey paramValue:(NSString *)paramValue;


#pragma mark - getter

- (NSDictionary *)paramDictionary;

@end
