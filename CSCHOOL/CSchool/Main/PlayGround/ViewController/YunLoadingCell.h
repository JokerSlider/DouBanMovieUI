//
//  YunLoadingCell.h
//  CSchool
//
//  Created by 左俊鑫 on 17/5/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOWebDAVItem.h"

@class ZZCircleProgress;

@interface YunLoadingCell : UITableViewCell

@property (nonatomic, retain) LEOWebDAVItem *model; //download

@property (nonatomic, copy) NSString *fileUrl; //文件地址（upload）

@property (nonatomic, assign) BOOL isDown; //是否下载完成的cell

- (void)updateProgress:(float)percent;


@end
