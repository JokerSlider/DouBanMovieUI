//
//  lbl_fireworksView.h
//  Test
//
//  Created by 张丹 on 16/7/14.
//  Copyright © 2016年 有云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lbl_FireworksView : UIView

- (void)animate;
-(void)resetViewPositions;
@property (nonatomic,assign)CGPoint myCenter;
@end
