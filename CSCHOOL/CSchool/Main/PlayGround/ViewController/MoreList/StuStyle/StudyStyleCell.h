//
//  StudyStyleCell.h
//  CSchool
//
//  Created by mac on 17/9/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYModel.h>
@interface StudyStyleModel : NSObject
@property (nonatomic,copy) NSString * bjh; //班级号
@property (nonatomic,copy) NSString * bjm; //班级名
@property (nonatomic,copy) NSString * jf; //积分
@property (nonatomic,copy) NSString * pm; //排名

@end
@interface StudyStyleCell : UITableViewCell
@property (nonatomic,copy)StudyStyleModel *model;
@end

