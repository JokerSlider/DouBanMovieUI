//
//  ChatLisCell.m
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ChatLisCell.h"
#import "UIView+SDAutoLayout.h"
#import "LY_CircleButton.h"
#import "ChatModel.h"
#import "HomeModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "NSDate+CH.h"
#import "YYText.h"
#import "XMNChatTextParser.h"
#import "XGExpressionManager.h"
#import "HQXMPPChatRoomManager.h"
@implementation ChatLisCell
{
    UIImageView *_picImage;//头像
    YYLabel *_messLabel;//最新的一条消息
    UILabel *_timeLabel;//时间
    LY_CircleButton *_badgeValue;//角标
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    _picImage  = ({
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 3;
        view.clipsToBounds = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPersonInfo)];
        tapGesture.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tapGesture];
        view;
    });
    _userNickName = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(1, 1, 1);
        view.font = [UIFont systemFontOfSize:15];
        view;
    });
    _messLabel = ({
        YYLabel *view = [YYLabel new];
        view.numberOfLines = 0;
        view.lineBreakMode = NSLineBreakByWordWrapping;
        view.displaysAsynchronously = YES;
        view.font = [UIFont systemFontOfSize:16.f];
        view.textColor = RGB(98, 98, 98);
        view.font = [UIFont systemFontOfSize:12];
        view.lineBreakMode = NSLineBreakByTruncatingTail;
        view;
    });
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(98, 98, 98);
        view.font = [UIFont systemFontOfSize:12];
        view;
    });
    //设置textView 解析表情
    XMNChatTextParser *parser = [[XMNChatTextParser alloc] init];
    parser.emoticonMapper = [XGExpressionManager sharedManager].nomarImageMapper;
    parser.emotionSize = CGSizeMake(18.f, 18.f);
    parser.alignFont = [UIFont systemFontOfSize:16.f];
    parser.alignment = YYTextVerticalAlignmentBottom;
    _messLabel.textParser = parser;

    WEAKSELF;
    _badgeValue = [[LY_CircleButton alloc]initWithFrame:CGRectMake(kScreenWidth-35, 34, 17, 17)];
    _badgeValue.maxDistance = 30;
    [_badgeValue setBackgroundColor:[UIColor redColor]];
    _badgeValue.imageView.layer.cornerRadius = _badgeValue.bounds.size.width/2;
    [_badgeValue setBackgroundImage:[UIImage imageNamed:@"bageValue"] forState:UIControlStateNormal];
    _badgeValue.titleLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(11.0)];
    [_badgeValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    _badgeValue.layer.cornerRadius = _badgeValue.bounds.size.width*0.5;
    _badgeValue.layer.masksToBounds = YES;
    [_badgeValue addButtonAction:^(id sender) {
        [weakSelf MessgaeCell:weakSelf];
    }];

    [self.contentView sd_addSubviews:@[_picImage,_userNickName,_messLabel,_timeLabel]];
    UIView *contentView = self.contentView;
    [self.contentView addSubview:_badgeValue];
    _picImage.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,15).widthIs(40).heightIs(40);
    _userNickName.sd_layout.leftSpaceToView(_picImage,20).topEqualToView(_picImage).heightIs(17).widthIs(200);
    _messLabel.sd_layout.leftEqualToView(_userNickName).topSpaceToView(_userNickName,10).widthIs(kScreenWidth-150).heightIs(20);
    _timeLabel.sd_layout.rightSpaceToView(contentView,20).topEqualToView(_picImage).heightIs(9).widthIs(40);
    [self setupAutoHeightWithBottomView:_picImage bottomMargin:15];
}

