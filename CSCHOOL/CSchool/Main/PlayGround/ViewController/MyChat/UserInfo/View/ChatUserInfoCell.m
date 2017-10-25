//
//  ChatUserInfoCell.m
//  CSchool
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ChatUserInfoCell.h"
#import "UIView+SDAutoLayout.h"
#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "ZoomImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface      ChatUserInfoCell()
@property (nonatomic,strong) UILabel *userNickName;//备注名
@property (nonatomic,strong) UIImageView *picImage;
@property (nonatomic,strong)UILabel   *userName;
@property (nonatomic,strong)UILabel   *userSex;
@end
@implementation ChatUserInfoCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    _picImage   = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"defaultHead"];
        view.layer.cornerRadius = 3;
        view.clipsToBounds = YES;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openHilightImage:)];
        gester.numberOfTapsRequired= 1;
        [view addGestureRecognizer:gester];
        
        view;
    });
    _userName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(1, 1, 1);
        view;
    });
    _userSex = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(98, 98, 98);
        view;
    });
    _userNickName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(98, 98, 98);
        view;
    });
    [self.contentView sd_addSubviews:@[_picImage,_userNickName,_userSex,_userName]];
    UIView *contentView = self.contentView;
    _picImage.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView, 25).widthIs(60).heightIs(60);
    _userName.sd_layout.leftSpaceToView(_picImage,20).topSpaceToView(contentView,25).widthIs(200).heightIs(15);
    _userSex.sd_layout.leftEqualToView(_userName).topSpaceToView(_userName,10).widthIs(200).heightIs(12);
    _userNickName.sd_layout.leftEqualToView(_userName).topSpaceToView(_userSex,5).widthIs(200).heightIs(12);

}
-(void)setModel:(ChatModel *)model
{
    _model = model;
    
    [[HQXMPPManager shareXMPPManager].vCard fetchvCardTempForJID:model.userjid ignoreStorage:YES];
    
//    XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:model.userjid shouldFetch:YES];
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [model.picImageUrl stringByReplacingOccurrencesOfString:breakString withString:@""];
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"defaultHead"]];

//    self.picImage.image=friendvCard.photo.length!=0?[UIImage imageWithData:friendvCard.photo]:[UIImage imageNamed:@"defalt_head"];
    UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openHilightImage:)];
    gester.numberOfTapsRequired= 1;
    [self.picImage addGestureRecognizer:gester];
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:model.userjid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    self.userName .text  =model.userjid.user?model.userjid.user:user.displayName;
    self.userName .text  =[NSString stringWithFormat:@"%@(%@)",model.name,model.trueName];;
    if ([model.name isEqualToString:@"nil"]) {
        self.userName .text  =[NSString stringWithFormat:@"%@",model.trueName];
    }
    self.userSex.text = [NSString stringWithFormat:@"性别: %@",model.sex];//取本地接口

    self.userNickName.text =[NSString stringWithFormat:@"备注名: %@",![user isEqual:[NSNull null]]&&user.nickname != nil?user.nickname:@"无"];
    if (model.nickName.length!=0) {
        self.userNickName.text =[NSString stringWithFormat:@"备注名: %@", model.nickName];
    }
    //预加载放大的图片
    KGestureRecognizerType gRType=0;
    [[ZoomImageView getZoomImageView]showZoomImageView:self.picImage addGRType:gRType];
}
-(void)openHilightImage:(UITapGestureRecognizer *)sender
{
    KGestureRecognizerType gRType=0;
    [[ZoomImageView getZoomImageView]showZoomImageView:self.picImage addGRType:gRType];
}
#pragma mark 图片浏览代理

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
