//
//  ImportWorkDetailCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/9/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImportWorkDetailModel : NSObject

@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *plan;
@property (nonatomic, copy) NSString *jindu;
@property (nonatomic, copy) NSString *percent;

@end

@interface ImportWorkDetailCell : UITableViewCell

@property (nonatomic, retain) ImportWorkDetailModel *model;

@end
