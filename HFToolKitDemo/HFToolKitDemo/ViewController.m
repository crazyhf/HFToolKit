//
//  ViewController.m
//  HFToolKitDemo
//
//  Created by crazylhf on 15/7/27.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import "ViewController.h"

#import "HFLogUtil.h"
#import "HFDirectoryUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"test");
    
    HFLogi(@"XXX", @"\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@",
           [HFDirectoryUtil HomeDirectory],
           [HFDirectoryUtil TemporaryDirectory],
           [HFDirectoryUtil DocumentsDirectory],
           [HFDirectoryUtil MusicDirectory],
           [HFDirectoryUtil MoviesDirectory],
           [HFDirectoryUtil PicturesDirectory],
           [HFDirectoryUtil DownloadsDirectory],
           [HFDirectoryUtil LibraryDirectory],
           [HFDirectoryUtil CachesDirectory],
           [HFDirectoryUtil AppSupportDirectory]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
