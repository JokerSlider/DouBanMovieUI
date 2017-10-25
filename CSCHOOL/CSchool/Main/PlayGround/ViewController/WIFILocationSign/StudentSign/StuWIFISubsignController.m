//
//  StuWIFISubsignController.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "StuWIFISubsignController.h"
#import <YYModel.h>
#import "WIFICellModel.h"
#import "UIView+SDAutoLayout.h"
#import "JYZTextView.h"
#import "WIFISIgnToolManager.h"
@interface StuWIFISubsignController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UIButton *_beginSignBtn;
}
@property (nonatomic,strong)UITableView *mainTableView;

@property (nonatomic,strong)JYZTextView *suggesView;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,strong)NSMutableArray *subTitleArr;
@end

@implementation StuWIFISubsignController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createView];
    self.view.backgroundColor = Base_Color2;
    self.title = @"提交补签信息";

}
-(void)loadData
{
    self.titleArr = [NSMutableArray array];
    self.subTitleArr = [NSMutableArray array];
    [_titleArr addObjectsFromArray:@[@"签到课程:",@"课程时间",@"任课教师",@"签到状态:"]];
    
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    NSArray *stateArr = @[@"未签到",@"已签到",@"学生补签",@"教师代签",@"补签待处理",@"补签不通过"];    // aci_state 签到状态 1、未签到 2、已签到、3、学生补签、4、教师代签 5、补签待处理 6.补签不通过

    [NetworkCore requestPOST:url parameters:@{@"rid":@"getSignDetById",@"id":_model.aci_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            
            WIFICellModel *model = [WIFICellModel new];
            [model yy_modelSetWithDictionary:dic];
            int index = [_model.aci_state intValue];
            [_subTitleArr addObjectsFromArray:@[model.kcmc,[[WIFISIgnToolManager shareInstance]tranlateDateString:model.aci_creattime withDateFormater:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"],model.teacher,stateArr[index]]];
        }
        
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [self createFooterView];
    [self.view addSubview:self.mainTableView];
}
-(UIView *)createFooterView
{
    UIView *backView = [UIView new];
    _beginSignBtn = ({
        UIButton *view = [UIButton new];
        [view setTitle:@"提交补签申请" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:16];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setBackgroundColor:Base_Orange];
        [view addTarget:self action:@selector(beginSign:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [backView addSubview:_beginSignBtn];
    
    UILabel *noticeL = ({
        UILabel *view  = [UILabel new];
        view.textColor = Base_Orange;
        view.font = [UIFont systemFontOfSize:15];
        view.text = @"申请理由:";
        view;
    });
    
    self.suggesView = ({
        JYZTextView*view = [[JYZTextView alloc]initWithFrame:CGRectMake(5, 10, kScreenWidth-10, 200)];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        view.font = [UIFont systemFontOfSize:14.f];
        view.textColor = [UIColor blackColor];
        view.textAlignment = NSTextAlignmentLeft;
        view.tag = 1000;
        view.placeholder = @" 请务必填写补签理由！";
        view.placeHoderFont = [UIFont systemFontOfSize:13];
        view.placeholderColor = RGB(178, 178, 178);
        view;
    });
    [backView addSubview:noticeL];
    [backView addSubview:self.suggesView];
    
    noticeL.sd_layout.leftSpaceToView(backView,14).rightSpaceToView(backView,0).topSpaceToView(backView,10).heightIs(15);
    self.suggesView.sd_layout.leftEqualToView(noticeL).topSpaceToView(noticeL,11).rightSpaceToView(backView,14).heightIs(100);
    
    _beginSignBtn.sd_layout.leftSpaceToView(backView,14).rightSpaceToView(backView,14).heightIs(41).bottomSpaceToView(backView,20);
    backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-5*45-15);
    return backView;
}

#pragma mark  DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subTitleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID  =  @"stuSignInfocell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font =[UIFont systemFontOfSize:15];
    cell.textLabel.textColor = Color_Black ;
    cell.textLabel.text = [NSString stringWithFormat:@"%@              %@",self.titleArr[indexPath.row],self.subTitleArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
#pragma mark 点击事件
-(void)beginSign:(UIButton *)sender
{
    if (_suggesView.text.length ==0&&[self isEmpty:_suggesView.text]) {
        [JohnAlertManager showFailedAlert:@"请输入补签申请理由!" andTitle:@"提示"];
        return;
    }
    [ProgressHUD show:@"正在操作..."];
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL

    [NetworkCore requestPOST:url parameters:@{@"rid":@"signUpByUserid",@"id":_model.aci_id,@"userid":stuNum,@"content":_suggesView.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        if ([responseObject[@"data"] isEqualToString:@"1"]) {
            [_beginSignBtn setTitle:@"补签成功" forState:UIControlStateNormal];
            _beginSignBtn.enabled = NO;
            [_beginSignBtn setTitleColor:RGB(183, 183, 183) forState:UIControlStateNormal];
            _beginSignBtn.layer.borderColor = RGB(183, 183, 183).CGColor;
            _beginSignBtn.layer.borderWidth = 0.5;
            _beginSignBtn.layer.cornerRadius = 2;
            if (_subSignSucessBlock) {
                _subSignSucessBlock(@"补签成功");
            }
        }
        [JohnAlertManager showFailedAlert:responseObject[@"msg"] andTitle:@"提示"];
} failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];

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
