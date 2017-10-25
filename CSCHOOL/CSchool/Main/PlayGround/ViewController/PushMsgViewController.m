//
//  PushMsgViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/5/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PushMsgViewController.h"
#import "UIView+SDAutoLayout.h"

@interface PushMsgViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation PushMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createSubViews];
}
- (IBAction)finishBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createSubViews{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = Title_Font;
    [_mainScrollView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(_mainScrollView,10)
    .rightSpaceToView(_mainScrollView,10)
    .topSpaceToView(_mainScrollView,50)
    .autoHeightRatio(0);
    
    titleLabel.text = _contentStr;
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
