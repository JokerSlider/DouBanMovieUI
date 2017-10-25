//
//  DHListCell.m
//  CSchool
//
//  Created by mac on 17/9/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "DHListCell.h"
#import "UIView+SDAutoLayout.h"

@implementation DHListCell
{
    UIImageView *_numImage;//排行图
    
    UILabel *_dName;//餐厅名称
    
    UILabel *_totalNum;//消费总次数
    
    UILabel *_money;//消费金额
    
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
        UIImageView *view = [UIImageView new];
        view;
    });
    
    _dName = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });
    _totalNum = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Gray ;
        view.font = [UIFont systemFontOfSize:12.0f];
        view;
    });
    _money  =({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black ;
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });
    
    [self.contentView sd_addSubviews:@[_numImage ,_dName ,_totalNum,_money]];
    
    _numImage.sd_layout.leftSpaceToView(self.contentView,13).topSpaceToView(self.contentView,22).widthIs(27).heightIs(29);
    _dName.sd_layout.leftSpaceToView(_numImage,15).topSpaceToView(self.contentView,18).heightIs(15).widthIs(100);
    _totalNum.sd_layout.leftEqualToView(_dName).topSpaceToView(_dName,13).heightIs(12).widthIs(100);
    _money.sd_layout.rightSpaceToView(self.contentView,14 ).topSpaceToView(self.contentView,25).widthIs(120).heightIs(15);
    
    
    [self setupAutoHeightWithBottomView:_totalNum bottomMargin:17];
    
}
-(void)setModel:(DHListModel *)model
{
    _model = model;
    NSArray *imageArr  = @[@"flower1",@"flower2",@"flower3",@"flower4",@"flower5",@"flower6",@"flower7",@"flower8",@"flower9",@"flower10"];
    int index = [model.lisNum intValue];
    _numImage.image =[UIImage imageNamed:imageArr[index]];
    _dName.text   =  model.wname;
    _totalNum.text = [NSString stringWithFormat:@"消费次数: %@次",model.count];
//    if ([model.avgsum intValue]>9999) {
//        _money.text = [NSString stringWithFormat:@"战斗力值: %d",[model.avgsum intValue]/1000];
//    }else if([model.avgsum intValue]>99999){
//    _money.text = [NSString stringWithFormat:@"战斗力值: %d",[model.avgsum intValue]/10000];
//    }else if([model.avgsum intValue]<999){
//        _money.text = [NSString stringWithFormat:@"战斗力值: %d",[model.avgsum intValue]];
//    }
    _money.text = [NSString stringWithFormat:@"战斗力值: %d",[model.avgsum intValue]/1000];
    
    
    CGSize size = [_dName boundingRectWithSize:CGSizeMake(0, 29)];
    _dName.sd_layout.widthIs(size.width);
    
    size =  [_totalNum boundingRectWithSize:CGSizeMake(0, 15)];
    _totalNum.sd_layout.widthIs(size.width);
    
    size = [_money boundingRectWithSize:CGSizeMake(0, 15)];
    _money.sd_layout.widthIs(size.width);
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
//model
@implementation DHListModel



@end

