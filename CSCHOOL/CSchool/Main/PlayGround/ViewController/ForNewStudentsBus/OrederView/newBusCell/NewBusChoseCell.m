//
//  NewBusChoseCell.m
//  CSchool
//
//  Created by mac on 17/8/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "NewBusChoseCell.h"
#import "NSDate+Extension.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import "OATextViewEditController.h"
#import "UIView+UIViewController.h"
#import "BusForNewChoseController.h"
#import "MOFSPickerManager.h"
#import <YYTextView.h>
#define maxWordNum   60
@interface   NewBusChoseCell()<YYTextViewDelegate,UITextFieldDelegate>
/***当前键盘是否可见*/
@property (nonatomic,assign)BOOL TextIsVisiable;
@end
@implementation NewBusChoseCell
{
    UILabel   *_titleLabel;
    NSArray  *_choseArr;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self  createView];
    }
    return  self;
}
//创建界面
-(void)createView
{
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    
    _inputText = ({
        UITextField *view = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth-250, 20, 150, 20)];
        view.font = [UIFont systemFontOfSize:13];
        view.textColor = RGB(153, 153, 153);
        view.textAlignment = NSTextAlignmentRight;
        view.delegate = self;
        view;
    });
    
    [self.contentView sd_addSubviews:@[_titleLabel,_inputText]];
    _titleLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,25/2).widthIs(100).heightIs(25);
    _inputText.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,25/2).leftSpaceToView(_titleLabel,15).heightIs(25);
    
    self.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self setupAutoHeightWithBottomView:_inputText bottomMargin:10];
    // 添加监听器，监听自己的文字改变通知
}


-(void)setModel:(BusChoseModel *)model
{
    _model = model;
    _titleLabel.text =[NSString stringWithFormat:@" %@:",model.fieldLable];
    if (model.isMust) {
        NSString *noticeStr =[NSString stringWithFormat:@"*%@:",model.fieldLable];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:noticeStr];
        
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor redColor]
         
                              range:NSMakeRange(0, 1)];
        
        _titleLabel.attributedText = AttributedStr ;

    }

    _inputText.placeholder  = [NSString stringWithFormat:@"%@",model.value];
    _inputText.text = model.filedSubTitle;
    CGSize size = [_titleLabel boundingRectWithSize:CGSizeMake(0, 25)];
    _titleLabel.sd_layout.widthIs(size.width);
    
    if ([model.fieldType isEqualToString:@"text"]) {
        _TextIsVisiable = NO;
        UIView *alphaView = [UIView new];
        alphaView.backgroundColor  = [UIColor clearColor];
        [self.contentView addSubview:alphaView];
        alphaView.sd_layout.rightSpaceToView(self.contentView,0).leftSpaceToView(_titleLabel,0).topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OpenTextView)];
        [alphaView addGestureRecognizer:tapGesture];
        _inputText.sd_layout.leftSpaceToView(_titleLabel,15).centerYIs(self.contentView.centerY).rightSpaceToView(self.contentView,20).heightIs(25);
        [_inputText updateLayout];
        self.accessoryType = UITableViewCellAccessoryNone;

    }else if ([model.fieldType isEqualToString:@"number"]){
        self.inputText.keyboardType = UIKeyboardTypeNumberPad;

    }
    else{
        _TextIsVisiable = NO;
        UIView *alphaView = [UIView new];
        alphaView.backgroundColor  = [UIColor clearColor];
        [self.contentView addSubview:alphaView];
        alphaView.sd_layout.rightSpaceToView(self.contentView,0).leftSpaceToView(_titleLabel,0).topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OpenListView)];
        [alphaView addGestureRecognizer:tapGesture];
        _inputText.sd_layout.leftSpaceToView(_titleLabel,15).centerYIs(self.contentView.centerY).rightSpaceToView(self.contentView,-8).heightIs(25);
        [_inputText updateLayout];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