-(void)setModel:(HomeModel *)model
{
    _model = model;
    _messLabel.text = model.body;
    _timeLabel.text = [self setMyTime:model.time];
    XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:model.jid shouldFetch:YES];
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:model.jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    if (!user) {
        NSString *jidStr = model.jid.user;
        XMPPJID *newJId =[XMPPJID jidWithString:jidStr];
        user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:newJId xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    }
    //更换昵称 --   走本地接口
    if ([model.messageType isEqualToString:@"chat"]) {
        
        if (friendvCard.nickname.length!=0) {
            if (user.nickname) {
                if ([user.nickname containsString:kDOMAIN]) {
                    user.nickname = [[model.jid.user componentsSeparatedByString:@"_"]lastObject];
                }
                _userNickName.text= [NSString stringWithFormat:@"%@(%@)",user.nickname,friendvCard.nickname];
            }else{
               _userNickName.text= [NSString stringWithFormat:@"%@",friendvCard.nickname];
            }

        }else if(user.nickname){
            _userNickName.text = user.nickname;
            if ([user.nickname containsString:kDOMAIN]) {
                _userNickName.text = [[model.jid.user componentsSeparatedByString:@"_"]lastObject];
            }
        }else{
            _userNickName.text = [[model.jid.user componentsSeparatedByString:@"_"]lastObject];
        }
        
    }else if([model.messageType isEqualToString:@"groupchat"]) {
        //房间名称
        NSString *friendJIdStr =[NSString stringWithFormat:@"%@" ,model.jid];
        NSArray *friendArr = [friendJIdStr componentsSeparatedByString:@"/"];
        XMPPJID   *groupusrJid   =[XMPPJID jidWithUser:[friendArr lastObject] domain:kDOMAIN resource:nil];
        
        user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:groupusrJid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
        _messLabel.text =[NSString stringWithFormat:@"%@:%@",user.nickname,model.body];
        if ([groupusrJid.user isEqualToString:model.myJid.user]) {
            _messLabel.text =[NSString stringWithFormat:@"我:%@",model.body];
        }
        NSArray *roomArray =  [HQXMPPChatRoomManager shareChatRoomManager].roomList;
        for ( XMPPElement *element in roomArray) {
            NSString *jidString =element.attributesAsDictionary[@"jid"];
            XMPPJID *roomJid = [XMPPJID jidWithString:jidString];
            if ([roomJid.user isEqualToString:model.jid.user]) {
                _userNickName.text =[NSString stringWithFormat:@"%@",element.attributesAsDictionary[@"name"]];
            }
        }
    }
    //发送图片出错  *  或者是消息
    else if([model.messageType isEqualToString:@"system"]){
        _userNickName.text = [[model.uname componentsSeparatedByString:@"+"]lastObject];//用户名
    }else{
        _userNickName.text = [[model.jid.user componentsSeparatedByString:@"_"]lastObject];//用户名
        if (user.nickname) {
            _userNickName.text = user.nickname;
            if ([user.nickname containsString:kDOMAIN]) {
                _userNickName.text = [[model.jid.user componentsSeparatedByString:@"_"] lastObject];//用户名
            }
        }
    }
    //更换头像  --   走本地接口
    _picImage.image=friendvCard.photo.length!=0?[UIImage imageWithData:friendvCard.photo]:[UIImage imageNamed:@"defaultHead"];
    if ([model.messageType isEqualToString:@"system"]) {
        _picImage.image = [UIImage imageNamed:@"systemmes"];
    }
    [_badgeValue setTitle:model.badgeValue forState:UIControlStateNormal];
    CGSize size = [_timeLabel boundingRectWithSize:CGSizeMake(0, 9)];
    _timeLabel.sd_layout.widthIs(size.width);
    if(model.badgeValue.length>0 && ![model.badgeValue isEqual:[NSNull null]]){
        _badgeValue.frame = CGRectMake(kScreenWidth-35, 34, 17, 17);
        for (UIView *view in self.contentView.subviews) {
            if (![view isKindOfClass:[LY_CircleButton class]]) {
                [self.contentView addSubview:_badgeValue];
            }
        }
        
    if ([model.badgeValue intValue]>99) {
//            self.layer.cornerRadius = self.bounds.size.width*0.3;
            _badgeValue.frame = CGRectMake(kScreenWidth-50, 34, 31, 18);
            [_badgeValue setBackgroundImage:[UIImage imageNamed:@"moreBageValue"] forState:UIControlStateNormal];
            [_badgeValue setTitle:@"99+" forState:UIControlStateNormal];
        }
    }else{
        [_badgeValue removeFromSuperview];
    }
}

//设置时间
-(NSString *)setMyTime:(NSString *)originTime
{
    
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    fmt.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *creatDate=[fmt dateFromString:originTime];
    
    //判断是否为今年
    if (creatDate.isThisYear) {//今年
        if (creatDate.isToday) {

            NSString *dayTime ;
            if ([NSDate isBetweenFromHour:0 toHour:12 WithCurrentData:creatDate]) {
                dayTime = @"上午";
            }else{
                dayTime = @"下午";
            }
            fmt.dateFormat =[NSString stringWithFormat:@"%@ HH:mm",dayTime];
            return [fmt stringFromDate:creatDate];
            
        }else if(creatDate.isYesterday){//昨天发的
            fmt.dateFormat=@"昨天 HH:mm";
            return [fmt stringFromDate:creatDate];
        }else{//至少是前天发布的
            fmt.dateFormat=@"yyyy-MM-dd HH:mm";
            return [fmt stringFromDate:creatDate];
        }
    }else           //  往年
    {
        fmt.dateFormat=@"yyyy-MM-dd";
        return [fmt stringFromDate:creatDate];
    }
    
}
#pragma mark
-(void)MessgaeCell:(ChatLisCell *)cell
{
    if (self.delegate&&[self respondsToSelector:@selector(MessgaeCell:)]) {
        [self.delegate MessgaeCell:cell];
    }
}
#pragma mark 点击头像跳转到个人信息详情
-(void)openPersonInfo
{
    
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
