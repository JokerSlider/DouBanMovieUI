//
//  NoticeCell.h
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageModel.h"
@interface NoticeCell : UITableViewCell
@property  (nonatomic,strong)UILabel *noticeLabel;
@property (nonatomic, strong) PackageModel *model;
@end
