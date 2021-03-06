//
//  HFDirectoryUtil.m
//  HFToolKit
//
//  Created by crazylhf on 15/10/29.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import "HFDirectoryUtil.h"

#import "HFInnerLog.h"

#import "HFFileUtil.h"


@implementation HFDirectoryUtil

/// home directory : /
+ (NSString *)HomeDirectory
{
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (NO == [(aDirectory = NSHomeDirectory()) hasSuffix:@"/"]) {
            aDirectory = [aDirectory stringByAppendingString:@"/"];
        }
    });
    return aDirectory;
}


/// temporary directory : /tmp
+ (NSString *)TemporaryDirectory {
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (NO == [(aDirectory = NSTemporaryDirectory()) hasSuffix:@"/"]) {
            aDirectory = [aDirectory stringByAppendingString:@"/"];
        }
    });
    return aDirectory;
}


/// NSDocumentDirectory : /Documents
+ (NSString *)DocumentsDirectory
{
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aDirectory = [self searchPath:NSDocumentDirectory
                             errorLog:@"search path for \"/Documents\" failed"];
    });
    return aDirectory;
}

/// folder in Documents : /Documents/xxx/
+ (NSString *)directoryInDocuments:(NSString *)folderName
{
    return [self directoryInPath:self.DocumentsDirectory folderName:folderName];
}


/// NSMusicDirectory : /Music
+ (NSString *)MusicDirectory
{
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aDirectory = [self searchPath:NSMusicDirectory
                             errorLog:@"search path for \"/Music\" failed"];
    });
    return aDirectory;
}

/// NSMoviesDirectory : /Movies
+ (NSString *)MoviesDirectory
{
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aDirectory = [self searchPath:NSMoviesDirectory
                             errorLog:@"search path for \"/Movies\" failed"];
    });
    return aDirectory;
}

/// NSPicturesDirectory : /Pictures
+ (NSString *)PicturesDirectory;
{
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aDirectory = [self searchPath:NSPicturesDirectory
                             errorLog:@"search path for \"/Pictures\" failed"];
    });
    return aDirectory;
}


/// NSDownloadsDirectory : /Downloads
+ (NSString *)DownloadsDirectory
{
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aDirectory = [self searchPath:NSDownloadsDirectory
                             errorLog:@"search path for \"/Downloads\" failed"];
    });
    return aDirectory;
}

/// folder in Downloads : /Downloads/xxx/
+ (NSString *)directoryInDownloads:(NSString *)folderName
{
    return [self directoryInPath:self.DownloadsDirectory folderName:folderName];
}


/// NSLibraryDirectory : /Library
+ (NSString *)LibraryDirectory
{
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aDirectory = [self searchPath:NSLibraryDirectory
                             errorLog:@"search path for \"/Library\" failed"];
    });
    return aDirectory;
}

/// NSCachesDirectory : /Library/Caches
+ (NSString *)CachesDirectory
{
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aDirectory = [self searchPath:NSCachesDirectory
                             errorLog:@"search path for \"/Library/Caches\" failed"];
    });
    return aDirectory;
}

/// NSApplicationSupportDirectory : /Library/Application Support
+ (NSString *)AppSupportDirectory
{
    static NSString * aDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aDirectory = [self searchPath:NSApplicationSupportDirectory
                             errorLog:@"search path for \"/Library/Application Support\" failed"];
    });
    return aDirectory;
}

/// folder in Library : /Library/xxx/
+ (NSString *)directoryInLibrary:(NSString *)folderName
{
    return [self directoryInPath:self.LibraryDirectory folderName:folderName];
}

/// folder in Caches : /Library/Caches/xxx/
+ (NSString *)directoryInCaches:(NSString *)folderName
{
    return [self directoryInPath:self.CachesDirectory folderName:folderName];
}


#pragma mark - search path with NSSearchPathDirectory

+ (NSString *)searchPath:(NSSearchPathDirectory)directoryType errorLog:(NSString *)errorLog
{
    NSString * aDirectory = nil;
    NSArray * directories = NSSearchPathForDirectoriesInDomains(
                                                                directoryType,
                                                                NSUserDomainMask, YES
                                                                );
    if (directories.count > 0 && (aDirectory = directories.firstObject).length > 0) {
        if (NO == [aDirectory hasSuffix:@"/"]) {
            aDirectory = [aDirectory stringByAppendingString:@"/"];
        }
    } else {
        aDirectory = @""; HFInnerLoge(@"%@", errorLog);
    }
    return aDirectory;
}

+ (NSString *)directoryInPath:(NSString *)path folderName:(NSString *)folderName
{
    NSString * aDirectory = [path stringByAppendingPathComponent:folderName];
    if (NO == [aDirectory hasSuffix:@"/"]) {
        aDirectory = [aDirectory stringByAppendingString:@"/"];
    }
    
    if (NO == [HFFileUtil isDierctoryExisted:path]) {
        if (NO == [HFFileUtil createDirectory:path]) {
            HFInnerLoge(@"generate directory[%@] failed, path [%@] isn't existed and create failed", aDirectory, path);
            return @"";
        }
    }
    
    if (NO == [HFFileUtil isDierctoryExisted:aDirectory]) {
        if (NO == [HFFileUtil createDirectory:aDirectory]) {
            HFInnerLoge(@"generate directory[%@] failed", aDirectory);
            return @"";
        }
    }
    
    return aDirectory;
}

@end
