//
//  FairlView.h
//  CSchool
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FairlViewDelegate  <NSObject>
-(void)reloadDataSource;
@end
@interface FairlView : UIView
{
    UILabel *label;
    UIImageView *imageV;
}
/**
 *  由代理控制器去执行刷新网络
 */
@property (nonatomic, strong) id<FairlViewDelegate>delegate;


@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIButton *loadBtn;
@property (nonatomic,copy)NSString *imageName;
-(void)reloadDataSource;
@end
