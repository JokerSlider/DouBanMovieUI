//
//  PackageInfoCell.m
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PackageInfoCell.h"
#import "UIView+SDAutoLayout.h"
@implementation PackageInfoCell
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
-(void)MakeView
{
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
        view.textColor = Color_Black;
        view;
    });
   
    _packageName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
        view.textColor = Color_Black;
        view;
    });
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_packageName];
    _nameLabel.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,20).widthIs(80).heightIs(20);
    _packageName.sd_layout.leftSpaceToView(self.nameLabel,0).topEqualToView(_nameLabel).rightSpaceToView(self.contentView,0).autoHeightRatio(0);
    
}
-(void)setModel:(PackageModel *)model
{
    _model = model;
}
@end
