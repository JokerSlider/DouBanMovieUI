//
//  ChangePassWordViewController.h
//  CSchool
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "hxButton.h"
//#import "baseView.h"
//#import "HxControl.h"
@interface ChangePassWordViewController : UIViewController
{
    UITextField *oldKeyTextField;
    UITextField *fNewKeyTextField;
    UITextField *sNewKeyTextField;
    
    UILabel *oldKeyLabel;
    UILabel *fNewLabel;
    UILabel *sNewLabel;

}
@property (nonatomic, strong) UIButton *isChangeButton;


@end
