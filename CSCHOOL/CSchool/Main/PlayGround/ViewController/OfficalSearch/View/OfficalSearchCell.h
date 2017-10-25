//
//  OfficalSearchCell.h
//  CSchool
//
//  Created by mac on 17/8/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYModel.h>
@class HXTagsView;
@class OfficalSearchModel;
@protocol TagTypeDelegate <NSObject>

-(void)tagsAction:(HXTagsView *)tagsView button:(UIButton *)sender;

@end
@interface OfficalSearchCell : UITableViewCell

@property (nonatomic,copy)OfficalSearchModel *model;
@property (nonatomic,assign)id <TagTypeDelegate> delegate;
@end

/*
 [_newsArr addObject:dic[@"title"]];
 [_timeArr addObject:dic[@"releaseTime"]];
 [_idArr addObject:dic[@"id"]];
 [_deparArr addObject:dic[@"releaseDepart"]];
 */
//Model
@interface OfficalSearchModel : NSObject
@property (nonatomic,copy)NSArray *tagArr;//标签数组
@property (nonatomic,copy)NSString *title;//公文标题

@property (nonatomic,copy)NSString *releaseTime;//发布时间
@property (nonatomic,copy)NSString *releaseDepart;//发布部门
@property (nonatomic,copy)NSString *ID;//公文消息ID
@property(nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *tagtitle;
@end
