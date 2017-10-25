//
//  SetNickNameViewController.h
//  CSchool
//
//  Created by mac on 17/3/4.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
#import "XMPPFramework.h"

typedef void(^SetNickNameSucessBlock)(NSString *nickName);

@interface SetNickNameViewController : UIViewController
@property (nonatomic,strong)XMPPJID *jid;
@property (nonatomic, copy) SetNickNameSucessBlock setNickNameSucessBlock;
@property (nonatomic,strong) NSString *groupName;

@end
