//
//  ViewController.m
//  HFToolKitDemo
//
//  Created by crazylhf on 15/7/27.
//  Copyright (c) 2015年 crazylhf. All rights reserved.
//

#import "ViewController.h"

#import "HFLogUtil.h"

#import "HFTaskQueue.h"
#import "HFHttpQueue.h"

#import "HFAppHelper.h"
#import "HFDeviceUtil.h"
#import "HFDigestHelper.h"
#import "HFDirectoryUtil.h"

#import "HFANRDetection.h"
#import "HFNetworkMonitor.h"


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
    
    [[HFNetworkMonitor sharedInstance] enableMonitor];
    
    HFLogi(@"XXX", @"[HFAppHelper isAppBeingTraced] : %@", @([HFAppHelper isAppBeingTraced]));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[HFHttpQueue sharedInstance] addRequest:^(HFHttpRequest * httpRequest) {
        HFHttpParam * httpParam = [[HFHttpParam alloc] init];
//        [httpParam addParamKey:@"test" paramValue:@"test_value"];
        
        [httpRequest httpGET:@"http://localhost:8080/travel_1.jpg" param:httpParam];
        
        [[HFANRDetection sharedInstance] enableDetection];
    } finished:^(NSInteger respCode, NSData *respData, NSError *respErr) {
        NSLog(@"respCode[%@] respDataLen[%@] respErr[%@]", @(respCode), @(respData.length), respErr);
        if (0 != respData.length) {
            UIImageView * aImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            aImageView.image = [UIImage imageWithData:respData];
            [self.view addSubview:aImageView];
        }
        [[HFANRDetection sharedInstance] enableDetection];
        [[HFANRDetection sharedInstance] enableDetection];
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
    
    [[HFANRDetection sharedInstance] setANRNotifyBlock:^{
        NSLog(@"ui thread is blocked");
        [self testThreadBlock1];
    } dispatchQueue:dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT)];
    
    [self testUIThreadBlock0];
}

- (void)testUIThreadBlock0
{
    for (NSUInteger index = 0; index < INT16_MAX * 2; index++) {
        NSUInteger result = 0;
        for (NSUInteger base = 0; base <= index; base++) {
            result += base;
        }
    }
    
    [self performSelector:_cmd withObject:nil afterDelay:10];
}

- (void)testThreadBlock1
{
    for (NSUInteger index = 0; index < INT16_MAX * 2; index++) {
        NSUInteger result = 0;
        for (NSUInteger base = 0; base <= index; base++) {
            result += base;
        }
    }
    NSLog(@"testThreadBlock1 finished");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
