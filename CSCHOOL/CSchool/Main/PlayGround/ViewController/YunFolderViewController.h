//
//  YunFolderViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 2017/6/2.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
//操作类型
typedef enum : NSUInteger {
    YunFolderMake, //创建文件夹
    YunFolderMove,   //移动文件
    YunFolderCopy   //复制文件
} YunFolderType;

@class LEOWebDAVItem;

@interface YunFolderViewController : BaseViewController

@property (nonatomic, assign) YunFolderType yunFolderType;

@property (nonatomic, retain) LEOWebDAVItem *currentItem;  //要移动、复制的文件

-(id)initWithPath:(NSString *)path;
-(id)initWithItem:(LEOWebDAVItem *)_item;
- (void)reloadData;

@end
