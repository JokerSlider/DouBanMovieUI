//
//  OfficeDetailTableViewCell.h
//  CSchool
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfficeDetailTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *phoneNumer;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic ,strong)NSArray *telPhoneArr;

@end
