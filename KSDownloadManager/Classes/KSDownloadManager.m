//
//  KSCourseResourceDownload.m
//  KSStory
//
//  Created by zhu hao on 2020/5/7.
//  Copyright © 2020 凯声文化. All rights reserved.
//

#import "KSDownloadManager.h"
#import "AFNetworking.h"

@interface KSDownloadManager()

@property(nonatomic, strong)AFURLSessionManager *manager;
@property(nonatomic, strong)NSMutableDictionary *daskDic;

@end

@implementation KSDownload

@end

@implementation KSDownloadManager

static KSDownloadManager *download = nil;
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
        _daskDic = [[NSMutableDictionary alloc] init];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return self;
}

- (void)startdownload:(NSURL *)url
             progress:(DowningProgress)progress
         fileLocalUrl:(NSString *)localUrl
              success:(DonwLoadSuccessBlock)success
              failure:(DownLoadfailBlock)failure{
    NSURLSessionDownloadTask *task = nil;
    KSDownload *download = nil;
    if([self.daskDic objectForKey:url]){
        download = [self.daskDic objectForKey:url];
        task = [self.manager downloadTaskWithResumeData:download.resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSLog(@"localUrl ======== %@",localUrl);
            NSURL *docUrl = [[NSURL alloc] initFileURLWithPath:localUrl];
            return docUrl;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            if (error) {
                if (failure) {
                    failure(error,[httpResponse statusCode]);
                }
            }else{
                if (success) {
                    success(filePath,response);
                    [self.daskDic removeObjectForKey:url];
                }
            }
        }];
    }else{
        download = [[KSDownload alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        task = [self.manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
            if (progress) {
                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSLog(@"localUrl ======== %@",localUrl);
            NSURL *docUrl = [[NSURL alloc] initFileURLWithPath:localUrl];
            return docUrl;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            if (error) {
                if (failure) {
                    failure(error,[httpResponse statusCode]);
                }
            }else{
                if (success) {
                    success(filePath,response);
                    [self.daskDic removeObjectForKey:url];
                }
            }
        }];
    }
    [task resume];
    download.url = url;
    download.task = task;
    [self.daskDic setObject:download forKey:url];
}

- (BOOL)isDownload:(NSURL *)url{
    KSDownload *download = [self.daskDic objectForKey:url];
    if (download.task != nil) {
        return [download.task state] == NSURLSessionTaskStateRunning;
    }
    return false;
}

- (void)pauseDownload:(NSURL *)url{
    KSDownload *download = [self.daskDic objectForKey:url];
    if (download.task != nil) {
        [download.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            download.resumeData = resumeData;
            [self.daskDic setObject:download forKey:url];
        }];
    }
}

- (void)resumedownload:(NSURL *)url
              progress:(DowningProgress)progress
          fileLocalUrl:(NSString *)localUrl
               success:(DonwLoadSuccessBlock)success
               failure:(DownLoadfailBlock)failure{
    KSDownload *download = [self.daskDic objectForKey:url];
    if(download.url != nil){
        [[KSDownloadManager sharedInstance] startdownload:download.url
                                                 progress:progress
                                             fileLocalUrl:localUrl
                                                  success:success
                                                  failure:failure];
    }
}

- (void)cancelDownload:(NSURL *)url{
    KSDownload *download = [self.daskDic objectForKey:url];
    if (download.task != nil) {
        [download.task cancel];
        [self.daskDic removeObjectForKey:url];
    }
}

@end
