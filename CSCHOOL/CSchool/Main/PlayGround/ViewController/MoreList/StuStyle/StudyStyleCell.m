//
//  StudyStyleCell.m
//  CSchool
//
//  Created by mac on 17/9/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "StudyStyleCell.h"
#import "UIView+SDAutoLayout.h"
@implementation StudyStyleModel


@end

@implementation StudyStyleCell
{
    UILabel *_name;//班级名称
    UILabel *_number;//班级号
    UILabel *_point;//积分
    UIButton *_numImage;//排行图
    
    UIImageView *_fistView;

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        self.backgroundColor = Base_Color2;
    }
    return self;
}
-(void)createView
{
    _numImage = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom ];
        view.titleLabel.font = [UIFont systemFontOfSize:18];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        view;
    });
    _fistView=({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"ganjun"];
        view;
    });
    _name = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });

    _number = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Gray;
        view.font = [UIFont systemFontOfSize:11.0f];
        view;
    });
    
    _point = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black ;
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });
    [self.contentView sd_addSubviews:@[_name,_number,_numImage,_point,_fistView]];
    _numImage.sd_layout.leftSpaceToView(self.contentView,13).topSpaceToView(self.contentView,22).widthIs(27).heightIs(29);
    _name.sd_layout.leftSpaceToView(_numImage,15).topSpaceToView(self.contentView,22+7).heightIs(15).widthIs(100);
    _number.sd_layout.leftSpaceToView(_name,2).topSpaceToView(self.contentView,22+10).heightIs(12).widthIs(100);
    _point.sd_layout.rightSpaceToView(self.contentView,15 ).topSpaceToView(self.contentView,25).widthIs(120).heightIs(15);
    
    _fistView.sd_layout.leftSpaceToView(_number,30).topSpaceToView(self.contentView,22+7).widthIs(15).heightIs(15);
    [self setupAutoHeightWithBottomView:_number bottomMargin:18];
}
-(void)setModel:(StudyStyleModel *)model
{
    _model = model;
    _name.text = model.bjm;
    _number.text =[NSString stringWithFormat:@"(%@)",model.bjh];
    int index = [model.pm intValue];
    NSArray *images = @[@"stuS1",@"stuS2",@"stuS3"];
    NSArray *imageArr  = @[@"flower1",@"flower2",@"flower3",@"flower4",@"flower5",@"flower6",@"flower7",@"flower8",@"flower9",@"flower10"];
    if (index!=1) {
        _fistView.hidden = YES;
    }
    if (index<4) {
        [_numImage setImage:[UIImage imageNamed:images[index-1]] forState:UIControlStateNormal];// =[UIImage imageNamed:imageArr[index-1]];
    }else{
        [_numImage setTitle:model.pm forState:UIControlStateNormal];
    }
    
    
    _point.text =[NSString stringWithFormat:@"积分:%@",model.jf];
    
    CGSize  size  = [_name boundingRectWithSize:CGSizeMake(0, 15)];
    _name.sd_layout.widthIs(size.width);
    size = [_number boundingRectWithSize:CGSizeMake(0, 12)];
    _number.sd_layout.widthIs(size.width);
    size = [_point boundingRectWithSize:CGSizeMake(0, 15)];
    _point.sd_layout.widthIs(size.width);

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
