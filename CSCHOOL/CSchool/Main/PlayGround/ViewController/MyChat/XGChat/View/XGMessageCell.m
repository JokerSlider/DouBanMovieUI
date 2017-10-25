//
//  XGMessageCell.m
//  XMPPDemo
//
//  Created by 左俊鑫 on 17/2/7.
//  Copyright © 2017年 Xin the Great. All rights reserved.
//

#import "XGMessageCell.h"
#import "SDAutoLayout.h"
#import "YYText.h"
#import "XGMessageModel.h"
#import "XMNChatTextParser.h"
#import "YYImage.h"
#import "DDEmotionView.h"
#import "XGExpressionManager.h"
#import "ChatUserInfoViewController.h"
#import "UIView+UIViewController.h"
#import "NSDate+CH.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YYWebImage.h"
#define kLabelMargin 20.f
#define kLabelTopMargin 8.f
#define kLabelBottomMargin 20.f

#define kChatCellItemMargin 10.f

#define kChatCellIconImageViewWH 35.f

#define kMaxContainerWidth 220.f
#define kMaxLabelWidth (kMaxContainerWidth - kLabelMargin * 2)

#define kMaxChatImageViewWidth 200.f
#define kMaxChatImageViewHeight 300.f
#define SCREEN_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

#define kXMNMessageViewMaxWidth (SCREEN_WIDTH - 45 - 32 - 16 - 20 - 32)

@interface XGMessageCell()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *containerBackgroundImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *maskImageView;

@property (nonatomic, strong) YYLabel *yyLabel;

@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation XGMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    

    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:11];
        view.textColor = [UIColor lightGrayColor];
        view;
    });
    [self.contentView addSubview:_timeLabel];
    
    
    
    _iconImageView = [UIImageView new];
    _iconImageView.image = [UIImage imageNamed:@"defaultHead"];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
    [_iconImageView addGestureRecognizer:iconTap];
    
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:10];
        view.textColor = Color_Gray;
        view;
    });
    [self.contentView addSubview:_nameLabel];
    
    _yyLabel = [YYLabel new];
    _yyLabel.numberOfLines = 0;
    _yyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _yyLabel.displaysAsynchronously = YES;
//    _yyLabel.textAlignment = NSTextAlignmentLeft;
    _yyLabel.font = [UIFont systemFontOfSize:16.f];
    
    //设置textView 解析表情
    XMNChatTextParser *parser = [[XMNChatTextParser alloc] init];
    parser.emoticonMapper = [XGExpressionManager sharedManager].nomarImageMapper;
    parser.emotionSize = CGSizeMake(18.f, 18.f);
    parser.alignFont = [UIFont systemFontOfSize:16.f];
    parser.alignment = YYTextVerticalAlignmentBottom;
    _yyLabel.textParser = parser;
    
    [_container addSubview:_yyLabel];
    
    
    _messageImageView = [UIImageView new];
    _messageImageView.userInteractionEnabled = YES;
    [_container addSubview:_messageImageView];
    
    _containerBackgroundImageView = [UIImageView new];
    [_container insertSubview:_containerBackgroundImageView atIndex:0];
    
    _maskImageView = [UIImageView new];
    
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    // 设置containerBackgroundImageView填充父view
    _containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    _timeLabel.sd_layout.centerXIs(kScreenWidth/2).topSpaceToView(self.contentView,3).widthIs(100).heightIs(14);

}

