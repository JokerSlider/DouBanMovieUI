//
//  FlowerListCollectionCell.h
//  CSchool
//
//  Created by mac on 16/11/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCarView.h"
@interface FlowerListCollectionCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *photoImage;

@property (nonatomic,strong)UILabel      *flowerNum;//鲜花数量
@property (nonatomic,strong)UILabel      *messageNum;//消息数量
@property (nonatomic,strong)UIButton     *deleBtnPhoto;//删除
@property (nonatomic,strong)PhotoCarModel  *model;
@end
