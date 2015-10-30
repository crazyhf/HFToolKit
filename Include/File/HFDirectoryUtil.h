//
//  HFDirectoryUtil.h
//  HFToolKit
//
//  Created by crazylhf on 15/10/29.
//  Copyright © 2015年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFDirectoryUtil : NSObject

/// home directory : /
+ (NSString *)HomeDirectory;


/// temporary directory : /tmp/
+ (NSString *)TemporaryDirectory;


/// NSDocumentDirectory : /Documents/
+ (NSString *)DocumentsDirectory;

/// folder in Documents : /Documents/xxx/
+ (NSString *)directoryInDocuments:(NSString *)folderName;


/// NSMusicDirectory : /Music/
+ (NSString *)MusicDirectory;

/// NSMoviesDirectory : /Movies/
+ (NSString *)MoviesDirectory;

/// NSPicturesDirectory : /Pictures/
+ (NSString *)PicturesDirectory;


/// NSDownloadsDirectory : /Downloads/
+ (NSString *)DownloadsDirectory;

/// folder in Downloads : /Downloads/xxx/
+ (NSString *)directoryInDownloads:(NSString *)folderName;


/// NSLibraryDirectory : /Library/
+ (NSString *)LibraryDirectory;

/// NSCachesDirectory : /Library/Caches/
+ (NSString *)CachesDirectory;

/// NSApplicationSupportDirectory : /Library/Application Support/
+ (NSString *)AppSupportDirectory;

/// folder in Library : /Library/xxx/
+ (NSString *)directoryInLibrary:(NSString *)folderName;

/// folder in Caches : /Library/Caches/xxx/
+ (NSString *)directoryInCaches:(NSString *)folderName;


#pragma mark - search path with NSSearchPathDirectory

+ (NSString *)searchPath:(NSSearchPathDirectory)directoryType errorLog:(NSString *)errorLog;

/**
 *  @brief generate directory in |path| with |folderName|
 *  @attention
 *          if the dest directory isn't existed and generate failed, return @""
 */
+ (NSString *)directoryInPath:(NSString *)path folderName:(NSString *)folderName;

@end
