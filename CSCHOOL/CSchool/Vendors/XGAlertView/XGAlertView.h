//
//  XGAlertView.h
//  XGAlertView
//
//  Created by 左俊鑫 on 16/1/8.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XGAlertView;
typedef void(^ListViewBlioc)(NSInteger selectIndex);

//背景图点击
typedef void(^BackViewClick)(XGAlertView *alert);

@protocol XGAlertViewDelegate <NSObject>

@optional
/**
 *  点击普通弹出窗代理
 *
 *  @param view  弹出窗
 *  @param title 标题
 */
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title;

/**
 *  点击星星弹出窗
 *
 *  @param view    弹出窗
 *  @param markArr 评分数
 */
- (void)alertView:(XGAlertView *)view didClickRemarkView:(NSArray *)markArr;

/**
 *  点击列表弹出窗
 *
 *  @param view
 *  @param index 第几个选项
 */
- (void)alertView:(XGAlertView *)view didClickDropView:(NSInteger)index;

/**
 *  点击验证码弹出窗
 *
 *  @param view
 *  @param idCode 验证码
 */
- (void)alertView:(XGAlertView *)view didClickIdCode:(NSString *)idCode;

/**
 *  取消代理事件
 *
 *  @param view  弹窗
 *  @param title 标题
 */
- (void)alertView:(XGAlertView *)view didClickCancel:(NSString *)title;

/**
 <#Description#>

 @param view <#view description#>
 */
- (void)alertViewDidClickNoticeImageView:(XGAlertView *)view;

@end
@interface XGAlertView : UIView

typedef void(^ViewClickBlock)(NSInteger index);
typedef void(^MarkViewClickBlock)(NSArray *markArr, NSString *moreText);
typedef void(^UnitViewClickBlock)(NSString *index);

/**
 *  普通弹出窗
 *
 *  @param title   标题
 *  @param content 内容
 *  @param click   点击回调事件
 *
 *  @return
 */
- (id)initWithTarget:(id)target withTitle:(NSString *)title withContent:(NSString *)content;

/**
 *  评分星星弹出窗
 *
 *  @param titleArr 标题数组
 *  @param click    点击回调事件
 *
 *  @return
 */
- (id)initWithTarget:(id)target withRemarkTitle:(NSArray *)titleArr;

- (id)initWithTarget:(id)target withRemarkTitle:(NSArray *)titleArr click:(MarkViewClickBlock)block;

- (id)initWithTarget:(id)target withTitle:(NSString *)titleStr withRemarkTitle:(NSArray *)titleArr withContentTitle:(NSString *)contentTitle click:(MarkViewClickBlock)block;

//下拉框
- (id)initWithTarget:(id)target withDropListTitle:(NSArray *)titleArr;

//下拉框，使用回调
- (id)initWithTarget:(id)target withDropListTitle:(NSArray *)titleArr click:(ViewClickBlock)block;

//验证🐴
- (id)initWithTarget:(id)target withIdCode:(NSString *)title;

//多条选择框
- (id)initWithListView:(NSArray *)titleArr complete:(ListViewBlioc)block;


- (id)initWithTarget:(id)target withTitle:(NSString *)title withContent:(NSString *)content WithCancelButtonTitle:(NSString *)btnTitle withOtherButton:(NSString *)otherTitle;

//带输入框
- (instancetype)initWithTitle:(NSString *)title withUnit:(NSString *)unit click:(UnitViewClickBlock)block;

//带单选框
- (instancetype)initSingleSelectWithTitle:(NSString *)title withArray:(NSArray *)titleArray click:(ViewClickBlock)block;

- (id)initWithTarget:(id)target withWebViewContent:(NSString *)content;
//展示图片的弹窗  带动画
-(void)WebviewShow;

- (void)show;

- (void)removeView;

@property (nonatomic, weak) id<XGAlertViewDelegate>delegate;

@property (nonatomic, copy) NSString *viewString; //存放临时变量

@property (nonatomic, assign) BOOL isMustShow; //是否强制显示，点击任何地方不消失，YES：不可以消失

@property (nonatomic, strong) id tempValue; //存放临时变量

@property (nonatomic, assign) BOOL isBackClick; //点击阴影部分是否可以消失 YES:不可点击

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) BackViewClick backViewClick;

@end
