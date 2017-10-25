//
//  GetPhoto.h
//  CSchool
//
//  Created by 左俊鑫 on 16/11/21.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^GetPhotoBlock)(UIImage *image);
@interface GetPhoto : NSObject

@property (nonatomic, assign) BOOL crop;//是否剪裁
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, copy) GetPhotoBlock getPhotoBlock;

- (void)getPhoto;

@end
