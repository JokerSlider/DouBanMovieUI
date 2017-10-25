//
//  YunLogoImageHelper.h
//  CSchool
//
//  Created by 左俊鑫 on 17/5/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LEOWebDAVItem;

typedef void(^GetImageBlock)(UIImage *image);
@interface YunLogoImageHelper : NSObject


/**
 根据类型返回图片logo

 @param model 处理model
 @param imageBlock 得到图片异步处理
 */
- (void)imageWithType:(LEOWebDAVItem *)model getImage:(GetImageBlock)imageBlock;

@end
