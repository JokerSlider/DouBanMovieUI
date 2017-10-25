//
//  XGAlertView.m
//  XGAlertView
//
//  Created by 左俊鑫 on 16/1/8.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "XGAlertView.h"
#import "CWStarRateView.h"
#import "XJComboBoxView.h"
#import "IdCodeView.h"
#import "UIView+SDAutoLayout.h"
#import "BaseConfig.h"
#import "SingleSelectView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define VH(view) CGRectGetMaxY(view.frame)

@interface XGAlertView()<CWStarRateViewDelegate, XJComboBoxViewDelegate, IdCodeViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@end
@implementation XGAlertView
{
    UIWindow *_alertWindow;
    NSString *_title;
    NSString *_content;
    id _target;
    NSArray *_titleArr;
    NSMutableArray *_markMutableArr;
    NSInteger _currentData2Index;
    UIButton *_submitBtn;
    NSInteger _selectIndex;
    XJComboBoxView *comboBox;
    IdCodeView *idCodeView;
    NSString *_btnTitle;
    NSString *_otherTitle;
    ViewClickBlock _viewClickBlock;
    MarkViewClickBlock _markViewBlock;
    ListViewBlioc _listViewBlock;
    UITextView *_otherTextView;
    UnitViewClickBlock _unitViewBlock;
    NSString *_unitString;
//    UITextField *_textField;
    SingleSelectView *_selView;
    UIButton *_inputTxtsureButton;
}

- (id)initWithTarget:(id)target withTitle:(NSString *)title withContent:(NSString *)content{
    self = [super init];
    if (self) {
        _title = title;
        _content = content;
        _target = target;
        _delegate = _target;
        [self setup];
        [self normalView];
    }
    return self;
}

- (id)initWithTarget:(id)target withRemarkTitle:(NSArray *)titleArr{
    self = [super init];
    if (self) {
        _target = target;
        _titleArr = titleArr;
        _delegate = _target;
        [self setup];
        [self remarkView];
    }
    return self;
}

- (id)initWithTarget:(id)target withRemarkTitle:(NSArray *)titleArr click:(MarkViewClickBlock)block{
    self = [super init];
    if (self) {
        _target = target;
        _titleArr = titleArr;
        _delegate = _target;
        _markViewBlock = block;
        [self setup];
        [self remarkView];
    }
    return self;
}

- (id)initWithTarget:(id)target withTitle:(NSString *)titleStr withRemarkTitle:(NSArray *)titleArr withContentTitle:(NSString *)contentTitle click:(MarkViewClickBlock)block{
    self = [super init];
    if (self) {
        _target = target;
        _titleArr = titleArr;
//        _delegate = _target;
        _markViewBlock = block;
        _title = titleStr;
        _content = contentTitle;
        [self setup];
        [self remarkView];
    }
    return self;
}

- (id)initWithTarget:(id)target withDropListTitle:(NSArray *)titleArr{
    self = [super init];
    if (self) {
        _target = target;
        _titleArr = titleArr;
        _delegate = _target;
        [self setup];
        [self dropView];
    }
    return self;
}

- (id)initWithTarget:(id)target withDropListTitle:(NSArray *)titleArr click:(ViewClickBlock)block{
    self = [super init];
    if (self) {
        _target = target;
        _titleArr = titleArr;
//        _delegate = _target;
        _viewClickBlock = block;
        [self setup];
        [self dropView];
    }
    return self;
}

- (id)initWithTarget:(id)target withIdCode:(NSString *)title{
    self = [super init];
    if (self) {
        _target = target;
        _delegate = _target;
        [self setup];
        [self idCodeView];
    }
    return self;
}


- (id)initWithTarget:(id)target withTitle:(NSString *)title withContent:(NSString *)content WithCancelButtonTitle:(NSString *)btnTitle withOtherButton:(NSString *)otherTitle{
    
    self = [super init];
    if (self) {
        _title = title;
        _content = content;
        _target = target;
        _delegate = _target;
        _btnTitle = btnTitle;
        _otherTitle = otherTitle;
        [self setup];
        [self moreButtonView];
    }
    return self;
}

