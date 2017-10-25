//
//  PhotoWallDetailViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/10/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@class PhotoCarModel;
@class PhotoCarView;

@interface PhotoWallDetailViewController : BaseViewController

@property (nonatomic, retain) PhotoCarModel *model;

@property (nonatomic, retain) PhotoCarView *carView;

@property (nonatomic, copy) NSString *picID; //图片id，用于无model打开展示

@end
