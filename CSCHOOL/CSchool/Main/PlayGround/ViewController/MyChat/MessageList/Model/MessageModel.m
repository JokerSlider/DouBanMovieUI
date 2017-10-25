//
//  MessageModel.m
//  微信
//
//  Created by Think_lion on 15/6/20.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "MessageModel.h"
#import "RegexKitLite.h"
#import "HMRegexResult.h"
#import "HMEmotionAttachment.h"
#import "HMEmotionTool.h"

@implementation MessageModel


-(void)setBody:(NSString *)body
{
    _body=[body copy];
    
    [self createAttributedText];

}

- (NSArray *)regexResultsWithText:(NSString *)text
{
    // 用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];
    
    // 匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HMRegexResult *rr = [[HMRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = YES;
        [regexResults addObject:rr];
    }];
    
    // 匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HMRegexResult *rr = [[HMRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = NO;
        [regexResults addObject:rr];
    }];
    
    // 排序
    [regexResults sortUsingComparator:^NSComparisonResult(HMRegexResult *rr1, HMRegexResult *rr2) {
        int loc1 = (int)rr1.range.location;
        int loc2 = (int)rr2.range.location;
        return [@(loc1) compare:@(loc2)];
    }];
    return regexResults;
}


- (void)createAttributedText
{
    if (self.body == nil) return;
    
 
    self.attributedBody = [self attributedStringWithText:self.body];
    
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultsWithText:text];
    
    // 2.根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(HMRegexResult *result, NSUInteger idx, BOOL *stop) {
        HMEmotion *emotion = nil;
        if (result.isEmotion) { // 表情
            emotion = [HMEmotionTool emotionWithDesc:result.string];
        }
        
        if (emotion) { // 如果有表情
            // 创建附件对象
            HMEmotionAttachment *attach = [[HMEmotionAttachment alloc] init];
            
            // 传递表情
            attach.emotion = emotion;
            attach.bounds = CGRectMake(0, -3,[UIFont systemFontOfSize:16.0].lineHeight,[UIFont systemFontOfSize:16.0].lineHeight);
            
            // 将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString appendAttributedString:attachString];
        } else { // 非表情（直接拼接普通文本）
            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
            
 
            
              
            [attributedString appendAttributedString:substr];
        }
    }];
    
    // 设置字体
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}





@end