#pragma mark ****
-(void)OpenTextView
{
  //打开文本输入框
    OATextViewEditController *vc = [[OATextViewEditController alloc]init];
    vc.maxWordCount  =  maxWordNum;
    if (_inputText.text.length!=0) {
        vc.contentText = _inputText.text;
    }
    vc.placeholderText = @"请输入";
    vc.OAtextViewEditBlock = ^(NSString *text){
        NSLog(@"%@",text);
        if (_selectEndBlock) {
            _selectEndBlock(text,text,_inputText.tag);
        }
        _inputText.text = text;
    };
    [self.viewController.navigationController pushViewController:vc animated:YES];

}
#pragma  mark  打开弹窗
-(void)OpenListView
{
    //字段类型checkbox（多选）、radio（单选）、 select（单选 ） textarea（大文字输入）、datetime(年月日时分秒)、data（年月日）、text、number（数字）、hidden（隐藏）
    
    [self.viewController.view endEditing:YES];
    //跳转到新页面进行编辑 ！！！！！

  if([_model.fieldType isEqualToString:@"select"]){//单选
        BusForNewChoseController *vc = [BusForNewChoseController new];
        vc.objArr = _model.content;
        vc.title = @"请选择";
        vc.isMoreSelct = NO;
        vc.BusChooseListBlock  = ^(NSArray *objArr){
            NSMutableArray *textArr =[NSMutableArray new];
            NSMutableArray *IDArr = [NSMutableArray new];
            for (NSDictionary *dic in objArr) {
                [textArr addObject:dic[@"ta_name"]];
                [IDArr addObject:dic[@"ta_id"]];
            }
            _inputText.text = [textArr componentsJoinedByString:@","];
            //进入选择页面
            if (_selectEndBlock) {
                _selectEndBlock([textArr componentsJoinedByString:@","] ,[IDArr componentsJoinedByString:@","],_inputText.tag);
            }
        };
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
  }else if ([_model.fieldType isEqualToString:@"mutiselect"]){
      BusForNewChoseController *vc = [BusForNewChoseController new];
      vc.objArr = _model.content;
      vc.title = @"请选择";
      vc.isMoreSelct = YES;
      vc.BusChooseListBlock  = ^(NSArray *objArr){
          NSMutableArray *textArr =[NSMutableArray new];
          NSMutableArray *IDArr = [NSMutableArray new];
          for (NSDictionary *dic in objArr) {
              [textArr addObject:dic[@"ta_name"]];
              [IDArr addObject:dic[@"ta_id"]];
          }
          _inputText.text = [textArr componentsJoinedByString:@","];
          //进入选择页面
          if (_selectEndBlock) {
              _selectEndBlock([textArr componentsJoinedByString:@","] ,[IDArr componentsJoinedByString:@","],_inputText.tag);
          }
      };
      [self.viewController.navigationController pushViewController:vc animated:YES];
  }else if([_model.fieldType isEqualToString:@"text"]){
        //进入新页面进行编辑  进入编辑页面
        NSLog(@"进入新的编辑页面");
        OATextViewEditController *vc = [[OATextViewEditController alloc]init];
        vc.maxWordCount  = maxWordNum;
        if (_inputText.text.length!=0) {
            vc.contentText = _inputText.text;
        }
        vc.placeholderText = @"请输入";
        vc.OAtextViewEditBlock = ^(NSString *text){
            NSLog(@"%@",text);
            if (_selectEndBlock) {
                _selectEndBlock(text,text,_inputText.tag);
            }
            _inputText.text = text;
        };
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else if ([_model.fieldType isEqualToString:@"dateTime"]){
        //时间选择
        //隐藏其他无关的控件
        __weak typeof (self) weakSelf = self;
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        //根据精度选择时间选择的格式
        /*
         * @param model : UIDatePickerMode 日期模式，有四种 UIDatePickerModeTime,   UIDatePickerModeDate, UIDatePickerModeDateAndTime, UIDatePickerModeCountDownTimer
         
         df.dateFormat = @"yyyy-MM-dd";         UIDatePickerModeDate
         
         
         df.dateFormat = @"yyyy-MM-dd HH:mm";       UIDatePickerModeDateAndTime
         
         **/
        
        [[MOFSPickerManager shareManger] showDatePickerWithTag:1 datePickerMode:UIDatePickerModeDateAndTime commitBlock:^(NSDate *date) {
            NSString *chooseDate = [df stringFromDate:date];
            self.inputText.text = [NSDate tranlateOldDateTimeString:date withOldFormat:df.dateFormat andNewformat:@"yyyy-MM-dd HH:mm"];
            if (_selectEndBlock) {
                _selectEndBlock(chooseDate,chooseDate,_inputText.tag);
            }
            
        } cancelBlock:^{
            [weakSelf endEditing:YES];
        }];
    }else if ([_model.fieldType isEqualToString:@"date"]){
        //时间选择
        //隐藏其他无关的控件
        __weak typeof (self) weakSelf = self;
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [[MOFSPickerManager shareManger] showDatePickerWithTag:1 datePickerMode:UIDatePickerModeDate commitBlock:^(NSDate *date) {
            NSString *chooseDate = [df stringFromDate:date];
            
            self.inputText.text = [NSDate tranlateOldDateTimeString:date withOldFormat:df.dateFormat andNewformat:@"yyyy-MM-dd HH:mm"];
            if (_selectEndBlock) {
                _selectEndBlock(chooseDate,chooseDate,_inputText.tag);
            }
            
        } cancelBlock:^{
            [weakSelf endEditing:YES];
        }];
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"%@",textField.text);
    if (_selectEndBlock) {
        _selectEndBlock(textField.text,@"",_inputText.tag);
    }
}

@end
