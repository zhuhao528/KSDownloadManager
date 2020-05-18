//
//  KSCourseResourceModel.h
//  KSStory
//
//  Created by zhu hao on 2020/5/7.
//  Copyright © 2020 凯声文化. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface KSCourseResourceModel : NSObject

/// fullUrl 资源zip包全量url
@property (nonatomic, copy) NSString *url;
/// fullMd5Str 全量md5值
@property (nonatomic, copy) NSString *md5Str;

@end

NS_ASSUME_NONNULL_END
