//
//  XGWebDavUploadManager.h
//  CSchool
//
//  Created by 左俊鑫 on 17/5/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LEOWebDAVItem;


/**
 回调，上传进度实时更新
 
 @param index 数组中的第几个元素
 @param percent 百分比
 */
typedef void(^ReceivedProgressClick)(NSInteger index, float percent);


/**
 回调，上传完成
 
 @param index 数组中第几个元素
 @param item model
 */
typedef void(^TaskDidDown)(NSInteger index, LEOWebDAVItem *item);

@interface XGWebDavUploadManager : NSObject


+ (XGWebDavUploadManager *)shareUploadManager;

@property (nonatomic, retain) NSMutableArray *uploadingArray;  //正在进行上传的item数组

@property (nonatomic, retain) NSMutableArray *didUploadArray;  //已经上传完成的item数

@property (nonatomic, retain) NSMutableDictionary *uploadDic; //上传完成字典 key：上传地址 value：1：已上传

@property (nonatomic, copy) ReceivedProgressClick receivedProgressClick;

@property (nonatomic, copy) TaskDidDown taskDidDown;

@property (nonatomic, copy) NSString *selctPath; //选中路径

@property (nonatomic, copy) NSString *currentPath; //当前路径

/**
 添加上传
 
 @param item
 */
- (void)addUpload:(NSData *)data;

- (void)addUploadUrl:(NSString *)url;

@end
