//
//  LibraryBookLocationCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/12/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryBookLocationModel : NSObject

@property (nonatomic, copy) NSString *stationName;
@property (nonatomic, copy) NSString *suoshuNum;
@property (nonatomic, copy) NSString *tiaomaNum;
@property (nonatomic, copy) NSString *statusInfo;
@property (nonatomic, copy) NSString *BOOK_STAT_CODE;
@property (nonatomic, retain) NSDictionary *statusDic;

@end

@interface LibraryBookLocationCell : UITableViewCell

@property (nonatomic, retain) LibraryBookLocationModel *model;

@end
