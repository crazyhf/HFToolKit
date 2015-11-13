//
//  HFHttpParam.m
//  HFToolKit
//
//  Created by crazylhf on 15/11/6.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFHttpParam.h"

@interface HFHttpParam()

@property (nonatomic, strong) NSMutableDictionary * mutableParamDic;

@end

@implementation HFHttpParam

#pragma mark - initialization

- (id)init
{
    if (self = [super init]) {
        self.mutableParamDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithParamDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.mutableParamDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    return self;
}


#pragma mark -

- (NSDictionary *)paramDictionary
{
    return self.mutableParamDic;
}


#pragma mark -

- (void)addParamDictionary:(NSDictionary *)dictionary
{
    [self.mutableParamDic addEntriesFromDictionary:dictionary];
}

- (void)addFileParam:(NSString *)filePath paramKey:(NSString *)paramKey
{
    ;
}

@end
