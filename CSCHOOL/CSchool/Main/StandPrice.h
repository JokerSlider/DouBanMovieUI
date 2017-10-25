//
//  StandPrice.h
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageModel.h"
@interface StandPrice : UITableViewCell
@property (nonatomic,strong)UILabel *priceTitle;
@property (nonatomic,strong)UILabel *beniftTitle;
@property (nonatomic, strong) PackageModel *model;
@property (nonatomic,strong) UIButton *noticeV;

@end
