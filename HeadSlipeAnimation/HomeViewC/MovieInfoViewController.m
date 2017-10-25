//
//  MovieInfoViewController.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/23.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MovieInfoViewController.h"
#import <YYModel.h>
#import "HomeMainModel.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MovieInfoViewController ()
{
    UILabel *_filmNameL;
    UILabel *_yearL;//年份
    UILabel *_ratingL;//评分
    UILabel *_directorL;//导演
    UILabel *_castsL;//主演
    UIImageView *_filmImage;//电影海报
    UILabel *_filmType;//电影类型
    UILabel *_countryL;//国家
    UILabel *_lookedL;//看过
    UILabel *_wangtLokL;//想看

    UILabel *_sumTitle;//
    UILabel *_summeryL;//描述
}
@end

@implementation MovieInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self loadData];

}
-(void)createView
{
    self.title = @"详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _filmImage = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    });
    _filmNameL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view;
    });
    _yearL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:11];
        view.textColor = Color_Gray;
        view;
    });
    _ratingL = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view;
    });
    _directorL = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view;
    });
    _castsL = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view.numberOfLines = 0;
        view;
    });
    
    _filmType = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view;
    });
    _countryL = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view;
    });
    _lookedL = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view;
    });
    _wangtLokL = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:11];
        view;
    });
    [self.view sd_addSubviews:@[_filmImage,_filmNameL,_yearL,_ratingL,_directorL,_castsL,_filmType,_countryL,_lookedL,_wangtLokL]];
    UIView *contentView = self.view;
    _filmImage.sd_layout.leftSpaceToView(contentView,20).topSpaceToView(contentView,74).heightIs(200).widthIs(KscreenWidth*1/3);
    _filmNameL.sd_layout.leftSpaceToView(_filmImage,20).topEqualToView(_filmImage).widthIs(100).heightIs(14);
    _yearL.sd_layout.leftSpaceToView(_filmNameL,1).topSpaceToView(contentView,76).widthIs(100).heightIs(14);
    _ratingL.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_filmNameL,13).widthIs(200).heightIs(14);
    _directorL.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_ratingL,13).widthIs(200).heightIs(14);
    _filmType.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_directorL,13).widthIs(200).heightIs(14);
    _countryL.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_filmType,10).widthIs(KscreenWidth-KscreenWidth*1/3-13-15).heightIs(14);
    _lookedL.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_countryL,10).widthIs(KscreenWidth-KscreenWidth*1/3-13-15).heightIs(14);
    _wangtLokL.sd_layout.leftSpaceToView(_lookedL,5).topEqualToView(_lookedL).widthIs(KscreenWidth-KscreenWidth*1/3-13-15).heightIs(14);
    _castsL.sd_layout.leftEqualToView(_filmNameL).topSpaceToView(_wangtLokL,6).widthIs(KscreenWidth-KscreenWidth*1/3-13-15-12).heightIs(30);

    _sumTitle =({
        UILabel  *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:16];
        view;
    });
    
    _summeryL = ({
        UILabel  *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:13];
        view;
    });
    [self.view sd_addSubviews:@[_sumTitle,_summeryL]];
    _sumTitle.sd_layout.leftEqualToView(_filmImage).topSpaceToView(_filmImage,20).widthIs(100).heightIs(15);
    _summeryL.sd_layout.leftEqualToView(_filmImage).topSpaceToView(_sumTitle,10).rightSpaceToView(self.view,20).autoHeightRatio(0);
}
-(void)loadData
{
    NSString *movieURL  =  [NSString stringWithFormat:@"%@/%@",Movie_Info,_ID];
    [[ToolMannger shareInstance] showProgressView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [DouBNetCore requestNewPOST:movieURL parameters:@{} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [[ToolMannger shareInstance] dissmissProgressView];
            
            NSDictionary *dic = responseObject;
            HomeMainModel *model = [HomeMainModel new];
            [model yy_modelSetWithDictionary:dic];
            
            [self setData:model];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [[ToolMannger shareInstance] dissmissProgressView];
            
        }];

    });
   
}
-(void)setData:(HomeMainModel *)model
{
    _filmNameL.text = model.title;
    
    _yearL.text = model.year;
    
    NSDictionary *imgDic = model.images;
    NSString *imagUrl = imgDic[@"large"];
    [_filmImage sd_setImageWithURL:[NSURL URLWithString:imagUrl]];
    
    float ratValue = [model.rating[@"average"] floatValue];
    NSString *ratingStr = [NSString stringWithFormat:@"评分    %0.1f",ratValue];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:ratingStr];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:11.0]
     
                          range:NSMakeRange(2, 2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor orangeColor]
     
                          range:NSMakeRange(6, 3)];
    
    _ratingL.attributedText = AttributedStr;
    //遍历查找
    NSMutableArray *directors = [NSMutableArray array];
    NSMutableArray *carsts  =[ NSMutableArray array];
    for (NSDictionary *dic in model.directors) {
        HomeMainModel *model = [HomeMainModel new];
        [model yy_modelSetWithDictionary:dic];
        [directors addObject:model.name];
    }
    for (NSDictionary *dic in model.casts) {
        HomeMainModel *model = [HomeMainModel new];
        [model yy_modelSetWithDictionary:dic];
        [carsts addObject:model.name];
    }
    
    NSString *directorName = [directors componentsJoinedByString:@","];
    _directorL.text = [NSString stringWithFormat:@"导演    %@",directorName];
    
    NSString *carts = [carsts componentsJoinedByString:@" "];
    _castsL.text = [NSString stringWithFormat:@"主演    %@",carts];
    
    NSString *type = [model.genres componentsJoinedByString:@" "];
    _filmType.text = [NSString stringWithFormat:@"类型    %@",type];
    
    _countryL.text = [NSString stringWithFormat:@"国家    %@",[model.countries componentsJoinedByString:@" "]];
    
    _wangtLokL.text = [NSString stringWithFormat:@"想看(%@)",model.wish_count];
    
    _lookedL.text = [NSString stringWithFormat:@"看过(%@)",model.collect_count];

    _summeryL.text = model.summary;
    
    
    _sumTitle.text = @"剧情介绍";

    CGSize  size = [_filmNameL boundingRectWithSize:CGSizeMake(0, 15)];
    _filmNameL.sd_layout.widthIs(size.width);
    size = [_yearL boundingRectWithSize:CGSizeMake(0, 14)];
    _yearL.sd_layout.widthIs(size.width);
    
    size = [_wangtLokL boundingRectWithSize:CGSizeMake(0, 14)];
    _wangtLokL.sd_layout.widthIs(size.width);
    
    size = [_lookedL boundingRectWithSize:CGSizeMake(0, 14)];
    _lookedL.sd_layout.widthIs(size.width);
    
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
