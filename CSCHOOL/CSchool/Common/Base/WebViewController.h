//
//  WebViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/6/21.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel; //设置标题，如果不写，则默认取网页标题

@property (nonatomic, copy) NSString *requestUrl; //请求连接


@end
