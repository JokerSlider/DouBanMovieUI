//
//  PhotoMsgCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/10/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoMsgModel : NSObject

@property (nonatomic, copy) NSString *headerUrl;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *msgId;

@end

@interface PhotoMsgCell : UITableViewCell

@property (nonatomic, retain) PhotoMsgModel *model;

@end
