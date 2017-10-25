//
//  ImportWorkListCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/9/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImportWorkListModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *depart;
@property (nonatomic, copy) NSString *workId;
@property (nonatomic, copy) NSString *workName;

@property (nonatomic, copy) NSString *workType; //工作类别 2017-05-10新增
@property (nonatomic, copy) NSString *helpDepart; //协作部门 2017-05-10新增

@end

@interface ImportWorkListCell : UITableViewCell

@property (nonatomic, retain) ImportWorkListModel *model;

@end
