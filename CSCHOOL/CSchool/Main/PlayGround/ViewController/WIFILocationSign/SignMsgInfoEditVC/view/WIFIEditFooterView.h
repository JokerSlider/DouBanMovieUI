//
//  WIFIEditFooterView.h
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  WIFIEditFoterDelegate <NSObject>
@optional
-(void)openEditViewController;
-(void)openSureViewController;
-(void)openStartSignViewController;

@end
@interface WIFIEditFooterView : UIView
@property (nonatomic, weak) id<WIFIEditFoterDelegate> delegate;
@property (nonatomic,assign)BOOL  isEdit;
@end
