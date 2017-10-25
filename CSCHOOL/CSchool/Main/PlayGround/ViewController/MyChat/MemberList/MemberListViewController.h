//
//  MemberListViewController.h
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface MemberListViewController : UIViewController
-(void)reloadSections;
-(void)friendsRequest:(NSNotification*)note;
@end
