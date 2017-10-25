//
//  PayPackageCell.m
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PayPackageCell.h"
#import "UIView+SDAutoLayout.h"
@implementation PayPackageCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self MakeView];
    }
    return self;
}

-(void)MakeView{
    _PayImageV = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    _title = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:16];
        view;
    });
    _SelectIconBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"unchose"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"chose"] forState:UIControlStateSelected];
        view.userInteractionEnabled = NO;
        view;
    });
    [self.contentView addSubview:_PayImageV];
    [self.contentView addSubview:_title];
    [self.contentView addSubview:_SelectIconBtn];
    _PayImageV.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,17).widthIs(25).heightIs(25);
    _title.sd_layout.leftSpaceToView(_PayImageV,55).topSpaceToView(self.contentView,20).widthIs(100).heightIs(20);
    _SelectIconBtn.sd_layout.rightSpaceToView(self.contentView,10).topEqualToView(_PayImageV).widthIs(20).heightIs(20);
    
}
-(void)UpdateCellWithState:(BOOL)select{
    self.SelectIconBtn.selected = select;
    _isSelected = select;
}


@end
