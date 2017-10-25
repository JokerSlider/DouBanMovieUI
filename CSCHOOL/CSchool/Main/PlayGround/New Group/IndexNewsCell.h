//
//  IndexNewsCell.h
//  CSchool
//
//  Created by 左俊鑫 on 17/1/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexNewsCellModel : NSObject

@property (nonatomic, copy) NSString *appID;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *showName;

@property (nonatomic, copy) NSString *detailID; //订单或者照片编号

@property (nonatomic, copy) NSString *openURL;
@end

@interface IndexNewsCell : UITableViewCell

@property (nonatomic, retain) IndexNewsCellModel *model;

@end
