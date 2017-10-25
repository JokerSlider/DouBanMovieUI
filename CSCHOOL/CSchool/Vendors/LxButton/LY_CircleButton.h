//
//  LY_CircleButton.h
//  小球拖拽拉伸
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonBlock) (id sender);


@interface LY_CircleButton : UIButton

/**
 *  最大拖动范围,默认为100
 */
@property (nonatomic,assign) NSInteger maxDistance;
/**
 *  点击事件block
 */
- (void)addButtonAction:(ButtonBlock)block;


/**
 x移除自己
 */
-(void)allKill;
@end
