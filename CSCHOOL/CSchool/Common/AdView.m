//
//  AdView.m
//  CSchool
//
//  Created by 左俊鑫 on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AdView.h"
#import "SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <YYModel.h>
#import "RxWebViewController.h"
#import "UIView+UIViewController.h"

@implementation AdModel



@end

@implementation AdView
{
    UIImageView *_adImageView;
    NSString *_source; //来源：1：缴费
    
}

-(instancetype)initWithFrame:(CGRect)frame withStyle:(AdViewStyle)adViewStyle withSource:(NSString *)source;
{
    self = [super initWithFrame:frame];
    if (self) {
        switch (adViewStyle) {
            case AdViewImage:
            {
                _source = source;
                [self setAdViewImage];
                [self loadData];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (void)setAdViewImage{
    _adImageView = [[UIImageView alloc] init];
    [self addSubview:_adImageView];
    _adImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
    [_adImageView addGestureRecognizer:tap];
    _adImageView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
}

- (void)imageTap{
    if (_model.jump_url && [_model.jump_url length] > 0) {
        RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:_model.jump_url]];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)loadData{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showAdvertPush",@"source":_source} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *dataArray = responseObject[@"data"];
        if (dataArray.count > 0) {
            _model = [[AdModel alloc] init];
            [_model yy_modelSetWithDictionary:dataArray[0]];
            if (_model.photo_url) {
                [_adImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo_url]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

@end
