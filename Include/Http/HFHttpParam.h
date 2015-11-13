//
//  HFHttpParam.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/6.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFHttpParam : NSObject

- (id)initWithParamDictionary:(NSDictionary *)dictionary;


- (NSDictionary *)paramDictionary;


- (void)addParamDictionary:(NSDictionary *)dictionary;

- (void)addFileParam:(NSString *)filePath paramKey:(NSString *)paramKey;

@end
