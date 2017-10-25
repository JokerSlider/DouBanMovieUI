//
//  ExamListTableViewCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/6/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamListModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *xuefen;

@end

@interface ExamListTableViewCell : UITableViewCell

@property (nonatomic, strong) ExamListModel *model;

@end
