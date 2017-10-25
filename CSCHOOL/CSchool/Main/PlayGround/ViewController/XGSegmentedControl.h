//
//  XGSegmentedControl.h
//  CSchool
//
//  Created by 左俊鑫 on 2017/9/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SegmentItemClick)(NSInteger index);
@interface XGSegmentedControl : UIView

-(instancetype)initWithItems:(NSArray *)items;

@property (nonatomic, copy) SegmentItemClick segmentItemClick;

@end
