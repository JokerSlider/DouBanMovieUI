//
//  BusListCell.m
//  CSchool
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BusListCell.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
@implementation BusListCell
{
    UILabel *_numLabel;//序号
    UILabel *_nameLabel;//站点名
    UILabel *_tagLabel;//备注
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    _numLabel = ({
        UILabel *view = [UILabel new];
        view.font = Small_TitleFont;
        view.text = @"";
        view.textColor = Color_Black;
        view;
    });
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"";
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:16.0];
        view;
    });
    _tagLabel = ({
        UILabel *view = [UILabel new];
        view.font = Small_TitleFont;
        view.textColor = Color_Gray;
        view.text = @"";
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_numLabel,_nameLabel,_tagLabel]];
    _numLabel.sd_layout.leftSpaceToView(contentView,15).centerYIs(self.centerY).widthIs(10).heightIs(10);
    _nameLabel.sd_layout.leftSpaceToView(_numLabel,8).centerYIs(self.centerY).heightIs(20).widthIs(200);
    _tagLabel.sd_layout.leftSpaceToView(_nameLabel,8).centerYIs(self.centerY).heightIs(10).widthIs(200);
}
-(void)setModel:(SchooBusModel *)model
{
    _model = model;
    
    _numLabel.text = model.num;
    _nameLabel.text = model.siteName;
   
    CGSize size=[_numLabel boundingRectWithSize:CGSizeMake(0, 10)];
    _numLabel.sd_layout.widthIs(size.width);
    size = [_nameLabel boundingRectWithSize:CGSizeMake(0, 20)];
    _nameLabel.sd_layout.widthIs(size.width);
    
}

-(void)setLocationModel:(SchooBusModel *)locationModel
{
    _locationModel = locationModel;
//    NSString *tag = [NSString stringWithFormat:@"%@",locationModel.isShow];
//    if ([tag isEqualToString:@"0"]) {
//        _tagLabel.textColor = Color_Gray ;
//        _nameLabel.textColor = _tagLabel.textColor;
//        _tagLabel.text = @"0辆车即将到达";
//        CGSize  size = [_tagLabel boundingRectWithSize:CGSizeMake(0, 10)];
//        _tagLabel.sd_layout.widthIs(size.width);
//
//    }else{
//        if ([self.model.num isEqualToString:self.locationModel.num]) {
//            _tagLabel.textColor = Base_Orange ;
//            _nameLabel.textColor = _tagLabel.textColor;
//        }
//        NSString *timeStr = [NSString stringWithFormat:@"%@",_locationModel.disnexttim];
//        int  time =[timeStr intValue];
//        _tagLabel.text = [NSString stringWithFormat:@"下班车预计%d分钟到达",time];
//        CGSize  size = [_tagLabel boundingRectWithSize:CGSizeMake(0, 10)];
//        _tagLabel.sd_layout.widthIs(size.width);
//
//}
    
    if ([self.model.num isEqualToString:self.locationModel.num]) {
        _tagLabel.textColor = Base_Orange ;
        _nameLabel.textColor = _tagLabel.textColor;
        NSString *tag = [NSString stringWithFormat:@"%@",locationModel.isShow];
        if ([tag isEqualToString:@"0"]) {
            _tagLabel.textColor = Color_Gray ;
            _nameLabel.textColor = Color_Black;
            _tagLabel.text = [NSString stringWithFormat:@"%@",locationModel.trip];
        }else{
            NSString *timeStr = [NSString stringWithFormat:@"%@",_locationModel.disnexttim];
            int  time =[timeStr intValue];
            _tagLabel.text = [NSString stringWithFormat:@"下班车预计%d分钟到达",time];
            if ([timeStr intValue]==0||[self includeChinese:timeStr]) {
                _tagLabel.text = [NSString stringWithFormat:@"%@",_locationModel.trip];
            }
        }
        CGSize  size = [_tagLabel boundingRectWithSize:CGSizeMake(0, 10)];
        _tagLabel.sd_layout.widthIs(size.width);

    }else{
        _tagLabel.textColor = Color_Gray ;
        _nameLabel.textColor = Color_Black;
        _tagLabel.text = @"0辆车即将到达";
        CGSize  size = [_tagLabel boundingRectWithSize:CGSizeMake(0, 10)];
        _tagLabel.sd_layout.widthIs(size.width);

    }
}
- (BOOL)includeChinese:(NSString *)varString
{
    for(int i=0; i< [varString length];i++)
    {
        int a =[varString characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
