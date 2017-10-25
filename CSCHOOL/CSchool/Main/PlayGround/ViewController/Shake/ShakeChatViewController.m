//
//  ShakeChatViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 17/3/24.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ShakeChatViewController.h"
#import "YYImage.h"
#import "SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XGChatViewController.h"

@interface ShakeChatViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;

@property (nonatomic, retain) YYImage *shakeImage;

@property (nonatomic, retain) UILabel *showText;

@property (nonatomic, retain) UIImageView *shakeImageView;

@property (nonatomic, retain) UIView *userView;

@property (nonatomic, retain) UIImageView *headerImageView;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, assign) BOOL isRequsting;

@property (nonatomic, retain) NSDictionary *dataDic;
@end

@implementation ShakeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"摇一摇";
    [self createViews];
    
    // 设置当前对象成为第一响应者 (viewcontroller 对象)
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 取消当前对象成为第一响应者
    [self resignFirstResponder];
}

// 设置当前对象是否可以成为第一响应者
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake) {
        NSLog(@"摇一摇开始");
        CAKeyframeAnimation *animation1 = [self shakeAnimation];
        
        NSArray *animations = @[animation1];
        
        // 1. 创建动画组对象
        CAAnimationGroup *group = [CAAnimationGroup animation];
        
        // 设置动画组重复执行
        group.repeatCount = 1;
        
        // 2. 定义动画组对象
        group.animations = animations;
        
        group.duration = 3;
        
        // 3. 将动画添加图层上
        [_shakeImageView.layer addAnimation:group forKey:nil];
        
        _showText.text = @"正在为你匹配...";
        if (!_isRequsting) {
            _isRequsting = YES;
            [self loadData];
        }
    }
}

- (void)loadData{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getShackInfo",@"userid":[AppUserIndex GetInstance].role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _isRequsting = NO;

        if ([responseObject[@"data"] allKeys].count>0) {
            _userView.hidden = NO;
            _nameLabel.text = [responseObject valueForKeyPath:@"data.NC"];
            [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[responseObject valueForKeyPath:@"data.TXDZ"]]];
            _showText.text = @"匹配成功";
            _dataDic = responseObject[@"data"];
        }else{
            _showText.text = @"匹配失败，重新摇一摇";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇一摇结束");
    
}

- (void)createViews{
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_back"]];
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_shakeText"]];
    
//    _shakeImage = [YYImage imageNamed:@"shake_shakeImg_1"];
    
    _shakeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_shakeImg_1"]];
    
    _showText = [[UILabel alloc] init];
    _showText.font = [UIFont systemFontOfSize:15];
    _showText.textAlignment = NSTextAlignmentCenter;
    
    [_mainScrollview sd_addSubviews:@[backImageView, iconImage, _shakeImageView, _showText]];
    
    backImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    iconImage.sd_layout
    .topSpaceToView(_mainScrollview, 40)
    .widthIs(154)
    .heightIs(50)
    .centerXEqualToView(_mainScrollview);
    
    _shakeImageView.sd_layout
    .topSpaceToView(iconImage,40)
    .widthIs(LayoutHeightCGFloat(190))
    .heightIs(LayoutHeightCGFloat(190))
    .centerXEqualToView(iconImage);
    
    _showText.sd_layout
    .leftSpaceToView(_mainScrollview,10)
    .rightSpaceToView(_mainScrollview,10)
    .heightIs(25)
    .topSpaceToView(_shakeImageView,LayoutHeightCGFloat(10));
    
    _userView = [[UIView alloc] init];
    _userView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [_mainScrollview addSubview:_userView];
    _userView.sd_layout
    .topSpaceToView(_showText,10)
    .leftSpaceToView(_mainScrollview,60)
    .rightSpaceToView(_mainScrollview,60)
    .heightIs(75)
    .centerXEqualToView(_mainScrollview);
    
    _userView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userViewClick:)];
    [_userView addGestureRecognizer:tap];
    
    _headerImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = [UIColor whiteColor];
    
    UIImageView *right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake_right"]];
    
    [_userView sd_addSubviews:@[_headerImageView, _nameLabel, right]];
    
    right.sd_layout
    .rightSpaceToView(_userView,13)
    .widthIs(10)
    .heightIs(17)
    .centerYEqualToView(_userView);
    
    _headerImageView.sd_layout
    .leftSpaceToView(_userView,16)
    .widthIs(36)
    .heightIs(36)
    .centerYEqualToView(_userView);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_headerImageView,10)
    .centerYEqualToView(_headerImageView)
    .heightIs(20)
    .rightSpaceToView(right,5);

}

- (void)userViewClick:(UITapGestureRecognizer *)sender{
    XGChatViewController *vc = [[XGChatViewController alloc] init];
    vc.jidStr = _dataDic[@"YHBH"];
    [self.navigationController pushViewController:vc animated:YES];
}

// 摇晃动画
- (CAKeyframeAnimation *)shakeAnimation
{
    // 1. 创建关键帧动画
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 动画时长
    keyframe.duration = 2;
    
    // 设置加速方式
    keyframe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // 摇晃角度（设置旋转角度）
    CGFloat angel = M_PI_4 / 2;
    
    NSArray *values = @[@(angel), @(-angel), @(angel)];
    
    keyframe.values = values;
    
    // 重复次数
    keyframe.repeatCount = 4;
    
    return keyframe;
    
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
