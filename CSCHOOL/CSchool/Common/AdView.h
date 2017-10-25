//
//  AdView.h
//  CSchool
//
//  Created by 左俊鑫 on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 AdView样式

 - AdViewImage: 图片
 */
typedef NS_ENUM(NSUInteger, AdViewStyle) {
    AdViewImage
};

@interface AdModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *jump_url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *photo_url;

@end

@interface AdView : UIView

@property (nonatomic, retain) AdModel *model;

/**
 初始化

 @param frame
 @param adViewStyle 样式
 @param source 来源，1：缴费
 @return
 */
-(instancetype)initWithFrame:(CGRect)frame withStyle:(AdViewStyle)adViewStyle withSource:(NSString *)source;


@end
