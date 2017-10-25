//
//  URLConsts.h
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#ifndef URLConsts_h
#define URLConsts_h

#define isDEBUG  //调试模式，正式版本注释掉。

#ifdef isDEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else
#define DLog( s, ... )
#endif
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);

#define API_HOST @"http://api.douban.com/v2/movie/in_theaters"
#define Movie_Info @"http://api.douban.com/v2/movie/subject/"
#define API_HOST2 @"https://api.douban.com/v2/movie/coming_soon"
#endif /* URLConsts_h */
