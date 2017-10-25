//
//  HelpListTableViewCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/19.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpListModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

@end

@interface HelpListTableViewCell : UITableViewCell

@property (nonatomic, strong) HelpListModel *model;

@end
