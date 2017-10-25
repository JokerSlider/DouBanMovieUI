//
//  BenefitCell.h
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageModel.h"
@interface BenefitCell : UITableViewCell
@property  (nonatomic,strong)UIImageView *noticeImageView;
@property  (nonatomic,strong)UILabel *noticeImageLabel;
@property (nonatomic, strong) PackageModel *model;

@end