- (void)iconClick:(UITapGestureRecognizer *)sender{
    if (_model.isMySend) {
        //进入个人详情
        NSLog(@"%@",_model.jid);
        
        
    }else{
        ChatUserInfoViewController  *vc =[[ChatUserInfoViewController alloc]init];
         vc.jid  = _model.jid;///jid chucup
        vc.groupName = _model.groupName;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }

}
- (void)setModel:(XGMessageModel *)model{
    _model = model;
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd HH:mm:ss";

    fmt.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *creatDate=model.chatTime;
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
            _timeLabel.text = [fmt stringFromDate:creatDate];
            
        }else if(creatDate.isYesterday){//昨天发的
            fmt.dateFormat=@"昨天 HH:mm";
            _timeLabel.text = [fmt stringFromDate:creatDate];
        }else{//至少是前天发布的
            fmt.dateFormat=@"yyyy-MM-dd HH:mm";
            _timeLabel.text = [fmt stringFromDate:creatDate];
        }
    }else           //  往年
    {
        fmt.dateFormat=@"yyyy-MM-dd";
        _timeLabel.text = [fmt stringFromDate:creatDate];
    }

    
    CGSize size = [_timeLabel boundingRectWithSize:CGSizeMake(0, 14)];
    _timeLabel.sd_layout.widthIs(size.width+4);

    self.iconImageView.image = model.headerImage==nil?[UIImage imageNamed:@"defaultHead"]:model.headerImage;

    //只有群聊的时候才设置昵称
    if (model.isGrouoChat) {
        if (model.isMySend) {
            _nameLabel.text = @"我";
        }else{
            _nameLabel.text = model.name;
        }
    }
    if ([_nameLabel.text length] < 1) {
        NSLog(@"11");
    }
    [self setMessageOriginWithModel:model];

    switch (model.messageType) {
        case XGMsgTypeImage:{
            // cell重用时候清除只有文字的情况下设置的container宽度自适应约束
            [self.container clearAutoWidthSettings];
            self.messageImageView.hidden = NO;
            //  发送URL图片的方式
            [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:model.imageBody] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
            
            // 根据图片的宽高尺寸设置图片约束
            CGFloat standardWidthHeightRatio = kMaxChatImageViewWidth / kMaxChatImageViewHeight;
            CGFloat widthHeightRatio = 0;
            UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageBody]]];
             
            CGFloat h = image.size.height;
            CGFloat w = image.size.width;
            
            if (w > kMaxChatImageViewWidth || w > kMaxChatImageViewHeight) {
                
                widthHeightRatio = w / h;
                
                if (widthHeightRatio > standardWidthHeightRatio) {
                    w = kMaxChatImageViewWidth;
                    h = w * (image.size.height / image.size.width);
                } else {
                    h = kMaxChatImageViewHeight;
                    w = h * widthHeightRatio;
                }
            }
            
            self.messageImageView.size = CGSizeMake(w, h);
            _container.sd_layout.widthIs(w).heightIs(h);
            
            // 设置container以messageImageView为bottomView高度自适应
            [_container setupAutoHeightWithBottomView:self.messageImageView bottomMargin:kChatCellItemMargin];
            
            // container按照maskImageView裁剪
            self.container.layer.mask = self.maskImageView.layer;
            
            __weak typeof(self) weakself = self;
            [_containerBackgroundImageView setDidFinishAutoLayoutBlock:^(CGRect frame) {
                // 在_containerBackgroundImageView的frame确定之后设置maskImageView的size等于containerBackgroundImageView的size
                weakself.maskImageView.size = frame.size;
            }];
            
        }
            break;
        case XGMsgTypeText:
        {
            
            // 清除展示图片时候用到的mask
            [_container.layer.mask removeFromSuperlayer];
            
            self.messageImageView.hidden = YES;
            
            // 清除展示图片时候_containerBackgroundImageView用到的didFinishAutoLayoutBlock
            _containerBackgroundImageView.didFinishAutoLayoutBlock = nil;
            
            CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
            CGFloat AllMargin = 31;

            CGFloat headW  = 40;
            CGFloat margin = 10;
            
            CGSize maxsize = CGSizeMake(screenW - (margin * 4 + headW * 2) - AllMargin, MAXFLOAT);
            
            // 创建文本容器
            YYTextContainer *container = [YYTextContainer new];
            container.size = maxsize;
            container.maximumNumberOfRows = 0;
            container.linePositionModifier = _yyLabel.linePositionModifier;

            // 生成排版结果
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:model.text];
            [_yyLabel.textParser parseText:one
                                   selectedRange:NULL];
            
            one.yy_font = _yyLabel.font;
            YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:one];
            
            
            _yyLabel.sd_resetLayout
            .leftSpaceToView(_container, kLabelMargin)
            .topSpaceToView(_container, kLabelTopMargin)
            .widthIs(layout.textBoundingSize.width)
            .heightIs(layout.textBoundingSize.height);
            
            // container以label为rightView宽度自适应
            [_container setupAutoWidthWithRightView:_yyLabel rightMargin:kLabelMargin];
            
            // container以label为bottomView高度自适应
            [_container setupAutoHeightWithBottomView:_yyLabel bottomMargin:kLabelBottomMargin];

            _yyLabel.text = model.text;
            
        }
            break;
        
        default:
            break;
    }
}

