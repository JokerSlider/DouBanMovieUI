//
//  IndexManager.h
//  CSchool
//
//  Created by 左俊鑫 on 2017/10/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexManager : NSObject

+(IndexManager *)shareConfig;

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong) NSArray *iconsArray;

- (void)buttonViewAction:(UIButton *)sender withVC:(UIViewController *)vc;

@end
