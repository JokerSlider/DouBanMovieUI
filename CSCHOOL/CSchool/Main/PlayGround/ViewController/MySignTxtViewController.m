//
//  MySignTxtViewController.m
//  CSchool
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MySignTxtViewController.h"
#import "UIView+SDAutoLayout.h"
#import "MyInfoModel.h"
@interface MySignTxtViewController ()<UITextViewDelegate>
{
    UITextView *_txtView;
    UILabel    *_fireLabel;//约束字数的label
}
@end
@implementation MySignTxtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    _txtView = ({
        UITextView *view = [UITextView new];
        view.font = Title_Font;
        view.inputView.backgroundColor = [UIColor whiteColor];
        view.textColor = Color_Black;
        view.delegate = self;
        view.backgroundColor = [UIColor whiteColor];
        [view becomeFirstResponder];
        view;
    });
    _fireLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Gray;
        view.font = Small_TitleFont;
        view;
    });
    [_txtView addSubview:_fireLabel];
    [self.view addSubview:_txtView];
    _txtView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,10).rightSpaceToView(self.view,0).heightIs(80);
    _fireLabel.sd_layout.rightSpaceToView(_txtView,10).bottomSpaceToView(_txtView,5).widthIs(15).heightIs(15);
    [self setNavBtn];
    
    if (![_placdeTxt isEqualToString:@""]) {
        _txtView.text = _placdeTxt;
        NSUInteger  length = _placdeTxt.length;
        _fireLabel.text = [NSString stringWithFormat:@"%ld",30-length];
    }
}
//设置导航栏
-(void)setNavBtn
{
    UIButton *myZone = [UIButton buttonWithType:UIButtonTypeCustom];
    [myZone setTitle:@"保存" forState:UIControlStateNormal];
    [myZone setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    myZone.frame = CGRectMake(0, 0, 50, 30);
    [myZone addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:myZone];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelBtn.frame = CGRectMake(0, 0, 50, 30);
    cancelBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
}
//取消按钮事件
-(void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//保存
-(void)saveAction
{
    if ([self.placdeTxt isEqualToString:_txtView.text]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSDictionary *param =@{
                           @"username":user.role_id,
                           @"personnote":_txtView.text,
                           @"rid":@"updateUserInfoByInput",
                           };
    //上传服务器  --  并回传当前值到上个界
    [ProgressHUD show:@"正在修改..."];
    [NetworkCore requestPOST:user.API_URL parameters:param success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [ProgressHUD dismiss];
        MyInfoModel *model = [[MyInfoModel alloc]init];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [model yy_modelSetWithDictionary:dic];
        }
        user.personnote =[NSString stringWithFormat:@"%@",model.mySignTxt];
        [user saveToFile];
        if (_editSucessBlock) {
            _editSucessBlock(_txtView.text);
        } 
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
    
}
#pragma mark textField的字数限制
- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 30)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:30];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    _fireLabel.text = [NSString stringWithFormat:@"%ld",MAX(0,30 - existTextNum)];  }
#pragma mark 超过30字不能输入
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < 30) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 30 - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            _fireLabel.text = [NSString stringWithFormat:@"%d",0];
        }
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