- (id)initWithListView:(NSArray *)titleArr complete:(ListViewBlioc)block{
    self = [super init];
    if (self) {
        _listViewBlock = block;
        _titleArr = titleArr;
        [self setup];
        [self listView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title withUnit:(NSString *)unit click:(UnitViewClickBlock)block{
    self = [super init];
    if (self) {
        _unitViewBlock = block;
        _unitString = unit;
        _title = title;
        [self setup];
        [self unitView];
    }
    return self;
}

- (instancetype)initSingleSelectWithTitle:(NSString *)title withArray:(NSArray *)titleArray click:(ViewClickBlock)block{
    self = [super init];
    if (self) {
        _title = title;
        _titleArr = titleArray;
        _viewClickBlock = block;
        [self setup];
        [self singleSelect];
    }
    return self;
}

- (void)singleSelect{
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    bgView.sd_layout
    .centerXIs(self.centerX)
    .centerYIs(self.centerY-50)
    .leftSpaceToView(self,30)
    .rightSpaceToView(self,30);
    
    UILabel *titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view.text =  _title;
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    
    [bgView addSubview:titleLabel];
    
    _selView = [[SingleSelectView alloc] init];
    _selView.titleArr = _titleArr;
    [_selView btnSelectAtIndex:0];
    [bgView addSubview:_selView];
    
    titleLabel.sd_layout
    .topSpaceToView(bgView,10)
    .leftSpaceToView(bgView,10)
    .rightSpaceToView(bgView,10)
    .heightIs(25);
    
    _selView.sd_layout
    .topSpaceToView(titleLabel,15)
    .centerXEqualToView(bgView)
    .leftSpaceToView(bgView,10)
    .rightSpaceToView(bgView,10);
    
    //确认按钮
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.backgroundColor = Base_Orange;
    [sureButton addTarget:self action:@selector(singleSureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 4;
    [bgView addSubview:sureButton];
    
    sureButton.sd_layout
    .topSpaceToView(_selView,20)
    .centerXEqualToView(bgView)
    .widthIs(80)
    .heightIs(30);
    
    [bgView setupAutoHeightWithBottomView:sureButton bottomMargin:10];
    [_textField becomeFirstResponder];
}

//带输入框的弹窗
- (void)unitView{
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    bgView.sd_layout
    .centerXIs(self.centerX)
    .centerYIs(self.centerY-50)
    .leftSpaceToView(self,30)
    .rightSpaceToView(self,30);

    UILabel *titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view.text =  _title;
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    
    [bgView addSubview:titleLabel];
    
    _textField = ({
        UITextField *view = [UITextField new];
        [view setBorderStyle:UITextBorderStyleRoundedRect];
        view.delegate = self;
        view.keyboardType = UIKeyboardTypeNumberPad;
        view;
    });
    
    UILabel *unitLabel = [UILabel new];
    unitLabel.frame = CGRectMake(0, 0, 50, 30);
    unitLabel.font = Title_Font;
    unitLabel.textColor = Color_Black;
    _textField.rightView = unitLabel;
    unitLabel.textAlignment = NSTextAlignmentCenter;
    unitLabel.text = _unitString;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    
    [bgView addSubview:_textField];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(CodeTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_textField];
    [center addObserver:self selector:@selector(CodetextFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:_textField];
    [center addObserver:self selector:@selector(CodetextFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:_textField];

    titleLabel.sd_layout
    .topSpaceToView(bgView,10)
    .leftSpaceToView(bgView,10)
    .rightSpaceToView(bgView,10)
    .autoHeightRatio(0);
    
    _textField.sd_layout
    .topSpaceToView(titleLabel,15)
//    .centerXEqualToView(bgView)
//    .widthIs(150)
    .rightSpaceToView(bgView,10)
    .leftSpaceToView(bgView,10)
    .heightIs(30);
    
    //确认按钮
    _inputTxtsureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inputTxtsureButton setTitle:@"确认" forState:UIControlStateNormal];
    [_inputTxtsureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _inputTxtsureButton.backgroundColor = Base_Color3;
    _inputTxtsureButton.enabled  = NO;
    [_inputTxtsureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _inputTxtsureButton.layer.cornerRadius = 4;
    [bgView addSubview:_inputTxtsureButton];
    
    _inputTxtsureButton.sd_layout
    .topSpaceToView(_textField,20)
    .centerXEqualToView(bgView)
    .widthIs(80)
    .heightIs(30);
    
    [bgView setupAutoHeightWithBottomView:_inputTxtsureButton bottomMargin:10];
    [_textField becomeFirstResponder];
}

//下拉框
- (void)dropView{

    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0,10, WIDTH -100, 50);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"评价信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    NSMutableArray *listArray = [NSMutableArray array];
    int i=0;
    for (NSString *display in _titleArr) {
        NSDictionary *dic = @{@"display":display,@"value":@(i)};
        [listArray addObject:dic];
        i++;
    }
    
    comboBox = [[XJComboBoxView alloc]initWithFrame:CGRectMake(15, 60, WIDTH-130, 30)];
    comboBox.displayMember = @"display";
    //    comboBox.valueMember = @"value";
    comboBox.dataSource = listArray;
    comboBox.borderColor =[UIColor grayColor];
    comboBox.cornerRadius = 5;
    comboBox.leftTitle = @"";
    comboBox.defaultTitle = @"请选择撤销原因";
    comboBox.delegate = self;
    [bgView addSubview:comboBox];
    
    //确认按钮
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake((WIDTH-100)/2-35, 22*2+80, 70, 30);
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.backgroundColor = Base_Color3;
    [_submitBtn addTarget:self action:@selector(sureButtonDropClick:) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.layer.cornerRadius = 4;
    _submitBtn.userInteractionEnabled = NO;
    [bgView addSubview:_submitBtn];
    

    bgView.frame = CGRectMake(50, 200, WIDTH-100, VH(_submitBtn)+10);
//    UIViewController *vc = (UIViewController *)_target;
    bgView.center = CGPointMake(self.center.x, self.center.y-100);
    bgView.layer.cornerRadius = 5;

    [self addSubview:bgView];
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canceButtonClcik)];
    [view addGestureRecognizer:tap];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    
    [self addSubview:view];
    self.alpha = 1;
    self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
}
- (void)normalView{
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0,10, WIDTH -100, 50);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(10, 70, WIDTH-120, 80);
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.text = _content;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:contentLabel];
    
    //确认按钮
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake((WIDTH-100)/2-35, WIDTH/2-35, 70, 30);
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.backgroundColor = Base_Orange;
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 4;
    [bgView addSubview:sureButton];
    
    
    bgView.frame = CGRectMake(50, 200, WIDTH-100, VH(sureButton)+10);
    UIViewController *vc = (UIViewController *)_target;
    bgView.center = CGPointMake(self.center.x, self.center.y-50);
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
}


- (void)moreButtonView{
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0,10, WIDTH -100, 30);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(10, 50, WIDTH-120, 80);
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.text = _content;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:contentLabel];
    
    if ([_content length]<1) {
        contentLabel.height = 0;
    }else{
        contentLabel.height = [BaseConfig heightForString:_content width:WIDTH-120 withFont:[UIFont systemFontOfSize:15]];
    }
    
    
    UIButton *cancelBtn = nil;
    UIButton *sureButton = nil;
    if (_otherTitle) {
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:_otherTitle forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(canceButtonClcik1) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = Title_Font;
        [bgView addSubview:cancelBtn];
    }
    
    if (_btnTitle) {
        sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:_btnTitle forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureButton.backgroundColor = Base_Orange;
        [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        sureButton.layer.cornerRadius = 4;
        sureButton.titleLabel.font = Title_Font;
        [bgView addSubview:sureButton];
    }
    
    if (cancelBtn && sureButton) {
        cancelBtn.frame = CGRectMake((WIDTH-100)/2+10, contentLabel.bottom+10, 70, 30);
        sureButton.frame = CGRectMake((WIDTH-100)/2-10-70, contentLabel.bottom+10, 70, 30);
    }else{
        cancelBtn.frame = CGRectMake((WIDTH-100)/2-35, contentLabel.bottom+10, 70, 30);
        sureButton.frame = CGRectMake((WIDTH-100)/2-35, contentLabel.bottom+10, 70, 30);
    }
    
    bgView.frame = CGRectMake(50, 200, WIDTH-100, VH(sureButton)+10);
//    UIViewController *vc = (UIViewController *)_target;
    bgView.center = CGPointMake(self.center.x, self.center.y-50);
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
}

//星星视图
- (void)remarkView{
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0,10, WIDTH -10, 50);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    
    if (_title) {
        titleLabel.text = _title;
    }else{
        titleLabel.text = @"评价信息";
    }
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    _markMutableArr = [NSMutableArray array];
    for (int i=0; i<_titleArr.count; i++) {
        UILabel *markTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 50+32*i, 50, 30)];
        markTitle.font = [UIFont systemFontOfSize:12];
        markTitle.textColor = [UIColor darkGrayColor];
        markTitle.text = _titleArr[i];
        [bgView addSubview:markTitle];
        
        CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(80, 50+32*i, WIDTH-130, 30) numberOfStars:5];
        starRateView.scorePercent = 0.8;
        starRateView.allowIncompleteStar = NO;
        starRateView.hasAnimation = YES;
        starRateView.delegate = self;
        starRateView.tag = i;
        [_markMutableArr addObject:@(0.8)];
        [bgView addSubview:starRateView];
    }
    
    UILabel *otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 32*(_titleArr.count)+90, 70, 20)];
    if (_content) {
        otherLabel.text = _content;
    }else{
        otherLabel.text = @"评价说明:";
    }
    otherLabel.font = [UIFont systemFontOfSize:12];
    otherLabel.textColor = Color_Black;
    [bgView addSubview:otherLabel];
    
    _otherTextView = [[UITextView alloc] initWithFrame:CGRectMake(80, 32*(_titleArr.count)+60,WIDTH-130, 80)];
    _otherTextView.layer.borderWidth = 0.5;
    _otherTextView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [bgView addSubview:_otherTextView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(OtherTextViewDidChange:) name:UITextViewTextDidChangeNotification object:_otherTextView];
    [center addObserver:self selector:@selector(OtherTextViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:_otherTextView];
    [center addObserver:self selector:@selector(OtherTextViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:_otherTextView];
    
    //确认按钮
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake((WIDTH-10)/2-35, 32*(_titleArr.count)+150+10, 70, 30);
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.backgroundColor = Base_Orange;
    [sureButton addTarget:self action:@selector(sureButtonMarkClick:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 4;
    [bgView addSubview:sureButton];
    
    
    bgView.frame = CGRectMake(30, 500, WIDTH-10, VH(sureButton)+10);
    bgView.layer.cornerRadius = 5;
    UIViewController *vc = (UIViewController *)_target;
    bgView.center = CGPointMake(vc.view.center.x, vc.view.center.y-50);
    bgView.layer.masksToBounds = YES;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
}

- (void)OtherTextViewDidChange:(NSNotification *)notice{
    if (![notice.object isEqual:_otherTextView]) {
        return;
    }
    
}

//星星视图textView开始编辑时，弹出框向上升
- (void)OtherTextViewDidBeginEditing:(NSNotification *)notice{
    if ([notice.object isEqual:_otherTextView]) {
        [UIView animateWithDuration:.3 animations:^{
            self.superview.centerY -= 150;
        }];
    }

}

//星星视图textView结束编辑时，弹出框向下降
- (void)OtherTextViewDidEndEditing:(NSNotification *)notice{
    if ([notice.object isEqual:_otherTextView]) {
        [UIView animateWithDuration:.3 animations:^{
            self.superview.centerY += 150;
        }];
    }

}

- (void)listView{
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    bgView.sd_layout
    .centerXIs(self.centerX)
    .centerYIs(self.centerY-50)
    .leftSpaceToView(self,30)
    .rightSpaceToView(self,30)
    .heightIs(_titleArr.count*50+20);
    
    id lastView = bgView;
    for (int i=0; i<[_titleArr count]; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_titleArr[i]  forState:UIControlStateNormal];
        [btn setBackgroundColor:Base_Orange];
        btn.tag = i;
        [btn addTarget:self action:@selector(listViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        btn.sd_layout
        .topSpaceToView(lastView,20)
        .leftSpaceToView(bgView,20)
        .rightSpaceToView(bgView,20)
        .heightIs(30);
        lastView = btn;
    }
    
}

- (void)listViewBtnAction:(UIButton *)sender{
    if (_listViewBlock) {
        _listViewBlock(sender.tag);
    }
    [self removeView];
}


- (void)idCodeView{
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0,10, WIDTH -100, 50);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"请输入验证码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    idCodeView = [[IdCodeView alloc] init];
    idCodeView.frame = CGRectMake(10, 70, WIDTH-60, 30);
    idCodeView.delegate = self;
    [bgView addSubview:idCodeView];
    
    //确认按钮
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake((WIDTH-40)/2-35, 120, 70, 30);
    [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.backgroundColor = Base_Color3;
    [_submitBtn addTarget:self action:@selector(sureButtonCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.layer.cornerRadius = 4;
    _submitBtn.userInteractionEnabled = NO;
    [bgView addSubview:_submitBtn];
    
    
    bgView.frame = CGRectMake(20, 200, WIDTH-40, VH(_submitBtn)+10);
    UIViewController *vc = (UIViewController *)_target;
    bgView.center = CGPointMake(vc.view.center.x, vc.view.center.y-50);
    bgView.layer.cornerRadius = 5;
    
    [self addSubview:bgView];
}

//点击空白处取消按钮
- (void)canceButtonClcik
{
    if (_backViewClick) {
        _backViewClick(self);
    }
    [comboBox hiddenList];
    if (!_isMustShow && !_isBackClick) {
        [self removeView];
    }

}

//点击空白处取消按钮
- (void)canceButtonClcik1
{
    if (self.delegate&&[_delegate respondsToSelector:@selector(alertView:didClickCancel:)]) {
        [_delegate alertView:self didClickCancel:_title];
    }else if (_unitViewBlock){
        _unitViewBlock(_textField.text);
    }

    [comboBox hiddenList];
    if (!_isMustShow) {
        [self removeView];
    }
}
//点击确定按钮
- (void)sureButtonClick:(UIButton *)button {
    if (self.delegate&&[_delegate respondsToSelector:@selector(alertView:didClickNormal:)]) {
        [_delegate alertView:self didClickNormal:_title];
    }else if (_unitViewBlock){
        _unitViewBlock(_textField.text);
    }
    
    if (!_isMustShow) {
        [self removeView];
    }
}
//图片视图
//展示图片的视图
- (id)initWithTarget:(id)target withWebViewContent:(NSString *)content;
{
    self = [super init];
    if (self) {
        _target = target;
        _content = content;
        [self setup];
        [self setupWebViewWithImage];
    }
    return self;
}
-(void)setupWebViewWithImage;
{
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    
    bgView.frame = CGRectMake(50,HEIGHT*3/2, WIDTH, HEIGHT*0.9);
    bgView.center = CGPointMake(self.center.x, self.center.y);
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.clipsToBounds = YES;
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
        UIButton *HideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        HideBtn.frame = CGRectMake(bgView.bounds.size.width-80, 0, 80, 30);
        [HideBtn addTarget:self action:@selector(webViewDiss) forControlEvents:UIControlEventTouchUpInside];
//        [HideBtn setTitle:@"隐藏" forState:UIControlStateNormal];
//        HideBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        HideBtn.layer.cornerRadius = 0.5;
//        HideBtn.layer.borderWidth = 1.0;
//        HideBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [bgView addSubview:HideBtn];
   

    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, bgView.bounds.size.width, bgView.bounds.size.height-40)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.clipsToBounds  = YES;
    imageV.layer.cornerRadius = 5;
    imageV.autoresizesSubviews = YES;
    NSURL *url = [NSURL URLWithString:_content];
    imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageV.userInteractionEnabled = YES;
    [imageV sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick)];
    [bgView addGestureRecognizer:tap];
    
    
    UIButton *diss = [UIButton buttonWithType:UIButtonTypeCustom];
    diss.frame = CGRectMake((bgView.bounds.size.width-90)/2, bgView.bounds.size.height-40,90, 40);
    [diss setImage:[UIImage imageNamed:@"alertDiss"] forState:UIControlStateNormal];
    [diss addTarget:self action:@selector(webViewDiss) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:imageV];
    [bgView addSubview:diss];
}

- (void)bgViewClick{
    if (_backViewClick) {
        _backViewClick(self);
    }
    
}

//展示图片的弹窗
-(void)WebviewShow
{
    //实现提示框的回弹效果
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [self show];
    } completion:^(BOOL finished) {
        //动画里嵌套动画
        [UIView animateWithDuration:1 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }];
}

-(void)webViewDiss
{
    //取消时，放大并且修改透明度  最后移除
    [UIView animateWithDuration:1 animations:^{
        self.transform = CGAffineTransformMakeScale(3, 3);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _alertWindow.hidden = YES;
        _alertWindow = nil;
    }];
    if (self.delegate&&[_delegate respondsToSelector:@selector(alertViewDidClickNoticeImageView:)]) {
        [self.delegate alertViewDidClickNoticeImageView:self];
    }
}

- (void)sureButtonCodeClick:(UIButton *)sender{
    if (self.delegate && [_delegate respondsToSelector:@selector(alertView:didClickIdCode:)]) {
        [_delegate alertView:self didClickIdCode:idCodeView.textField.text];
    }
//    [self removeFromSuperview];
    [self removeView];
}

- (void)sureButtonDropClick:(UIButton *)sender{
    if (self.delegate &&[_delegate respondsToSelector:@selector(alertView:didClickDropView:)]) {
        [_delegate alertView:self didClickDropView:_selectIndex];
    }else if (_viewClickBlock){
        _viewClickBlock(_selectIndex);
    }
    [self removeView];
}

- (void)sureButtonMarkClick:(UIButton *)sender{
    if (_markViewBlock){
        _markViewBlock(_markMutableArr,_otherTextView.text);
    }else if (self.delegate && [_delegate respondsToSelector:@selector(alertView:didClickRemarkView:)]) {
        [_delegate alertView:self didClickRemarkView:_markMutableArr];
    }
//    [self removeFromSuperview];
    [self removeView];
}

- (void)singleSureButtonClick:(UIButton *)sender{
    if (_viewClickBlock) {
        _viewClickBlock([_selView getSelectIndex]);
    }
    [self removeView];
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    [_markMutableArr setObject:@(newScorePercent) atIndexedSubscript:starRateView.tag];
}

- (void)show{
    if (comboBox) {
        UIViewController *vc = (UIViewController *)_target;
        [vc.view addSubview:self];
        return;
    }
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f, 0.f}, [[UIScreen mainScreen] bounds].size}];
    window.backgroundColor = [UIColor clearColor];
    window.windowLevel = UIWindowLevelNormal;
    window.alpha = 1.f;
    window.hidden = NO;
    
    [window addSubview:self];
    
    _alertWindow = window;
}

