//
//  FlowerPushViewController.h
//  CSchool
//
//  Created by mac on 16/11/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface FlowerPushViewController : BaseViewController
@property (strong, nonatomic)UICollectionView *FlowercollectionView;
-(void)loadDataWithRID:(NSString *)rid  pageNum:(NSString *)page;//从子控制器加载数据 在子控制器调用  走父类方法
@end
