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


/// temporary directory : /tmp
+ (NSString *)TemporaryDirectory;


/// NSDocumentDirectory : /Documents
+ (NSString *)DocumentsDirectory;


/// NSMusicDirectory : /Music
+ (NSString *)MusicDirectory;

/// NSMoviesDirectory : /Movies
+ (NSString *)MoviesDirectory;

/// NSPicturesDirectory : /Pictures
+ (NSString *)PicturesDirectory;

/// NSDownloadsDirectory : /Downloads
+ (NSString *)DownloadsDirectory;


/// NSLibraryDirectory : /Library
+ (NSString *)LibraryDirectory;

/// NSCachesDirectory : /Library/Caches
+ (NSString *)CachesDirectory;

/// NSApplicationSupportDirectory : /Library/Application Support
+ (NSString *)AppSupportDirectory;


#pragma mark - search path with NSSearchPathDirectory

+ (NSString *)searchPath:(NSSearchPathDirectory)directoryType errorLog:(NSString *)errorLog;

@end
