//
//  LoadingViewController.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "LoadingViewController.h"
#import "MainViewController.h"
@interface LoadingViewController ()
@property (nonatomic,strong)UIImageView *imageV;

@property (nonatomic,copy)UILabel *noticeL;
@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.imageV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    NSArray *lanchArr = @[@"Lanch.jpg",@"lanch1.jpg"];
    int x = arc4random() % 2;
    NSString *imageName = lanchArr[x];
    self.imageV.image = [UIImage imageNamed:imageName];
    [self.view addSubview:self.imageV];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

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
