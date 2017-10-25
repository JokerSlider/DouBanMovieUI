//
//  PhotoWallSendViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/11/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhotoWallSendViewController.h"
#import "SDAutoLayout.h"
#import "PhotoWallIndexViewController.h"
#import "MyFlowerListViewController.h"

@interface PhotoWallSendViewController ()

@property (nonatomic, retain) UIScrollView *mainScrollView;

@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation PhotoWallSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"照片发布";
    [self createViews];
}

- (void)createViews{
    _mainScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _imageView = ({
        UIImageView *view = [UIImageView new];
        view.image = _image;
        view.sd_cornerRadius = @(8);
        view;
    });
    
    [_mainScrollView addSubview:_imageView];
    
    _imageView.sd_layout
    .leftSpaceToView(_mainScrollView, 15)
    .rightSpaceToView(_mainScrollView, 15)
    .topSpaceToView(_mainScrollView, 10)
    .heightEqualToWidth(1);
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = Base_Orange;
    [sendButton setTitle:@"确认发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.sd_cornerRadius = @(3);
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:sendButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.layer.borderColor = Base_Orange.CGColor;
    cancelButton.layer.borderWidth = 1.0f;
    [cancelButton setTitle:@"重新选择" forState:UIControlStateNormal];
    [cancelButton setTitleColor:Base_Orange forState:UIControlStateNormal];
    cancelButton.sd_cornerRadius = @(3);
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:cancelButton];
    
    sendButton.sd_layout
    .leftSpaceToView(_mainScrollView,15)
    .rightSpaceToView(_mainScrollView,15)
    .topSpaceToView(_imageView,30)
    .heightIs(40);
    
    cancelButton.sd_layout
    .leftSpaceToView(_mainScrollView,15)
    .rightSpaceToView(_mainScrollView,15)
    .topSpaceToView(sendButton,20)
    .heightIs(40);
}

- (void)sendAction:(UIButton *)sender{
    [ProgressHUD show:@"正在上传图片"];
 
    [NetworkCore uploadImage:_image withURL:[AppUserIndex GetInstance].photowallUrl withParams:@{} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self saveAction:[responseObject valueForKeyPath:@"data.IRIURL"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)saveAction:(NSString *)photoUrl{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"addPhotowallRelease",@"userid":[AppUserIndex GetInstance].role_id,@"photourl":photoUrl} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"发送成功"];
        [self performSelector:@selector(popVc) withObject:nil afterDelay:0.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)popVc{
//    [self.navigationController popViewControllerAnimated:YES];
    
    MyFlowerListViewController *vc = [[MyFlowerListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:NO];

    [_indexVC composePicAdd];
    
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
