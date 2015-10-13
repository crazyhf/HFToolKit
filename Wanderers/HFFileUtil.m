//
//  HFFileUtil.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/12.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFFileUtil.h"

#import "HFInnerLog.h"

@implementation HFFileUtil

#pragma mark - check file/directory existed

+ (BOOL)isFileExisted:(NSString *)filePath
{
    BOOL isDirectory;
    BOOL isExisted = [self isPathExisted:filePath isDirectory:&isDirectory];
    
    return (isExisted && !isDirectory);
}

+ (BOOL)isDierctoryExisted:(NSString *)directoryPath
{
    BOOL isDirectory;
    BOOL isExisted = [self isPathExisted:directoryPath isDirectory:&isDirectory];
    
    return (isExisted && isDirectory);
}

+ (BOOL)isPathExisted:(NSString *)path isDirectory:(BOOL *)isDirectory
{
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    return [fileMgr fileExistsAtPath:path isDirectory:isDirectory];
}


#pragma mark - create/move/copy/remove file or directory

+ (BOOL)createFile:(NSString *)filePath overwrite:(BOOL)overwrite
{
    if ([filePath hasSuffix:@"/"]) {
        HFInnerLogw(@"create file failed, the filePath[%@] may be a directory", filePath);
        return NO;
    }
    
    if (!overwrite && [self isFileExisted:filePath]) {
        HFInnerLogi(@"create file successfully, because file is existed, filePath[%@] overwrite[%@]", filePath, @(overwrite));
        return YES;
    }
    
    NSRange range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    if (NSNotFound != range.location) {
        NSString * aDirectory = [filePath substringToIndex:range.location];
        if (NO == [self createDirectory:aDirectory]) {
            HFInnerLoge(@"create file[%@] failed, because create the directory[%@] failed", filePath, aDirectory);
            return NO;
        }
    }
    
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    if (YES == [fileMgr createFileAtPath:filePath contents:nil attributes:nil]) {
        HFInnerLogi(@"create file[%@] successfully!", filePath);
        return YES;
    }
    else {
        HFInnerLoge(@"create file[%@] failed!", filePath);
        return NO;
    }
}

+ (BOOL)createDirectory:(NSString *)directoryPath
{
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    
    NSError * outError = nil;
    BOOL result = [fileMgr createDirectoryAtPath:directoryPath
                     withIntermediateDirectories:YES attributes:nil error:&outError];
    if (result && nil == outError) {
        return YES;
    } else {
        HFInnerLoge(@"create directory[%@] failed, error : %@", directoryPath, outError);
        return NO;
    }
}

+ (BOOL)moveItem:(NSString *)srcPath toPath:(NSString *)dstPath
{
    BOOL isDirectory;
    if (NO == [self isPathExisted:srcPath isDirectory:&isDirectory]) {
        HFInnerLoge(@"move item from path[%@] to path[%@] failed, because src path isn't existed", srcPath, dstPath);
        return NO;
    }
    
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    
    NSError * outError = nil;
    BOOL result = [fileMgr moveItemAtPath:srcPath toPath:dstPath error:&outError];
    
    if (YES == result && nil == outError) {
        HFInnerLogi(@"move item from path[%@] to path[%@] successfully", srcPath, dstPath);
        return YES;
    } else {
        HFInnerLoge(@"move item from path[%@] to path[%@] failed, error : %@", srcPath, dstPath, outError);
        return NO;
    }
}

+ (BOOL)copyItem:(NSString *)srcPath toPath:(NSString *)dstPath
{
    BOOL isDirectory;
    if (NO == [self isPathExisted:srcPath isDirectory:&isDirectory]) {
        HFInnerLoge(@"copy item from path[%@] to path[%@] failed, because src path isn't existed", srcPath, dstPath);
        return NO;
    }
    
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    
    NSError * outError = nil;
    BOOL result = [fileMgr copyItemAtPath:srcPath toPath:dstPath error:&outError];
    
    if (YES == result && nil == outError) {
        HFInnerLogi(@"copy item from path[%@] to path[%@] successfully", srcPath, dstPath);
        return YES;
    } else {
        HFInnerLoge(@"copy item from path[%@] to path[%@] failed, error : %@", srcPath, dstPath, outError);
        return NO;
    }
}

+ (BOOL)removeItem:(NSString *)itemPath
{
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    
    NSError * outError = nil;
    BOOL result = [fileMgr removeItemAtPath:itemPath error:&outError];
    
    if (YES == result && nil == outError) {
        HFInnerLogi(@"remove item at path[%@] successfully", itemPath);
        return YES;
    } else {
        HFInnerLoge(@"remove item at path[%@] failed, error : %@", itemPath, outError);
        return NO;
    }
}

@end