- (NSDictionary *)getExpressionDic{
    NSString *plistPath = [self filePath:DDEmotionPlistName];
    NSArray *qqEmotions = [NSArray arrayWithContentsOfFile:plistPath];
    //    NSArray *qqEmotions =  [NSArray arrayWithContentsOfFile:[self.qqBundle pathForResource:@"info" ofType:@"plist"]];
    NSMutableDictionary *mapper = [NSMutableDictionary dictionary];
//    NSMutableDictionary *gifMapper = [NSMutableDictionary dictionary];
//    __weak typeof(*&self) wSelf = self;
    [qqEmotions enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        __strong typeof(*&wSelf) self = wSelf;
        mapper[obj.allKeys[0]] = [YYImage imageNamed:[NSString stringWithFormat:@"%@.gif",obj.allValues[0]]];
        /** 添加如果GIF表情不存在 使用PNG表情 */
        //        gifMapper[obj.allKeys[0]] = [YYImage imageWithContentsOfFile:[self.qqBundle pathForResource:[obj.allValues[0] stringByAppendingString:@"@2x"] ofType:@"gif"]] ? : mapper[obj.allKeys[0]];
    }];
    
    return  [mapper copy];
}


- (NSString *)filePath:(NSString *)fileName {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",DDEmotionBundlePath,fileName];
    return path;
}

- (void)setMessageOriginWithModel:(XGMessageModel *)model
{
    if (model.isMySend) {
        // 发出去的消息设置居右样式
        self.iconImageView.sd_resetLayout
        .rightSpaceToView(self.contentView, kChatCellItemMargin)
        .topSpaceToView(self.contentView, kChatCellItemMargin)
        .widthIs(kChatCellIconImageViewWH)
        .heightIs(kChatCellIconImageViewWH);
        
        _container.sd_resetLayout.topSpaceToView(self.contentView, kChatCellItemMargin+10).rightSpaceToView(self.iconImageView, kChatCellItemMargin);
        
        _containerBackgroundImageView.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        
        _nameLabel.sd_resetLayout.topEqualToView(self.iconImageView).rightSpaceToView(self.iconImageView,20).widthIs(100).heightIs(8);
        _nameLabel.textAlignment = NSTextAlignmentRight;

    } else{
        
        // 收到的消息设置居左样式
        self.iconImageView.sd_resetLayout
        .leftSpaceToView(self.contentView, kChatCellItemMargin)
        .topSpaceToView(self.contentView, kChatCellItemMargin)
        .widthIs(kChatCellIconImageViewWH)
        .heightIs(kChatCellIconImageViewWH);
        
        _container.sd_resetLayout.topSpaceToView(self.contentView, kChatCellItemMargin+10).leftSpaceToView(self.iconImageView, kChatCellItemMargin);
        
        _containerBackgroundImageView.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        
        _nameLabel.sd_resetLayout.topEqualToView(_iconImageView).leftSpaceToView(_iconImageView,20).widthIs(100).heightIs(8);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    _maskImageView.image = _containerBackgroundImageView.image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
