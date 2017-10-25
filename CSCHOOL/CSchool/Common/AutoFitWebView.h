//
//  AutoFitWebView.h
//  CSchool
//
//  Created by 左俊鑫 on 16/8/2.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WebViewGetTitleBlock)(NSString *title);

@interface AutoFitWebView : UIWebView

@property (nonatomic, strong) WebViewGetTitleBlock getTitleBlock;
- (void)loadHtmlString:(NSString *)htmlStr;

@end
