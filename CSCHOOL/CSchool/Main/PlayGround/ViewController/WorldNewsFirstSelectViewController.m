//
//  WorldNewsFirstSelectViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 17/1/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WorldNewsFirstSelectViewController.h"
#import "SDAutoLayout.h"
#import "UIButton+BackgroundColor.h"
#import "LRLChannelEditController.h"

@interface WorldNewsFirstSelectViewController ()

@property (nonatomic, copy) UIScrollView *mainScrollView;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, copy) NSMutableArray *selectArray;


@property (nonatomic, strong) NSMutableArray<ChannelUnitModel *> *topChannelArr;

@property (nonatomic, strong) NSMutableArray<ChannelUnitModel *> *bottomChannelArr;
@property (nonatomic, assign) NSInteger chooseIndex;


@end

@implementation WorldNewsFirstSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //
    [self createViews];
}

/**
    创建视图
 */
- (void)createViews{
    _mainScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = Color_Black;
    titleLabel.text = @"选择你想关注的频道";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_mainScrollView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(_mainScrollView,10)
    .topSpaceToView(_mainScrollView,5)
    .rightSpaceToView(_mainScrollView,10)
    .heightIs(50);
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"news_close"] forState:UIControlStateNormal];
//    closeBtn.backgroundColor = [UIColor grayColor];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:closeBtn];
    
    closeBtn.sd_layout
    .rightSpaceToView(_mainScrollView,0)
    .topSpaceToView(_mainScrollView,0)
    .heightIs(50)
    .widthIs(50);
    
    
    [self loadData];
}

- (void)createButton{
    UIButton *lastBtn = nil;
    _selectArray = [NSMutableArray array];

    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary *dataDic = _dataArray[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:dataDic[@"NAME"] forState:UIControlStateNormal];
        
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button setTitleColor:Color_Black forState:UIControlStateNormal];
        button.titleLabel.font = Title_Font;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:Base_Orange forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonSelcet:) forControlEvents:UIControlEventTouchUpInside];

        //        button.sd_cornerRadius = @(15);
        if ([dataDic[@"ELITE"] boolValue]) {
            button.selected = YES;
            [_selectArray addObject:_dataArray[i]];
        }
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 15;
        [_mainScrollView addSubview:button];
        
        CGFloat btnWith = (kScreenWidth-100)/3;
        CGFloat btnHeight = 31;
        CGFloat btnSpace = 20;
        CGFloat threeBord = (100-20*2)/2;
        CGFloat twiBord = (kScreenWidth-2*btnWith-btnSpace)/2;
        
        if (i%5 < 3) {
            button.frame = CGRectMake(threeBord+i%5*(btnWith+btnSpace), 67+i/5*(btnHeight*2+btnSpace*2), btnWith,btnHeight);
        }else{
            button.frame = CGRectMake(twiBord+(i%5-3)*(btnWith+btnSpace), 67+(i/5)*(btnHeight*2+btnSpace*2)+(btnHeight+btnSpace), btnWith,btnHeight);
        }
        lastBtn = button;
        button.tag = i;
    }
    
    [_mainScrollView setupAutoContentSizeWithBottomView:lastBtn bottomMargin:20];
}

- (void)loadData{
    
    NSDictionary *commitDic = @{
                                @"rid":@"getNewsTag"
                                };
    //[AppUserIndex GetInstance].API_URL
#warning 改地址
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataArray = responseObject[@"data"];
        [self createButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorView:error[@"msg"] andImageName:nil];
    }];
}

- (void)closeAction:(UIButton *)sender{
    if (_closeVCBliock) {
        _closeVCBliock(_selectArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonSelcet:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_selectArray addObject:_dataArray[sender.tag]];
    }else{
        [_selectArray removeObject:_dataArray[sender.tag]];
    }
    
//    [self showSelVC];
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
