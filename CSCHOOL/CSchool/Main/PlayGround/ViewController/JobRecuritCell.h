//
//  JobRecuritCell.h
//  CSchool
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYModel.h>
@interface  JobModel:NSObject
@property (nonatomic,copy)NSString *jobTitle;
@property (nonatomic,copy)NSString *jobTime;
@property (nonatomic,copy)NSString *newsId;

@property (nonatomic,copy)NSString *content;//
@property (nonatomic,copy)NSString *releaseDepart;
@property (nonatomic,copy)NSArray *attchment;
@end


@interface JobRecuritCell : UITableViewCell
@property (nonatomic,strong)JobModel *model;
@end
