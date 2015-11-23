//
//  ViewController.m
//  HFToolKitDemo
//
//  Created by crazylhf on 15/7/27.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import "ViewController.h"

#import "HFLogUtil.h"
#import "HFDeviceUtil.h"
#import "HFDirectoryUtil.h"
#import "HFDigestHelper.h"
#import "HFTaskQueue.h"
#import "HFHttpQueue.h"

@interface ViewController ()

@property (nonatomic, strong) HFTaskQueue * serialQueue;

@property (nonatomic, strong) HFTaskQueue * concurrentQueue;

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
    
    HFAssetW(1, @"xxxxxxx");
    HFAssetE(1, @"1111111");
    
    HFLogi(@"XXX", @"aaa : %@", [HFDigestHelper SHA256HexHash:[NSData dataWithBytes:"aaa" length:3]]);
    HFLogi(@"XXX", @"aaa\\0bbb : %@", [HFDigestHelper MD5HexHash:[NSData dataWithBytes:"aaa\0bbb" length:7]]);
    
    HFLogi(@"XXX", @"%@, %@", @([HFDeviceUtil iphoneType]), [NSValue valueWithCGRect:[HFDeviceUtil screenBounds]]);
    
    self.serialQueue = [[HFTaskQueue alloc] initWithQueueType:HFTaskQueue_Serial finishedDispatch:dispatch_get_main_queue()];
    
    self.concurrentQueue = [[HFTaskQueue alloc] initWithQueueType:HFTaskQueue_Concurrent finishedDispatch:dispatch_get_main_queue()];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[HFHttpQueue sharedInstance] addRequest:^(HFHttpRequest * httpRequest) {
        HFHttpParam * httpParam = [[HFHttpParam alloc] init];
//        [httpParam addParamKey:@"test" paramValue:@"test_value"];
        
        [httpRequest httpGET:@"http://localhost:8080/travel_1.jpg" param:httpParam];
    } finished:^(NSInteger respCode, NSData *respData, NSError *respErr) {
        NSLog(@"respCode[%@] respDataLen[%@] respErr[%@]", @(respCode), @(respData.length), respErr);
        if (0 != respData.length) {
            UIImageView * aImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            aImageView.image = [UIImage imageWithData:respData];
            [self.view addSubview:aImageView];
        }
    }];
    
    [[HFHttpQueue sharedInstance] addRequest:^(HFHttpRequest *httpRequest) {
        HFPOSTFileParam * fileParam = [[HFPOSTFileParam alloc] init];
        fileParam.paramKey = @"post_file";
        fileParam.mimeType = HFPOSTMime_TextPlain;
        fileParam.fileName = @"post_file.txt";
        fileParam.filePath = [[NSBundle mainBundle] pathForResource:@"post_file" ofType:@"txt"];
        
        HFHttpParam * httpParam = [[HFHttpParam alloc] init];
        [httpParam addFileParam:fileParam];
        [httpParam addParamKey:@"test" paramValue:@"test_value"];
        
        [httpRequest httpPOST:@"http://localhost:8080" param:httpParam];
    } finished:^(NSInteger respCode, NSData *respData, NSError *respErr) {
        NSLog(@"respCode[%@] respData[%@] respErr[%@]", @(respCode), [[NSString alloc] initWithData:respData encoding:NSUTF8StringEncoding], respErr);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
