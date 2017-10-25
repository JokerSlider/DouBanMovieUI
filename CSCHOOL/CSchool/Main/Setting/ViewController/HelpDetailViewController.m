//
//  HelpDetailViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/19.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "HelpListTableViewCell.h"

@interface HelpDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详情";
    _titleLabel.text = _model.title;
    _contentTextView.text = _model.content;
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
