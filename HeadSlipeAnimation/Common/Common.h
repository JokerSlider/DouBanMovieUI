//
//  Common.h
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define KscreenWidth  [UIScreen mainScreen].bounds.size.width
#define KscreenHeight  [UIScreen mainScreen].bounds.size.height

#define Title_Font [UIFont systemFontOfSize:13]
#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#ifdef __IPHONE_10_0
#define RGB_Alpha(R,G,B,Alpha)	 UIColor colorWithDisplayP3Red:R/255.0f green:G/255.0f blue:B/255.0f alpha:Alpha]
#endif
#define RGB_Alpha(R,G,B,Alpha)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:Alpha]


#define Title_Font [UIFont systemFontOfSize:13]
#define Base_Color2 RGB(239, 240, 241) //背景灰色
#define Color_Black RGB(51,51,51) //字体黑色
#define Color_Gray RGB(128,128,128)  //字体灰色
#define Base_Orange RGB(60, 174, 255)
#define Message_Num  @"15"
#endif /* Common_h */
