//
//  BusForNewStuController.m
//  CSchool
//
//  Created by mac on 17/8/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

//                   _ooOoo_
//                  o8888888o
//                  88" . "88
//                  (| -_- |)
//                  O\  =  /O
//               ____/`---'\____
//             .'  \\|     |//  `.
//            /  \\|||  :  |||//  \
//           /  _||||| -:- |||||-  \
//           |   | \\\  -  /// |   |
//           | \_|  ''\---/''  |   |
//           \  .-\__  `-`  ___/-. /
//         ___`. .'  /--.--\  `. . __
//      ."" '<  `.___\_<|>_/___.'  >'"".
//     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//     \  \ `-.   \_ __\ /__ _/   .-` /  /
//======`-.____`-.___\_____/___.-`____.-'======
//                   `=---='
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//         佛祖保佑       永无BUG
//  本模块已经经过开光处理，绝无可能再产生bug
//=============================================

#import "BusForNewStuController.h"
#import "UIView+SDAutoLayout.h"
#import "OrderNewBusViewController.h"
#import "UIButton+BackgroundColor.h"
#import "UserPhoneInputViewController.h"
#import "UserPhoneInput2ViewController.h"
#import "UserPhoneInput3ViewController.h"
#import "BusChoseModel.h"
@interface BusForNewStuController ()
{
    UIButton *_startBtn;
    UIButton *_editBtn;
}
@property (nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong)UIImageView *headImageV;
@property (nonatomic,strong)UIImageView *noticeView;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *noticeL;//提示文本
@property (nonatomic,assign)BOOL  isHaveOrder;//是否有预约信息
@end

@implementation BusForNewStuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [AppUserIndex GetInstance].yanzhengPhoneArray = @[@"18306442957",@"1596410245",@"13173001909"];
    
    self.title = @"迎新接站";
    self.view.backgroundColor = Base_Color2;
    [self createView];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"UserHaveAddMessage" object:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
