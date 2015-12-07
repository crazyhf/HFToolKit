//
//  HFHttpParam.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/6.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFHttpParam.h"

#import "HFInnerLog.h"


///=================================================================

#pragma mark - HFPOSTFileParam

@implementation HFPOSTFileParam

- (NSString *)description
{
    return [NSString stringWithFormat:@"%lu %@ : %@[%@]", (unsigned long)self.mimeType, self.paramKey, self.fileName, self.filePath];
}

- (id)init
{
    if (self = [super init]) {
        self.paramKey = @"";
        self.filePath = @"";
        self.fileName = @"";
        self.mimeType = HFPOSTMime_UnknownType;
    }
    return self;
}

@end


///=================================================================

#pragma mark - HFHttpParam

@interface HFHttpParam()

/// @{param-key(NSString) : param-value(NSString)}
@property (nonatomic, strong) NSMutableDictionary * mutableParamDic;

/// @{param-key(NSString) : @[HFPOSTFileParam, ...]}
@property (nonatomic, strong) NSMutableDictionary * mutableFileParamDic;

@end

@implementation HFHttpParam

#pragma mark - initialization

- (id)init
{
    if (self = [super init]) {
        self.mutableParamDic = [NSMutableDictionary dictionary];
        self.mutableFileParamDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithParamDictionary:(NSDictionary *)paramDictionary
          fileParamDictionary:(NSDictionary *)fileParamDictionary
{
    if (self = [super init]) {
        self.mutableParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDictionary];
        self.mutableFileParamDic = [NSMutableDictionary dictionaryWithDictionary:fileParamDictionary];
    }
    return self;
}


#pragma mark - add http param

- (void)addFileParam:(HFPOSTFileParam *)fileParam
{
    if (nil != fileParam && 0 != fileParam.paramKey.length) {
        NSMutableArray * aFileParamAry = self.mutableFileParamDic[fileParam.paramKey];
        if (0 == aFileParamAry.count) {
            aFileParamAry = [NSMutableArray arrayWithObject:fileParam];
            self.mutableFileParamDic[fileParam.paramKey] = aFileParamAry;
        } else {
            [aFileParamAry addObject:fileParam];
        }
    } else {
        HFInnerLogw(@"add file param failed, HFPOSTFileParam : %@", fileParam);
    }
}

- (void)addParamDictionary:(NSDictionary *)dictionary
{
    [self.mutableParamDic addEntriesFromDictionary:dictionary];
}

- (void)addParamKey:(NSString *)paramKey paramValue:(NSString *)paramValue
{
    [self.mutableParamDic setValue:paramValue forKey:paramKey];
}


#pragma mark - getter

- (NSDictionary *)paramDictionary
{
    return self.mutableParamDic;
}

- (NSDictionary *)fileParamDictionary
{
    return self.mutableFileParamDic;
}

@end
