//
//  OAInputCell.m
//  CSchool
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAInputCell.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import "OATextViewEditController.h"
#import "UIView+UIViewController.h"
#import "OAChoseViewController.h"
#import "MOFSPickerManager.h"

@interface     OAInputCell()<YYTextViewDelegate,UITextFieldDelegate>


/***当前键盘是否可见*/
@property (nonatomic,assign)BOOL TextIsVisiable;
@end
@implementation OAInputCell
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
//        view.backgroundColor = [UIColor clearColor];
        view;
    });

    [self.contentView sd_addSubviews:@[_titleLabel,_inputText]];
    _titleLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,0).widthIs(100).bottomSpaceToView(self.contentView,0);
    _inputText.sd_layout.rightSpaceToView(self.contentView,20).centerYIs(self.contentView.centerY).leftSpaceToView(_titleLabel,15).heightIs(25);

    self.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self setupAutoHeightWithBottomView:_inputText bottomMargin:10];
    // 添加监听器，监听自己的文字改变通知
}


-(void)setModel:(OAModel *)model
{
    _model = model;
//    _choseArr = model.dataObj;
    _titleLabel.text = model.fieldLable;
    NSString *pleaseWord ;
    //字段类型checkbox（多选）、radio（单选）、 select（单选 ） textarea（大文字输入）、datetime(年月日时分秒)、data（年月日）、text、text（数字）、hidden（隐藏）
    if ([model.fieldType isEqualToString:@"checkbox"]||[model.fieldType isEqualToString:@"radio"]||[model.fieldType isEqualToString:@"select"]||[model.fieldType isEqualToString:@"dateTime"]||[model.fieldType isEqualToString:@"date"]) {
        pleaseWord = @"请选择";
    }else if ([model.fieldType isEqualToString:@"textarea"]||[model.fieldType isEqualToString:@"text"]||[model.fieldType isEqualToString:@"number"]){
        pleaseWord = @"请输入";
    }else{
        
    }
    _inputText.placeholder  = [NSString stringWithFormat:@"%@%@",pleaseWord,model.fieldLable];
    _inputText.text = model.filedSubTitle;
    CGSize size = [_titleLabel boundingRectWithSize:CGSizeMake(0, 25)];
    _titleLabel.sd_layout.widthIs(size.width);
    
    if ([model.fieldType isEqualToString:@"text"]) {//用户  部门  部门多选   用户多选
        if ([[model.defaultValue firstObject] isEqualToString:@"用户"]||[[model.defaultValue firstObject] isEqualToString:@"部门"]||[[model.defaultValue firstObject] isEqualToString:@"部门多选"]||[[model.defaultValue firstObject] isEqualToString:@"用户多选"]) {
            _TextIsVisiable = NO;
            UIView *alphaView = [UIView new];
            alphaView.backgroundColor  = [UIColor clearColor];
            [self.contentView addSubview:alphaView];
            alphaView.sd_layout.rightSpaceToView(self.contentView,0).leftSpaceToView(_titleLabel,0).topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OpenTextView)];
            [alphaView addGestureRecognizer:tapGesture];
            _inputText.sd_layout.leftSpaceToView(_titleLabel,15).centerYIs(self.contentView.centerY).rightSpaceToView(self.contentView,-8).heightIs(25);
            [_inputText updateLayout];
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }else{
            self.accessoryType = UITableViewCellAccessoryNone;
            _TextIsVisiable = YES;
        }
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
    OAChoseViewController *vc = [OAChoseViewController new];
    if ([[_model.defaultValue firstObject] isEqualToString:@"用户"]) {
        vc.isMoreSelct = NO;
        vc.objArr = _model.content;
        vc.title = @"请选择";
        vc.OAChooseListBlock = ^(NSArray *objArr){
            NSMutableArray *textArr =[NSMutableArray new];
            NSMutableArray *IDArr = [NSMutableArray new];
            for (NSDictionary *dic in objArr) {
                [textArr addObject:dic[@"key"]];
                [IDArr addObject:dic[@"value"]];
            }
            
            _inputText.text = [objArr componentsJoinedByString:@","];
            //进入选择页面
            if (_selectEndBlock) {
                _selectEndBlock([textArr componentsJoinedByString:@","] ,[IDArr componentsJoinedByString:@","],_inputText.tag);
            }
        };

    }else if ([[_model.defaultValue firstObject] isEqualToString:@"部门"]){
        vc.isMoreSelct = NO;
        vc.objArr = _model.content;
        vc.title = @"请选择";
        vc.OAChooseListBlock = ^(NSArray *objArr){
            NSMutableArray *textArr =[NSMutableArray new];
            NSMutableArray *IDArr = [NSMutableArray new];
            for (NSDictionary *dic in objArr) {
                [textArr addObject:dic[@"key"]];
                [IDArr addObject:dic[@"value"]];
            }
            
            _inputText.text = [objArr componentsJoinedByString:@","];
            //进入选择页面
            if (_selectEndBlock) {
                _selectEndBlock([textArr componentsJoinedByString:@","] ,[IDArr componentsJoinedByString:@","],_inputText.tag);
            }
        };

    }else if ([[_model.defaultValue firstObject] isEqualToString:@"部门多选"]){
        vc.isMoreSelct = YES;
        vc.objArr = _model.content;
        vc.title = @"请选择";
        vc.OAChooseListBlock = ^(NSArray *objArr){
            NSMutableArray *textArr =[NSMutableArray new];
            NSMutableArray *IDArr = [NSMutableArray new];
            for (NSDictionary *dic in objArr) {
                [textArr addObject:dic[@"key"]];
                [IDArr addObject:dic[@"value"]];
            }
            
            _inputText.text = [objArr componentsJoinedByString:@","];
            //进入选择页面
            if (_selectEndBlock) {
                _selectEndBlock([textArr componentsJoinedByString:@","] ,[IDArr componentsJoinedByString:@","],_inputText.tag);
            }
        };

    }else if ([[_model.defaultValue firstObject] isEqualToString:@"用户多选"]){
        vc.isMoreSelct = YES;
        vc.objArr = _model.content;
        vc.title = @"请选择";
        vc.OAChooseListBlock = ^(NSArray *objArr){
            NSMutableArray *textArr =[NSMutableArray new];
            NSMutableArray *IDArr = [NSMutableArray new];
            for (NSDictionary *dic in objArr) {
                [textArr addObject:dic[@"key"]];
                [IDArr addObject:dic[@"value"]];
            }
            
            _inputText.text = [objArr componentsJoinedByString:@","];
            //进入选择页面
            if (_selectEndBlock) {
                _selectEndBlock([textArr componentsJoinedByString:@","] ,[IDArr componentsJoinedByString:@","],_inputText.tag);
            }
        };

    }
    [self.viewController.navigationController pushViewController:vc animated:YES];

}
#pragma  mark  打开弹窗
-(void)OpenListView
{
    //字段类型checkbox（多选）、radio（单选）、 select（单选 ） textarea（大文字输入）、datetime(年月日时分秒)、data（年月日）、text、number（数字）、hidden（隐藏）

    [self.viewController.view endEditing:YES];
    //跳转到新页面进行编辑 ！！！！！
    //多选
    if ([_model.fieldType isEqualToString:@"checkbox"]){
        OAChoseViewController *vc = [OAChoseViewController new];
        vc.isMoreSelct = YES;
        vc.objArr = _model.content;
        vc.title = @"请选择";
        vc.OAChooseListBlock = ^(NSArray *objArr){
            NSMutableArray *textArr =[NSMutableArray new];
            NSMutableArray *IDArr = [NSMutableArray new];
            for (NSDictionary *dic in objArr) {
                [textArr addObject:dic[@"key"]];
                [IDArr addObject:dic[@"value"]];
            }

            _inputText.text = [objArr componentsJoinedByString:@","];
            //进入选择页面
            if (_selectEndBlock) {
                _selectEndBlock([textArr componentsJoinedByString:@","] ,[IDArr componentsJoinedByString:@","],_inputText.tag);
            }
        };
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else if([_model.fieldType isEqualToString:@"select"]||[_model.fieldType isEqualToString:@"radio"]){//单选
        OAChoseViewController *vc = [OAChoseViewController new];
        vc.objArr = _model.content;
        vc.title = @"请选择";
        vc.isMoreSelct = NO;
        vc.OAChooseListBlock = ^(NSArray *objArr){
            NSMutableArray *textArr =[NSMutableArray new];
            NSMutableArray *IDArr = [NSMutableArray new];
            for (NSDictionary *dic in objArr) {
                [textArr addObject:dic[@"key"]];
                [IDArr addObject:dic[@"value"]];
            }
            _inputText.text = [textArr componentsJoinedByString:@","];
            //进入选择页面
            if (_selectEndBlock) {
                _selectEndBlock([textArr componentsJoinedByString:@","] ,[IDArr componentsJoinedByString:@","],_inputText.tag);
            }
        };
        [self.viewController.navigationController pushViewController:vc animated:YES];

    }
    else if([_model.fieldType isEqualToString:@"textarea"]){
        //进入新页面进行编辑  进入编辑页面
        NSLog(@"进入新的编辑页面");
        OATextViewEditController *vc = [[OATextViewEditController alloc]init];
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
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        //根据精度选择时间选择的格式
        /*
         * @param model : UIDatePickerMode 日期模式，有四种 UIDatePickerModeTime,   UIDatePickerModeDate, UIDatePickerModeDateAndTime, UIDatePickerModeCountDownTimer
         
         df.dateFormat = @"yyyy-MM-dd";         UIDatePickerModeDate

         
         df.dateFormat = @"yyyy-MM-dd HH:mm";       UIDatePickerModeDateAndTime

         **/
        
        [[MOFSPickerManager shareManger] showDatePickerWithTag:1 datePickerMode:UIDatePickerModeDateAndTime commitBlock:^(NSDate *date) {
            NSString *chooseDate = [df stringFromDate:date];
            self.inputText.text = chooseDate;
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
        df.dateFormat = @"yyyy-MM-dd";
        [[MOFSPickerManager shareManger] showDatePickerWithTag:1 datePickerMode:UIDatePickerModeDate commitBlock:^(NSDate *date) {
            NSString *chooseDate = [df stringFromDate:date];
            self.inputText.text = chooseDate;
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
