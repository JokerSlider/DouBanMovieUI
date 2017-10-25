//
//  GroupViewCell.h
//  CSchool
//
//  Created by mac on 17/2/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "ChatUserModel.h"
@interface GroupViewCell : UITableViewCell

@property (nonatomic, retain) XMPPElement *xmppElement;
@property (nonatomic,strong) ChatUserModel *model;
@end
