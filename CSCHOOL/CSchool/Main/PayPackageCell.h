//
//  PayPackageCell.h
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayPackageCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic, strong)UIButton *SelectIconBtn;
@property (nonatomic,assign)BOOL isSelected;
-(void)UpdateCellWithState:(BOOL)select;

@property (nonatomic,strong)UIImageView *PayImageV;
@property (nonatomic,strong)UILabel *title;
@end
