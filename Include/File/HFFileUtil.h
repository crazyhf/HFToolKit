//
//  HFFileUtil.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFFileUtil : NSObject

#pragma mark - check file/directory existed

+ (BOOL)isFileExisted:(NSString *)filePath;

+ (BOOL)isDierctoryExisted:(NSString *)directoryPath;

+ (BOOL)isPathExisted:(NSString *)path isDirectory:(BOOL *)isDirectory;


#pragma mark - create/move/copy/remove file or directory

+ (BOOL)createFile:(NSString *)filePath overwrite:(BOOL)overwrite;

+ (BOOL)moveItem:(NSString *)srcPath toPath:(NSString *)dstPath;

+ (BOOL)copyItem:(NSString *)srcPath toPath:(NSString *)dstPath;

+ (BOOL)removeItem:(NSString *)itemPath;

+ (BOOL)createDirectory:(NSString *)directoryPath;

@end
