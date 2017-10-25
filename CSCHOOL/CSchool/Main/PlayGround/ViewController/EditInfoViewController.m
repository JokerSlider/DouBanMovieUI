//
//  EditInfoViewController.m
//  CSchool
//
//  Created by mac on 16/11/15.
//  Copyright © 2016年 Joker. All rights reserved.
//          /*@"昵称编辑页面"**/

#import "EditInfoViewController.h"
#import "UIView+SDAutoLayout.h"
#import "MyTxtField.h"
#import "MyInfoModel.h"
#import "ValidateObject.h"
#import "XMPPvCardTemp.h"
#import "HQXMPPManager.h"

@interface EditInfoViewController ()<UITextViewDelegate>

@property (nonatomic,strong)MyTxtField *txtInputView;
@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
   
    self.txtInputView = ({
        MyTxtField *view = [MyTxtField new];
        view.font = Title_Font;
        view.inputView.backgroundColor = [UIColor whiteColor];
        view.textColor = Color_Black;
        view.backgroundColor = [UIColor whiteColor];
        view.clearButtonMode = UITextFieldViewModeAlways;
        [view becomeFirstResponder];
        view;
    });
    if (![_placdeTxt isEqualToString:@""]) {
        self.txtInputView.text = _placdeTxt;
    }else{
        self.txtInputView.text = @"";
    }
    if ([self.title isEqualToString:@"昵称"]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:self.txtInputView];
    }else if ([self.title isEqualToString:@"办公地点"])
    {
        
    }else{
        _txtInputView.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    [self.view addSubview:self.txtInputView];
    self.txtInputView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,10).heightIs(30);
    [self setNavBtn];
}

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

-(void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveAction
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSDictionary *param ;
    //如果有变动就进行服务器请求  没有就不进行请求
    if ([self.placdeTxt isEqualToString:self.txtInputView.text]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self.title isEqualToString:@"昵称"]) {
        if ([self.txtInputView.text isEqualToString:@""]||[self isEmpty:self.txtInputView.text]) {
            [ProgressHUD showError:@"您还没有输入名字，请输入"];
            return;
        }
        param = @{
                  @"username":user.role_id,
                  @"nickname":self.txtInputView.text,
                  @"rid":@"updateUserInfoByInput",
                  };
    }else if ([self.title isEqualToString:@"办公地点"]){
        param = @{
                  @"username":user.role_id,
                  @"bgdd":self.txtInputView.text,
                  @"rid":@"updateUserInfoByInput",
                  };
    }else if ([self.title isEqualToString:@"手机号2"]){
        if (![ValidateObject validateMobile:self.txtInputView.text]) {
            [ProgressHUD showError:@"请输入正确的手机号!"];
            return;
        }
        param = @{
                  @"username":user.role_id,
                  @"sjxh":self.txtInputView.text,
                  @"rid":@"updateUserInfoByInput",
                  };

    }else{
        if (![ValidateObject validateMobile:self.txtInputView.text]) {
            [ProgressHUD showError:@"请输入正确的手机号!"];
            return;
        }
        param = @{
                  @"username":user.role_id,
                  @"phone":self.txtInputView.text,
                  @"rid":@"updateUserInfoByInput",
                  };
    }
    //上传服务器  --  并回传当前值到上个界
    [ProgressHUD show:@"正在修改..."];
    [NetworkCore requestPOST:user.API_URL parameters:param success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [ProgressHUD dismiss];
        MyInfoModel *model = [[MyInfoModel alloc]init];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [model yy_modelSetWithDictionary:dic];
        }
        
        if ([self.title isEqualToString:@"昵称"]) {
            user.nickName = [NSString stringWithFormat:@"%@",model.nickName];
            //保存昵称到xmpp
            if ([AppUserIndex GetInstance].isUseChat) {
                [self updateXmppVcardUserNickName:model.nickName];
            }

        }else if ([self.title isEqualToString:@"办公地点"]){
            user.BGDD = model.BGDD;
        }else if ([self.title isEqualToString:@"手机号2"]){
            user.SJXH = model.SJXH;
        }else{
            user.phoneNum = [NSString stringWithFormat:@"%@",model.phoneNum];
        }

        [user saveToFile];
        if (_editSucessBlock) {
            _editSucessBlock(self.txtInputView.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {

    }];
}
-(void)updateXmppVcardUserNickName:(NSString *)nickName
{
    HQXMPPManager *app=[HQXMPPManager shareXMPPManager];
    XMPPvCardTemp *temp=app.vCard.myvCardTemp;
    temp.nickname=nickName;
    [app.vCard updateMyvCardTemp:temp];
}
/*@"检查文本是否全为空格"*/
- (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 8)
        {

            [ProgressHUD showError:@"最多输入8个字!"];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:8];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:8];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 8)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.txtInputView];
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
