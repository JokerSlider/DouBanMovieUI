//
//  SendMessageView.h
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SendDanMuMessageSuccessBlock)(NSString *danmuStr);
@interface SendMessageView : UIView
@property (nonatomic, copy) SendDanMuMessageSuccessBlock sendDanMuMessageSuccessblock;

@end
