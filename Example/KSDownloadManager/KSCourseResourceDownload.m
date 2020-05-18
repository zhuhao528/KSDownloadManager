//
//  KSCourseResourceDownload.m
//  KSStory
//
//  Created by zhu hao on 2020/5/11.
//  Copyright © 2020 凯声文化. All rights reserved.
//

#import "KSCourseResourceDownload.h"

NSString * const CoursewareResourceFile = @"CoursewareResourceFile";

@interface KSCourseResourceDownload()

@property(nonatomic, copy)NSString *path;

@end

@implementation KSCourseResourceDownload

static KSCourseResourceDownload *download = nil;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        download =  [[self alloc] init];
    });
    return download;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.path = [NSString stringWithFormat:@"%@/%@/",docDir,CoursewareResourceFile];
        NSLog(@"self.path ====== %@",self.path);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = false;
        if ([fileManager fileExistsAtPath:self.path isDirectory:&isDir]){
        }else{
            NSURL *tempFileURL = [NSURL fileURLWithPath:self.path];
            if (NO == [fileManager createDirectoryAtURL:tempFileURL withIntermediateDirectories:YES attributes:nil error:nil]){
            }
        }
    }
    return self;
}

- (void)startdownload:(KSCourseResourceModel *)model
             progress:(DowningProgress)progress
              success:(DonwLoadSuccessBlock)success
              failure:(DownLoadfailBlock)failure{
    NSString *destination = [NSString stringWithFormat:@"%@%@.zip",self.path,model.url];
    __weak __typeof(self)weakSelf = self;
    [[KSDownloadManager sharedInstance] startdownload:[NSURL URLWithString:model.url]
                                             progress:progress
                                         fileLocalUrl:destination
                                              success:^(NSURL * _Nonnull fileUrlPath, NSURLResponse * _Nonnull response) {
        if([weakSelf dealZip:model  path:destination]){
            if(success != nil){
                success(fileUrlPath,response);
            }
        }else{
            if(failure != nil){
                failure([NSError errorWithDomain:@"文件校验或者解压失败" code:0 userInfo:NULL],0);
            }
        }
    }
                                              failure:failure];
}

- (BOOL)isDownload:(KSCourseResourceModel *)model{
    return [[KSDownloadManager sharedInstance] isDownload:[NSURL URLWithString:model.url]];
}

- (void)pauseDownload:(KSCourseResourceModel *)model{
    [[KSDownloadManager sharedInstance] pauseDownload:[NSURL URLWithString:model.url]];
}

- (void)resumedownload:(KSCourseResourceModel *)model
              progress:(DowningProgress)progress
               success:(DonwLoadSuccessBlock)success
               failure:(DownLoadfailBlock)failure{
    NSString *destination = [NSString stringWithFormat:@"%@%@.zip",self.path,model.url];
    __weak __typeof(self)weakSelf = self;
    [[KSDownloadManager sharedInstance] resumedownload:[NSURL URLWithString:model.url]
                                              progress:progress
                                          fileLocalUrl:destination
                                               success:^(NSURL * _Nonnull fileUrlPath, NSURLResponse * _Nonnull response) {
        if([weakSelf dealZip:model path:destination]){
            if(success != nil){
                success(fileUrlPath,response);
            }
        }else{
            if(failure != nil){
                failure([NSError errorWithDomain:@"文件校验或者解压失败" code:0 userInfo:NULL],0);
            }
        }
    }
                                               failure:failure];
}

- (void)cancelDownload:(KSCourseResourceModel *)model{
    [[KSDownloadManager sharedInstance] cancelDownload:[NSURL URLWithString:model.url]];
}

#pragma mark - 资源处理

- (BOOL)dealZip:(KSCourseResourceModel *)model path:(NSString *)path{
    // MD5 校验 解压等业务逻辑
    return true;
}

@end
