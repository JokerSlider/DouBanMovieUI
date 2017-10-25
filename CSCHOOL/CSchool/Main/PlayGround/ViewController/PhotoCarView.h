//
//  PhotoCarView.h
//  CSchool
//
//  Created by 左俊鑫 on 16/10/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDraggableCardView.h"

@interface PhotoCarModel : NSObject

@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *headerUrl;
@property (nonatomic, copy) NSString *name;//昵称
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *flowerNum;
@property (nonatomic, copy) NSString *picId;
@property (nonatomic, copy) NSString *userSex;//性别
@property (nonatomic,copy)NSString *listNum;//排行  1 、  2 、3 、 4
@property (nonatomic,copy)NSString *commentNum;//评论数
@property (nonatomic,copy)NSString *photoID;//鲜花ID
@property (nonatomic,copy)NSString *publishTime;//发布时间
@end

@interface PhotoCarView : CCDraggableCardView

@property (nonatomic, retain) PhotoCarModel *model;

@property (nonatomic, retain) UILabel *flowerNumLabel;

@end
