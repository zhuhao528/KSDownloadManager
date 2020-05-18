//
//  KSCourseResourceDownload.h
//  KSStory
//
//  Created by zhu hao on 2020/5/7.
//  Copyright © 2020 凯声文化. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DonwLoadSuccessBlock)(NSURL *fileUrlPath ,NSURLResponse *  response );
typedef void (^DownLoadfailBlock)(NSError*  error ,NSInteger statusCode);
typedef void (^DowningProgress)(CGFloat  progress);

@interface KSDownload : NSObject

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSURLSessionDownloadTask *task;
@property(nonatomic, strong) NSData *resumeData;

@end

/// 支持暂停和恢复下载
@interface KSDownloadManager : NSObject

// 单例
+ (instancetype)sharedInstance;

/**
 下载zip资源包
 
 @param url 资源地址
 @param progress  进度
 @param localUrl 文件目标地址
 @param success 成功回调
 @param failure 失败回调
 */
- (void)startdownload:(NSURL *)url
             progress:(DowningProgress)progress
         fileLocalUrl:(NSString *)localUrl
              success:(DonwLoadSuccessBlock)success
              failure:(DownLoadfailBlock)failure;

/**
 恢复下载zip资源包
 
 @param url 资源地址
 @param progress  进度
 @param localUrl 文件目标地址
 @param success 成功回调
 @param failure 失败回调
 */
- (void)resumedownload:(NSURL *)url
              progress:(DowningProgress)progress
          fileLocalUrl:(NSString *)localUrl
               success:(DonwLoadSuccessBlock)success
               failure:(DownLoadfailBlock)failure;

/// 是否正在下载
- (BOOL)isDownload:(NSURL *)url;

/// 暂停下载
- (void)pauseDownload:(NSURL *)url;

// 取消下载
- (void)cancelDownload:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