- (void)removeView{
    //星星视图弹出窗若是第一响应，点击则收起键盘而不是移除弹出窗
    if ([_otherTextView isFirstResponder]) {
        [_otherTextView resignFirstResponder];
    }else{
        [self removeFromSuperview];
        _alertWindow.hidden = YES;
        _alertWindow = nil;
    }
    
}

-(void)comboBoxView:(XJComboBoxView *)comboBoxView didSelectRowAtValueMember:(NSString *)valueMember displayMember:(NSString *)displayMember{
    _submitBtn.backgroundColor = Base_Orange;
    _submitBtn.userInteractionEnabled = YES;
    _selectIndex = [valueMember integerValue];
}

- (void)idCodeView:(IdCodeView *)view didInputSuccessCode:(NSString *)idCode{
    _submitBtn.backgroundColor = Base_Orange;
    _submitBtn.userInteractionEnabled = YES;
}

- (void)idCodeView:(IdCodeView *)view didChangeCode:(NSString *)idCode{
    _submitBtn.backgroundColor = Base_Color3;
    _submitBtn.userInteractionEnabled = NO;
}

- (void)CodeTextFieldDidChange:(NSNotification *)notice{
    if (![notice.object isEqual:_textField]) {
        return;
    }
    if (_textField.text.length==0) {
        _inputTxtsureButton.enabled = NO;
        _inputTxtsureButton.backgroundColor = Base_Color3;
    }else{
        _inputTxtsureButton.enabled = YES;
        _inputTxtsureButton.backgroundColor = Base_Orange;
    }
    
}

- (void)CodetextFieldDidBeginEditing:(NSNotification *)notice{
    if (![notice.object isEqual:_textField]) {
        return;
    }
    [UIView animateWithDuration:.3 animations:^{
        self.superview.centerY -= 50;
    }];
    
}

- (void)CodetextFieldDidEndEditing:(NSNotification *)notice{
    if (![notice.object isEqual:_textField]) {
        return;
    }
    [UIView animateWithDuration:.3 animations:^{
        self.superview.centerY += 50;
    }];
    
}


@end
