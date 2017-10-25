//
//  MessageFrameModel.m
//  微信
//
//  Created by Think_lion on 15/6/21.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "MessageFrameModel.h"
#import "MessageModel.h"
//头像的宽度
#define headIconW 40
#define contentFont MyFont(15)
//聊天内容的文字距离四边的距离
#define ContentEdgeInsets 20

@implementation MessageFrameModel



//根据模型设置frame
-(void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel=messageModel;
    CGFloat padding =10;  //间距为10
    
    //1.设置时间的frame (不需要隐藏时间)
    if(messageModel.hiddenTime==NO){
        CGFloat timeX=0;
        CGFloat timeY=0;
        CGFloat timeW=kScreenWidth;
        CGFloat timeH=30;
        _timeF=CGRectMake(timeX, timeY, timeW, timeH);
    }
    //2.设置头像
    CGFloat iconW=headIconW;
    CGFloat iconH=iconW;
    CGFloat iconX=0;
    CGFloat iconY=CGRectGetMaxY(_timeF)+padding;
    //如果是自己
    if(messageModel.isCurrentUser){
        iconX=kScreenWidth-iconW-padding;
    }else{  //是正在和自己聊天的用户
         iconX=padding;
    }
    _headF=CGRectMake(iconX, iconY, iconW, iconH);
    //3.设置聊天内容的frame  (聊天内容的宽度最大100  高不限)
    CGSize contentSize=CGSizeMake(200, MAXFLOAT);
    CGRect contentR;
    //如果有表情的话
    
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:messageModel.attributedBody];
        contentR=[text boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    }else{
//        contentR=[messageModel.body boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentFont} context:nil];
//    }
   
  
    CGFloat contentW=contentR.size.width+ContentEdgeInsets*2;
    CGFloat contentH=contentR.size.height+ContentEdgeInsets*2;
    CGFloat contentY=iconY-2;
    CGFloat contentX=0;
    //如果是自己
    if(messageModel.isCurrentUser){
        contentX=iconX-padding-contentW;
    }else{  //如果是聊天用户
        contentX=CGRectGetMaxX(_headF)+padding;
    }
    _contentF=CGRectMake(contentX, contentY, contentW, contentH);
    //单元格的高度
    CGFloat maxIconY=CGRectGetMaxY(_headF);
    CGFloat maxContentY=CGRectGetMaxY(_contentF);
    
    _cellHeight=MAX(maxIconY, maxContentY)+padding;
    //4.聊天单元view的frame
    _chatF=CGRectMake(0, 0, kScreenWidth, _cellHeight);
}


@end
