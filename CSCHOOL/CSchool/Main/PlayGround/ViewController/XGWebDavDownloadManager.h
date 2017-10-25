//
//  XGWebDavDownloadManager.h
//  CSchool
//
//  Created by 左俊鑫 on 17/5/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LEOWebDAVItem;


/**
 回调，下载进度实时更新

 @param index 数组中的第几个元素
 @param percent 百分比
 */
typedef void(^ReceivedProgressClick)(NSInteger index, float percent);


/**
 回调，下载完成

 @param index 数组中第几个元素
 @param item model
 */
typedef void(^TaskDidDown)(NSInteger index, LEOWebDAVItem *item);

@interface XGWebDavDownloadManager : NSObject

+ (XGWebDavDownloadManager *)shareDownloadManager;

@property (nonatomic, retain) NSMutableArray *downloadingArray;  //正在进行下载的item数组

@property (nonatomic, retain) NSMutableArray *didDownloadArray;  //已经下载完成的item数

@property (nonatomic, retain) NSMutableDictionary *downloadDic; //下载完成字典 key：下载地址 value：1：已下载

@property (nonatomic, copy) ReceivedProgressClick receivedProgressClick;

@property (nonatomic, copy) TaskDidDown taskDidDown;

/**
 添加下载

 @param item
 */
- (void)addDownload:(LEOWebDAVItem *)item;

@end
