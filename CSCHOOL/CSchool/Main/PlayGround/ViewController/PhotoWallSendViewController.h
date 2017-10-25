//
//  PhotoWallSendViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/11/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@class PhotoWallIndexViewController;

@interface PhotoWallSendViewController : BaseViewController

@property (nonatomic, retain) UIImage *image; //要发布的图片
@property (nonatomic, retain) PhotoWallIndexViewController *indexVC;

@end
