//
//  OASuggestionController.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OASuggestionController.h"
#import "JYZTextView.h"
#import "UIButton+BackgroundColor.h"
#import "UIView+SDAutoLayout.h"
#import "OAMonitorViewController.h"
#import "OAChoseNodeController.h"
#import "MyOAProcedureController.h"
#import "OAModel.h"
#import "MOFSPickerManager.h"
#import "YLButton.h"
@interface OASuggestionController ()<UITextViewDelegate>
@property (nonatomic,strong)  JYZTextView *suggesView;
@property (nonatomic,strong)  UILabel *noticeLabel;
@property (nonatomic,copy)    NSArray *departmentArr;
@property (nonatomic,strong)  UIButton *rejectBtn;//驳回
@property (nonatomic,strong)  UIButton *passBtn ;//同意
@property (nonatomic,strong)  UIButton *nopassBtn ;//不同意
@property (nonatomic,copy)    NSString *in_node_id;//下一步审核人
@property (nonatomic,copy)    NSString *in_yhbh;//下一步审核人


@property (nonatomic,assign) BOOL  isEnd;//是否是最后审批人
@property (nonatomic,assign) BOOL   isNeedUser;//是否需要审批人
@property (nonatomic,copy)   NSString *endnodeID;//

@property (nonatomic,strong)NSMutableArray *messageArr;//快捷回复消息


@end

@implementation OASuggestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"意见填写";
    [self loadData];
}

-(void)loadSuggestionData
{
    self.messageArr = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"%@/getExMessage",OABase_URL];
    
    [NetworkCore requestMD5POST:url parameters: nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject) {
            OAModel *model = [OAModel new];
            [model yy_modelSetWithDictionary:dic];
            [_messageArr addObject:model.md_message];
        }

    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:@"获取信息失败,请重新获取!"];
    }];
}
-(void)setSelectMessage
{
    [self.suggesView endEditing:YES];

    __weak typeof(self) weakSelf = self;
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:_messageArr tag:1 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        if (self.suggesView.text.length>0) {
            self.suggesView.text = [NSString stringWithFormat:@"%@%@",self.suggesView.text,string];
        }else{
            self.suggesView.text = string;
        }
        [self.suggesView textChanged:nil];
    } cancelBlock:^{
              
        [weakSelf.view endEditing:YES];
    }];

}

-(void)getNodeButton
{
    NSString *url = [NSString stringWithFormat:@"%@/getBtnByOidAndUserAndScode",OABase_URL];

    [NetworkCore requestMD5POST:url parameters:@{@"in_oi_id":_oi_id,@"in_yhbh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"in_oi_id,in_yhbh,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [self createView:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:@"获取信息失败,请重新获取!"];
    }];
}

-(void)loadData
{
    /*
     sfks integer,是否开始节点 1 是 0 否
     sfjs integer,是否结束节点 1 是 0 否
     sfyb integer 是否有阅办   1 是 0 否
     
     */
    [self getNodeButton];
    [self loadSuggestionData];

    NSString *url = [NSString stringWithFormat:@"%@/getFlowNodeByOid",OABase_URL];
    [NetworkCore requestMD5POST:url parameters:@{@"in_oi_id":_oi_id,@"scode":[AppUserIndex GetInstance].schoolCode,@"in_yhbh":OATeacherNum,@"flag":@"in_oi_id,in_yhbh,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //是否需要审批人
        if ([responseObject[@"sfspr"] boolValue]) {
            _isNeedUser = YES;
        }else{
            _isNeedUser = NO;
        }
        if (![responseObject[@"sfjs"] boolValue]) {
            _endnodeID = @"0";
            _isEnd = NO;
        }else{
            _isEnd = YES;
            _endnodeID =[NSString stringWithFormat:@"%@",responseObject[@"sfjs"]];
        }
        if ([responseObject[@"sfyb"] boolValue]) {
            UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"阅办监控" style:UIBarButtonItemStylePlain target:self action:@selector(jianKong:)];
            self.navigationItem.rightBarButtonItem = rightBarItem;
        }else{
            NSLog(@"没有阅办监控的权限。");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:@"获取信息失败,请重新获取!"];
    }];
    
}

