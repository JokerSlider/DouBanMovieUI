//
//  ButtonAlertView.h
//  CPopView
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ButtonAlertViewSelectDelegate <NSObject>
@optional
/**
 ***点击弹出的button后回调***
 **/
-(void)itemDidSelected:(UIButton *)sender;
-(void)dissFromSuperMainScroView;
@end

@interface ButtonAlertView : UIView
@property (nonatomic, assign) id<ButtonAlertViewSelectDelegate> delegate;
@property (nonatomic,copy)NSString *fileName;//文件夹名称
-(instancetype)initWithwithIconArr:(NSArray *)dataArr;
-(void)show;
-(void)handleFuncMessage:(NSNotification*)note;
//移除
-(void)removeAllFunction:(NSNotification*)note;
@end
