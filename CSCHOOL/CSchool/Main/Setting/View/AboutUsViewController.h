//
//  AboutUsViewController.h
//  CSchool
//
//  Created by mac on 16/2/3.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutUsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,copy)NSString *baseUrl;
@end
