//
//  HFHttpParam.h
//  HFToolKit
//
//  Created by crazylhf on 15/11/6.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFCommon.h"

HF_ENUM_HEAD(NSUInteger, HFPOSTMimeType)
    HFPOSTMime_UnknownType,

    HFPOSTMime_ZipArchive,

    HFPOSTMime_TextPlain,
    HFPOSTMime_TextHtml,
    HFPOSTMime_TextXml,

    HFPOSTMime_ImageJPEG,
    HFPOSTMime_ImagePNG,
    HFPOSTMime_ImageGIF,

    HFPOSTMime_VideoMPEG4,
    HFPOSTMime_VideoMPEG,
    HFPOSTMime_VideoMPG,
    HFPOSTMime_VideoAVI,

    HFPOSTMime_AudioAIFF,
    HFPOSTMime_AudioMP1,
    HFPOSTMime_AudioMP2,
    HFPOSTMime_AudioMP3,
    HFPOSTMime_AudioMID,
    HFPOSTMime_AudioWAV,
HF_ENUM_TAIL(HFPOSTMimeType)


///=================================================================

#pragma mark - HFPOSTFileParam

@interface HFPOSTFileParam : NSObject

@property (nonatomic, strong) NSString * paramKey;

@property (nonatomic, strong) NSString * fileName;

@property (nonatomic, strong) NSString * filePath;

@property (nonatomic, assign) HFPOSTMimeType mimeType;

@end


///=================================================================

#pragma mark - HFHttpParam

@interface HFHttpParam : NSObject

/**
 *  @attention
 *     paramDictionary : @{param-key(NSString) : param-value(NSString)}
 *     fileParamDictionary : @{param-key(NSString) : @[HFPOSTFileParam, ...]}
 */
- (id)initWithParamDictionary:(NSDictionary *)paramDictionary
          fileParamDictionary:(NSDictionary *)fileParamDictionary;


#pragma mark - add http param

- (void)addFileParam:(HFPOSTFileParam *)fileParam;

/**
 *  @attention must be @{param-key(NSString) : param-value(NSString)}
 */
- (void)addParamDictionary:(NSDictionary *)dictionary;

- (void)addParamKey:(NSString *)paramKey paramValue:(NSString *)paramValue;


#pragma mark - getter

/// @{param-key(NSString) : param-value(NSString)}
- (NSDictionary *)paramDictionary;

/// @{param-key(NSString) : @[HFPOSTFileParam, ...]}
- (NSDictionary *)fileParamDictionary;

@end
