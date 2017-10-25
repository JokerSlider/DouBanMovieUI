//
//  YunLoadingCell.m
//  CSchool
//
//  Created by 左俊鑫 on 17/5/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunLoadingCell.h"
#import "ZZCircleProgress.h"
#import "SDAutoLayout.h"
#import "YunLogoImageHelper.h"
#import "LEOUtility.h"

@implementation YunLoadingCell
{
    UIImageView *_logoImageView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    ZZCircleProgress *_cirProgress;
    UILabel *_speedLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.clipsToBounds = YES;
    
    _logoImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view;
    });
    
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view.lineBreakMode = NSLineBreakByTruncatingMiddle;
        view;
    });
    
    _subTitleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = Color_Gray;
        view;
    });
    
    _speedLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = Color_Gray;
        view;
    });
    
    //无小圆点、同动画时间
    _cirProgress = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 26, 26) pathBackColor:nil pathFillColor:Base_Orange startAngle:-90 strokeWidth:2];
    _cirProgress.showPoint = NO;
    _cirProgress.animationModel = CircleIncreaseByProgress;
//    _cirProgress.progress = 0.6;
    _cirProgress.increaseFromLast = YES;
    _cirProgress.showProgressText = NO;

    [self.contentView sd_addSubviews:@[_logoImageView, _titleLabel, _subTitleLabel, _cirProgress, _speedLabel]];

    _logoImageView.sd_layout
    .leftSpaceToView(self.contentView,30)
    .topSpaceToView(self.contentView,12)
    .widthIs(36)
    .heightIs(36);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_logoImageView,10)
    .topSpaceToView(self.contentView,15)
    .heightIs(16)
    .rightSpaceToView(self.contentView,45);
    
    _cirProgress.sd_layout
    .rightSpaceToView(self.contentView, 14)
    .centerYEqualToView(self.contentView)
    .widthIs(26)
    .heightIs(26);
    
    _speedLabel.sd_layout
    .rightSpaceToView(_cirProgress,16)
    .topSpaceToView(_titleLabel, 5)
    .widthIs(100)
    .heightIs(12);
    
    _subTitleLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,7)
    .heightIs(9);
    


}

- (void)setModel:(LEOWebDAVItem *)model{
    _model = model;
    
    _titleLabel.text = model.displayName;
    _subTitleLabel.text = model.contentSize;
    
    YunLogoImageHelper *helper = [[YunLogoImageHelper alloc] init];
    [helper imageWithType:model getImage:^(UIImage *image) {
        _logoImageView.image = image;
    }];
}

-(void)setFileUrl:(NSString *)fileUrl{
    _fileUrl = fileUrl;
//    NSArray *arr = [fileUrl componentsSeparatedByString:@"/"];
    _titleLabel.text = fileUrl.lastPathComponent;
    NSData *data = [NSData dataWithContentsOfFile:fileUrl];
    _subTitleLabel.text = [LEOUtility formattedFileSize:data.length];
    
}

-(void)setIsDown:(BOOL)isDown{
    _isDown = isDown;
    _cirProgress.hidden = isDown;
    _speedLabel.hidden = isDown;
}

- (void)updateProgress:(float)percent{
    _cirProgress.progress = percent;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
