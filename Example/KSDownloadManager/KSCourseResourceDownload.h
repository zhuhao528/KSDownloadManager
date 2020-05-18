//
//  KSCourseResourceDownload.h
//  KSStory
//
//  Created by zhu hao on 2020/5/11.
//  Copyright © 2020 凯声文化. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSDownloadManager.h"
#import "KSCourseResourceModel.h"


NS_ASSUME_NONNULL_BEGIN

extern NSString *const CoursewareResourceFile;

typedef void (^DonwLoadSuccessBlock)(NSURL *fileUrlPath ,NSURLResponse *response);
typedef void (^DownLoadfailBlock)(NSError*  error ,NSInteger statusCode);
typedef void (^DowningProgress)(CGFloat  progress);

@interface KSCourseResourceDownload : NSObject

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
- (void)startdownload:(KSCourseResourceModel *)model
             progress:(DowningProgress)progress
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
- (void)resumedownload:(KSCourseResourceModel *)model
              progress:(DowningProgress)progress
               success:(DonwLoadSuccessBlock)success
               failure:(DownLoadfailBlock)failure;

/// 是否正在下载
- (BOOL)isDownload:(KSCourseResourceModel *)model;

/// 暂停下载
- (void)pauseDownload:(KSCourseResourceModel *)model;

// 取消下载
- (void)cancelDownload:(KSCourseResourceModel *)model;

@end

NS_ASSUME_NONNULL_END
