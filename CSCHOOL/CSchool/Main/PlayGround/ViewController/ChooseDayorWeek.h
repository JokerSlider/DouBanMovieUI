//
//  ChooseDayorWeek.h
//  CSchool
//
//  Created by mac on 16/4/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseDayorWeek : UIButton
{
    UILabel *_rectTitleLabel;
    UILabel *_subTitileLabel;
    UILabel *_mediaLabel;
}

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

@property(nonatomic,retain)UIFont *titleFont;
@property(nonatomic,retain )UIFont *subtitleFont;

@property (nonatomic,retain) UIColor *textColor;

@end