-(void)createView:(NSArray *)btnArr
{
    UILabel *noticeL = ({
        UILabel *view  = [UILabel new];
        view.text = @"填写审批意见";
        view.textColor = RGB(85, 85, 85);
        view.font = [UIFont systemFontOfSize:15];
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
        view.placeholder = @" 请填写您的审批意见！";
        view.placeHoderFont = [UIFont systemFontOfSize:11];
        view.placeholderColor = RGB(153, 153, 153);
        view;
    });
    YLButton * messageBtn = ({
      YLButton *view   = [YLButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"fastMsg"] forState:UIControlStateNormal];
        [view setTitle:@"快捷回复" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:12];
        [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        view.imageRect = CGRectMake(0, 0, 15, 15);
        view.titleRect = CGRectMake(15, 0, 60, 15);
        view.frame = CGRectMake(0, 0, 80, 15);
        [view addTarget:self action:@selector(setSelectMessage) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    self.rejectBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.cornerRadius =4;
        view.clipsToBounds = YES;
        view.layer.borderColor = RGB(202, 224, 228).CGColor;
        view.layer.borderWidth = 1;
        [view setTitleColor:RGB(132, 154, 157) forState:UIControlStateNormal];
        [view setTitle:@"退  回" forState:UIControlStateNormal];
        view.backgroundColor  = RGB(253, 10, 14);
        view.titleLabel.font = [UIFont systemFontOfSize:16];
        view.tag = 3;
//        [view setBackgroundColor:RGB(253, 10, 14) forState:UIControlStateNormal];
        [view setBackgroundColor:RGB(202, 224, 228) forState:UIControlStateNormal];

        [view setBackgroundColor:Color_Gray forState:UIControlStateSelected];
        

        [view addTarget:self action:@selector(rejectThisprocedure:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });

    self.passBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.cornerRadius = 4 ;
        view.clipsToBounds = YES;
        view.layer.borderColor = RGB(255, 215, 118).CGColor;
        [view setTitleColor:RGB(177, 117, 50) forState:UIControlStateNormal];
        [view setTitle:@"通  过" forState:UIControlStateNormal];
        view.tag = 1;
        [view addTarget:self action:@selector(passThisprocedure:) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = [UIFont systemFontOfSize:16];
//        [view setBackgroundColor:RGB(65, 206, 118) forState:UIControlStateNormal];
        [view setBackgroundColor:RGB(255, 215, 118) forState:UIControlStateNormal];

        [view setBackgroundColor:Color_Gray forState:UIControlStateSelected];
        view;
    });
    self.nopassBtn =({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.cornerRadius = 4 ;
        view.clipsToBounds = YES;
        view.layer.borderColor = Base_Orange.CGColor;
        [view setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [view setTitle:@"不 通 过" forState:UIControlStateNormal];
        view.tag = 2;
        [view addTarget:self action:@selector(passThisprocedure:) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = [UIFont systemFontOfSize:16];
        view.backgroundColor = RGB(253, 51, 118);
        [view setBackgroundColor: Base_Orange forState:UIControlStateNormal];
        [view setBackgroundColor:Color_Gray forState:UIControlStateSelected];
        view;
    });


    
    self.noticeLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Base_Orange    ;
        view.font = [UIFont systemFontOfSize:13];
        view;
    });
    [self.view sd_addSubviews:@[noticeL,self.suggesView,self.rejectBtn,self.nopassBtn,self.passBtn,self.noticeLabel]];
    
    
    noticeL.sd_layout.leftSpaceToView(self.view,20).topSpaceToView(self.view,30).widthIs(100).heightIs(15);
    self.suggesView.sd_layout.leftEqualToView(noticeL).topSpaceToView(noticeL,29).rightSpaceToView(self.view,20).heightIs(130);
    self.noticeLabel.sd_layout.topSpaceToView(self.suggesView,3).leftEqualToView(noticeL).rightSpaceToView(self.view,20).autoHeightRatio(0);
    self.passBtn.sd_layout.leftSpaceToView(self.view, 40).rightSpaceToView(self.view, 40).topSpaceToView(self.noticeLabel, 30).heightIs(40);
    self.nopassBtn.sd_layout.leftEqualToView(self.passBtn).rightEqualToView(self.passBtn).topSpaceToView(self.passBtn, 30).heightIs(40);
    self.rejectBtn.sd_layout.leftEqualToView(self.passBtn).rightEqualToView(self.passBtn).topSpaceToView(self.nopassBtn, 30).heightIs(40);

    [self.suggesView addSubview:messageBtn];
    
    messageBtn.sd_layout.rightSpaceToView(self.suggesView, 5).bottomSpaceToView(self.suggesView,5).widthIs(100).heightIs(15);

    CGSize size = [messageBtn.titleLabel boundingRectWithSize:CGSizeMake(0, 15)];
    messageBtn.sd_layout.widthIs(size.width+messageBtn.imageView.width);
    //1，2，4
    NSArray *allFuncArr= @[@"1",@"2",@"4"];//通过，不通过，退回
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",btnArr];
    //得到两个数组中不同的数据
    NSArray * reslutFilteredArray = [allFuncArr filteredArrayUsingPredicate:filterPredicate];
    if ([reslutFilteredArray containsObject:@"1"]) {
        [self trageBtnEnble:self.passBtn]; // 隐藏passBtn  均分其他两个按钮
        self.passBtn.sd_layout.heightIs(0);
        self.nopassBtn.sd_layout.topSpaceToView(self.noticeLabel, 30);
    }
    
    if([reslutFilteredArray containsObject:@"2"]){
        [self trageBtnEnble:self.nopassBtn];
        self.nopassBtn.sd_layout.heightIs(0);
//        self.nopassBtn.hidden =
        self.rejectBtn.sd_layout.topSpaceToView(self.passBtn, 30);
    }
    
    if([reslutFilteredArray containsObject:@"4"]){
        [self trageBtnEnble:self.rejectBtn];
        self.rejectBtn.sd_layout.heightIs(0);
    }
}
-(void)trageBtnEnble:(UIButton *)button
{
    button.enabled = NO;
    button.backgroundColor = [UIColor lightGrayColor];
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
#pragma mark 点击事件
-(void)jianKong:(UIButton *)sender
{
    OAMonitorViewController *vc = [[OAMonitorViewController alloc]init];
    vc.oi_id = _oi_id;
    [self.navigationController pushViewController:vc animated:YES];
}
//同意 或者  不同意
-(void)passThisprocedure:(UIButton *)sender
{
    NSString *pushState = [NSString stringWithFormat:@"%d",(int)sender.tag];
    if (_suggesView.text.length==0) {
        [self.suggesView becomeFirstResponder];
        [JohnAlertManager showFailedAlert:@"请填写审批意见!" andTitle:@"提示"];
        return;
    }
    if (_isEnd||!_isNeedUser) {
        [self uploadData:pushState];
        return;
    }
   
    OAChoseNodeController *vc = [OAChoseNodeController new];
    vc.oi_id = _oi_id;
    vc.fi_id = _fi_id;
    vc.state = pushState;//同意
    vc.strs = @"";//修改按钮暂时禁用  传空字符串；
    vc.in_ho_de = _suggesView.text;
    [self.navigationController pushViewController:vc animated:YES];
}
//驳回
-(void)rejectThisprocedure:(UIButton *)sender
{
    NSLog(@"驳回该流程！！！！");
    if (_suggesView.text.length==0) {
        [JohnAlertManager showFailedAlert:@"请填写审批意见!" andTitle:@"提示"];
        return;
    }
//    if (_isEnd||!_isNeedUser) {
//        return;
//    }
    OAChoseNodeController *vc = [OAChoseNodeController new];
    vc.oi_id = _oi_id;
    vc.fi_id = _fi_id;
    vc.state = @"4";//同意
    vc.strs = @"";//修改按钮暂时禁用  传空字符串；
    vc.in_ho_de = _suggesView.text;
    [self.navigationController pushViewController:vc animated:YES];
}
//驳回


//最后审批人   提交数据

#pragma mark 上传数据
-(void)uploadData:(NSString *)state
{
    NSString *url = [NSString stringWithFormat:@"%@/saveFlowForm",OABase_URL];
    [NetworkCore requestMD5POST:url parameters:@{@"in_my_yhbh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"in_oi_id":_oi_id,@"in_fi_id":_fi_id,@"in_close_node":@"",@"in_oi_state":@"1",@"strs":@"",@"in_node_id":_endnodeID ,@"in_yhbh":@"",@"in_sds_code":[AppUserIndex GetInstance].schoolCode,@"in_ho_state":state,@"in_ho_de":_suggesView.text,@"flag":@"in_my_yhbh,scode,in_oi_id,in_fi_id,in_close_node,in_oi_state,strs,in_node_id,in_yhbh,in_sds_code,in_ho_state,in_ho_de"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [JohnAlertManager showFailedAlert:@"提交成功!" andTitle:@"提示"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"OAHaveBeApprove" object:nil];
        [self popToMainViewController];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
-(void)popToMainViewController
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *temArray = self.navigationController.viewControllers;
            
            for(UIViewController *temVC in temArray)
                
            {
                
                if ([temVC isKindOfClass:[MyOAProcedureController class]])
                    
                {
                    
                    [self.navigationController popToViewController:temVC animated:YES];
                    
                }
                
            }
            
        });
    });
}
#pragma mark textViewdelegeta


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