-(void)loadData
{
    [ProgressHUD show:@"正在加载..."];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"checkTravelIsHave",@"userid":stuNum} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *dic = responseObject[@"data"];
        BusChoseModel *model = [BusChoseModel new];
        [model yy_modelSetWithDictionary:dic];
        
        if ([model.count intValue]==1) {
            _isHaveOrder = YES;
            _startBtn.enabled = NO;
            _editBtn.enabled = YES;
            _startBtn.hidden = YES;
            _editBtn.hidden = NO;
            [_editBtn sd_clearAutoLayoutSettings];
            _editBtn.sd_layout.leftSpaceToView(self.mainScrollView,60).rightSpaceToView(self.mainScrollView,60).topSpaceToView (self.lineView,81).heightIs(36);
            [_editBtn updateLayout];
            [_startBtn setTitle:@"已预约" forState:UIControlStateNormal];
        }else{
            
            _editBtn.hidden = YES;
            _startBtn.hidden = NO;
            [_startBtn sd_clearAutoLayoutSettings];
            _startBtn.sd_layout.leftSpaceToView(self.mainScrollView,60).rightSpaceToView(self.mainScrollView,60).topSpaceToView (self.lineView,81).heightIs(36);
            [_startBtn updateLayout];
            _startBtn.enabled = YES;
            _editBtn.enabled = NO;
            
            _isHaveOrder = NO;
        }
        //更改提示文字
        self.noticeL.text = model.contentText;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:@"获取数据失败,点击重新获取"];
    }];
}
-(void)createView
{
    self.mainScrollView = ({
        UIScrollView *view = [UIScrollView new];
        view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        view.backgroundColor  =  [UIColor whiteColor];
        view;
    });
    [self.view addSubview:self.mainScrollView ];
    self.headImageV = ({
        UIImageView *view  = [UIImageView new];
        view.image = [UIImage imageNamed:@"headBus"];
        view;
    });
    
    self.noticeView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"newschol_sdjzu"];
        view;
    });
    
    self.lineView  =({
        UIView *view = [UIView new];
        view.layer.borderColor = RGB(255,240,0).CGColor;
        view.layer.borderWidth = 2;
        view;
    });
    
    self.noticeL = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(66,66,65);
        view.font = [UIFont systemFontOfSize:13.0f];
        view.text = @"尊敬的新同学:您好，这里是建大校车接送服务，请您提前详细填写相关信息并提交，届时将有校车将您安全的送入建大校园，请保持电话畅通，手机号码必须使用通知书中所携带的三张电话卡,以便我们及时联系您。";
        view;
    });
    [self.mainScrollView sd_addSubviews:@[self.headImageV,self.lineView,self.noticeView]];
    [self.lineView addSubview:self.noticeL];
    self.headImageV.sd_layout.leftSpaceToView(self.mainScrollView,0).topSpaceToView(self.mainScrollView,0).widthIs(kScreenWidth).heightIs(LayoutHeightCGFloat(156));
    self.lineView.sd_layout.leftSpaceToView(self.mainScrollView,14).topSpaceToView(self.headImageV,30).rightSpaceToView(self.mainScrollView,14);
    self.noticeView.sd_layout.centerXIs(self.mainScrollView.centerX).topSpaceToView(self.headImageV,7).widthIs(4*36-3*2).heightIs(36);
    self.noticeL.sd_layout.leftSpaceToView(self.lineView,11).rightSpaceToView(self.lineView,11).topSpaceToView (self.lineView,30).autoHeightRatio(0);
    [self.lineView setupAutoHeightWithBottomView:self.noticeL bottomMargin:24];
    
    _startBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setBackgroundColor:Base_Orange forState:UIControlStateNormal];;
        [view setBackgroundColor:Base_Color2 forState:UIControlStateSelected];;
        view.enabled = NO;
        [view setTitle:@"开始预约" forState:UIControlStateNormal];
        
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(startOrderBus:) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = [UIFont systemFontOfSize:14];
        view.layer.cornerRadius = 2;
        view.clipsToBounds = YES;
        view;
    });
    _editBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.borderWidth = 1;
        [view setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];;
        [view setBackgroundColor:Base_Color2 forState:UIControlStateSelected];;

        view.layer.borderColor = Base_Orange.CGColor;
        [view setTitle:@"编辑预约信息" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view addTarget:self action:@selector(editOrderBus) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = [UIFont systemFontOfSize:14];
        view.enabled = NO;
        view.layer.cornerRadius = 2;
        view.clipsToBounds = YES;
        view;
    });
    
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.mainScrollView sd_addSubviews:@[_startBtn,_editBtn]];
    CGFloat width = (kScreenWidth-22*2-50)/2;
    _startBtn.sd_layout.leftSpaceToView(self.mainScrollView,22).topSpaceToView(self.lineView,81).widthIs(width).heightIs(36);
    _editBtn.sd_layout.rightSpaceToView(self.mainScrollView,22).topEqualToView(_startBtn).widthIs(width).heightIs(36);
    [self.mainScrollView setupAutoContentSizeWithBottomView:_startBtn bottomMargin:143];
}
#pragma mark  开始约约
-(void)startOrderBus:(UIButton *)sender
{
    
    if ([AppUserIndex GetInstance].yanzhengPhoneArray.count <2) {
        UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"使用迎新接站功能必须验证2张以上手机卡，以便我们更快捷的联系到您！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openPhoneNum];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
        return;
        
    }
    OrderNewBusViewController *vc = [OrderNewBusViewController new];
    vc.isEdit = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)editOrderBus{
    /*
     if ([AppUserIndex GetInstance].yanzhengPhoneArray.count <2) {
     UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"使用迎新接站功能必须验证2张以上手机卡，以便我们更快捷的联系到您！" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     [self openPhoneNum];
     }];
     
     UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
     }];
     [alert addAction:action1];
     [alert addAction:action2];
     
     [self.navigationController presentViewController:alert animated:YES completion:nil];
     
     return;
     
     }
     */
    
    OrderNewBusViewController *vc = [OrderNewBusViewController new];
    vc.isEdit = YES;
    [self.navigationController pushViewController:vc animated:YES];
   
}
-(void)openPhoneNum
{
    if ([[AppUserIndex GetInstance].yanzhengPhoneArray count] == 0) {
        UserPhoneInputViewController *phoneVC = [[UserPhoneInputViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:phoneVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }else if ([[AppUserIndex GetInstance].yanzhengPhoneArray count] == 1) {
        UserPhoneInput2ViewController *phoneVC = [[UserPhoneInput2ViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:phoneVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }else if ([[AppUserIndex GetInstance].yanzhengPhoneArray count] == 2) {
        UserPhoneInput3ViewController *phoneVC = [[UserPhoneInput3ViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:phoneVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UserHaveAddMessage" object:nil];
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
