//
//  MapInfoView.h
//  CSchool
//
//  Created by 左俊鑫 on 16/7/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

/**
 *  地图-内容详情
 */

#import <UIKit/UIKit.h>
typedef void(^GoBtnClickBlocl)(NSDictionary *dataDic);
@interface MapInfoView : UIView

//到这去按钮点击回调
@property (nonatomic, strong) GoBtnClickBlocl goBtnClickBlock;
@property (nonatomic, strong) NSDictionary *dataDic;

@end
