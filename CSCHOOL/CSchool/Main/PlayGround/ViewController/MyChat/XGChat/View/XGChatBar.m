//
//  XGChatBar.m
//  XMPPDemo
//
//  Created by 左俊鑫 on 17/2/7.
//  Copyright © 2017年 Xin the Great. All rights reserved.
//

#import "XGChatBar.h"
#import "SDAutoLayout.h"
#import "XGChatExpressionView.h"
#import "XMNChatTextParser.h"
#import "YYImage.h"

/** 定义view的通用背景色 */
#define XMNVIEW_BACKGROUND_COLOR [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f]

/** 定义view的border.color */
#define XMNVIEW_BORDER_COLOR [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0f]

@interface XGChatBar()

@property (nonatomic, retain) UIButton *faceButton;

//@property (nonatomic, retain) UIButton *moreButton;

@property (nonatomic, retain) UIButton *cameraButton;

@property (nonatomic, retain) UIButton *photoButton;

@property (nonatomic, retain) UIView *bottomView;

@end

@implementation XGChatBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        _normalHeight = 100;
        [self setup];
    }
    return self;
}

- (void)setup{
    self.layer.borderColor = XMNVIEW_BORDER_COLOR.CGColor;
    self.layer.borderWidth = 1.0f;
    self.backgroundColor = XMNVIEW_BACKGROUND_COLOR;

    self.bottomView = ({
        UIView *view = [UIView new];
        view.backgroundColor = XMNVIEW_BACKGROUND_COLOR;
        view;
    });
    
    [self addSubview:self.bottomView];
    
    self.faceButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"faceBtn.png"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"faceBtnH.png"] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(chartBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view.tag = XGChatBarExpression;
        view;
    });
    
    self.cameraButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"ph"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"pho"] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(chartBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view.tag = XGChatBarCamera;
        view;
    });
    
    self.photoButton =  ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"pic2"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(chartBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view.tag = XGChatBarPhoto;
        view;
    });
    
    [self.bottomView sd_addSubviews:@[self.faceButton, self.cameraButton, self.photoButton]];
    
    self.textView = [[YYTextView alloc] init];
//    self.textView.layer.borderColor = XMNVIEW_BORDER_COLOR.CGColor;
//    self.textView.layer.borderWidth = 1.0f;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 4.0f;
    //设置textView 固定行高
    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
    mod.fixedLineHeight = 20.f;
    self.textView.linePositionModifier = mod;
    
    //设置textView 解析表情
    XMNChatTextParser *parser = [[XMNChatTextParser alloc] init];
    parser.emoticonMapper = [self getExpressionDic];
    parser.emotionSize = CGSizeMake(18.f, 18.f);
    parser.alignFont = [UIFont systemFontOfSize:16.f];
    parser.alignment = YYTextVerticalAlignmentBottom;
    self.textView.textParser = parser;
    
    self.textView.font = [UIFont systemFontOfSize:16.f];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
    self.textView.textContainerInset =  UIEdgeInsetsMake( 4, 4, 4, 4);
    [self addSubview:self.textView];
    
    _textView.sd_layout
    .leftSpaceToView(self,10)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,56)
    .rightSpaceToView(self,10);
    
    self.bottomView.sd_layout
    .leftSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(50);
    
    self.faceButton.sd_layout
    .leftSpaceToView(self.bottomView,48)
    .centerYEqualToView(self.bottomView)
    .widthIs(31)
    .heightIs(31);
    
    self.cameraButton.sd_layout
    .centerYEqualToView(self.bottomView)
    .centerXEqualToView(self.bottomView)
    .widthIs(31)
    .heightIs(31);
    
    self.photoButton.sd_layout
    .rightSpaceToView(self.bottomView,48)
    .centerYEqualToView(self.bottomView)
    .widthIs(31)
    .heightIs(31);
    
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
        mapper[obj.allKeys[0]] = [YYImage imageNamed:obj.allValues[0]];
        /** 添加如果GIF表情不存在 使用PNG表情 */
//        gifMapper[obj.allKeys[0]] = [YYImage imageWithContentsOfFile:[self.qqBundle pathForResource:[obj.allValues[0] stringByAppendingString:@"@2x"] ofType:@"gif"]] ? : mapper[obj.allKeys[0]];
    }];
    
    return  [mapper copy];
}

- (void)chartBarButtonClick:(UIButton *)sender{
    if (_chatBarButtonClick) {
        _chatBarButtonClick(sender.tag);
    }
}

- (NSString *)filePath:(NSString *)fileName {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",DDEmotionBundlePath,fileName];
    return path;
}


@end
