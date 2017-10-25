//
//  LibraryBottomCell.h
//  CSchool
//
//  Created by mac on 16/12/26.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibiraryModel.h"
@interface LibraryBottomCell : UITableViewCell
@property (nonatomic,strong)LibiraryModel *model;
@property (nonatomic,strong)  UIImageView *listNum;//排行
@end
