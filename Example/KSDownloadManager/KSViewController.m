//
//  KSViewController.m
//  KSDownloadManager
//
//  Created by zhuhao on 05/14/2020.
//  Copyright (c) 2020 zhuhao. All rights reserved.
//

#import "KSViewController.h"
#import "KSCourseResourceDownload.h"

@interface KSViewController ()

@property(nonatomic, strong)KSCourseResourceModel *model;

@end

@implementation KSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.model = [[KSCourseResourceModel alloc] init];
    self.model.url = @"";
    self.model.md5Str = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 暂停下载
- (void)pauseDownload{
    [[KSCourseResourceDownload sharedInstance] pauseDownload:self.model];
}

/// 恢复下载
- (void)resumeDownload{
    [[KSCourseResourceDownload sharedInstance] resumedownload:self.model progress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    } success:^(NSURL * _Nonnull fileUrlPath, NSURLResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    }];
}

// 开始下载资源包
- (void)download{
    [[KSCourseResourceDownload sharedInstance] startdownload:self.model
                                                    progress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    } success:^(NSURL * _Nonnull fileUrlPath, NSURLResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    }];
}


@end
