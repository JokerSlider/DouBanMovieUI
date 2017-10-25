//
//  ChatMessageViewController.h
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface ChatMessageViewController : UIViewController   
@property (nonatomic,strong)UITableView *mainTableView;
-(void)messageCome:(NSNotification*)note;
-(void)readChatData;
@end
