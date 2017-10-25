//
//  MyMessageInfoHeadView.h
//  CSchool
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyInfoModel;

@interface MyMessageInfoHeadView : UIView

@property (nonatomic,strong)MyInfoModel *model;
@property (nonatomic, retain) NSMutableArray *imageListArray; //存放本地添加的图片数组

@property (nonatomic, retain) NSMutableArray *imageIdArray; //存放图片id

@property (nonatomic, retain) NSMutableArray *imageUrlArray; //存放图片URL地址（编辑）

//- (void)addImageWithUrl:(NSMutableArray *)thumbLicArray; //根据URL添加图片展示（编辑）
@end
