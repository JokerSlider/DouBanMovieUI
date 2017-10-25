//
//  AutoWebViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/8/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface AutoWebViewController : BaseViewController

//传与服务器交互的字典
@property (nonatomic, strong) NSDictionary *commitDic;

//服务器传回html片段的路径
@property (nonatomic, strong) NSString *valueForKeyPath;

//服务器传回标题的路径
@property (nonatomic, strong) NSString *titleForKeyPath;

//传要加载的字符片段
- (void)loadHtmlString:(NSString *)htmlStr;


@end
