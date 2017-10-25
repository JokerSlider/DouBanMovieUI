//
//  SendFlowerView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/11/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SendFlowerView.h"
#import "SDAutoLayout.h"
#import "PhotoCarView.h"
#import "UILabel+stringFrame.h"
#import "SignViewController.h"
#import "UIView+UIViewController.h"
#import "ValidateObject.h"
#import "MLMOptionSelectView.h"
#import "UIView+Category.h"

@interface SendFlowerView()

@property (nonatomic, strong) MLMOptionSelectView *cellView;

@end

@implementation SendFlowerView
{
    UILabel *_sendNumTextView;
    UIView *backView;
    UIControl *hiddenCtr;
    
    NSArray *listArray;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)show{
    [UIView animateWithDuration:0.5 animations:^{
        hiddenCtr.hidden = NO;
        backView.frame = CGRectMake(0, kScreenHeight-64-208, kScreenWidth, 208);
    }];
}

- (void)createViews{
    
    listArray = [NSArray array];
    
    listArray = @[@[@"99",@"天长地久"],@[@"66",@"六六大顺"],@[@"50",@"五彩缤纷"],@[@"10",@"十全十美"],@[@"1",@"一心一意"]];
    
    _cellView = [[MLMOptionSelectView alloc] initOptionView];

    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.userInteractionEnabled = YES;
    hiddenCtr = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [hiddenCtr addTarget:self action:@selector(hiddenAction:) forControlEvents:UIControlEventTouchUpInside];
    hiddenCtr.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    hiddenCtr.hidden = YES;
    [self addSubview:hiddenCtr];
    
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    backView.frame = CGRectMake(0, kScreenHeight-64, kScreenWidth, 208);
    
    UILabel *sendTitleLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"赠送鲜花数";
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view;
    });
    
    UILabel *haveTitleLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"拥有鲜花数";
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view;
    });
    
    UIButton *subButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setTitle:@"➖" forState:UIControlStateNormal];
        view.backgroundColor = RGB(226, 226, 226);
        view;
    });
    
    UIButton *addButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setTitle:@"➕" forState:UIControlStateNormal];
        view.backgroundColor = RGB(226, 226, 226);
        view;
    });
    
    _sendNumTextView = ({
        UILabel *view = [UILabel new];
        view.text = @"1";
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:15];
        view.backgroundColor = RGB(226, 226, 226);
        view.textAlignment = NSTextAlignmentCenter;
        UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sendOtherNum:)];
        [view addGestureRecognizer:tap];
        view.userInteractionEnabled = YES;
        view;
    });
    
    UIView *bacSendNumView = ({
        UIView *view = [UIView new];
        view;
    });
    
    
    [_sendNumTextView tapHandle:^{
        [self defaultCell];
        _cellView.vhShow = NO;
        _cellView.optionType = MLMOptionSelectViewTypeArrow;
#warning ---- 想保持无论何种情况都左、右对齐,可以选择自己想要对齐的边，重新设置edgeInset
        CGRect rect = [MLMOptionSelectView targetView:bacSendNumView];
        _cellView.edgeInsets = UIEdgeInsetsMake(10, rect.origin.x, 10, SCREEN_WIDTH - rect.origin.x - rect.size.width);
        
        [_cellView showOffSetScale:0.5 viewWidth:130 targetView:bacSendNumView direction:MLMOptionSelectViewTop];
    }];
    
    UIImageView *flowerImage = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"photoWall_flower_s"];
        view;
    });
    
    UILabel *haveNumLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Base_Orange;
        view.text = [NSString stringWithFormat:@"X %@",[AppUserIndex GetInstance].flowerNum];
        view;
    });
    
    [backView sd_addSubviews:@[bacSendNumView,sendTitleLabel, subButton, _sendNumTextView, addButton, haveNumLabel, flowerImage, haveTitleLabel]];
    
    sendTitleLabel.sd_layout
    .leftSpaceToView(backView, 13)
    .topSpaceToView(backView,48)
    .heightIs(15)
    .widthIs(90);
    
    addButton.sd_layout
    .rightSpaceToView(backView, 14)
    .topSpaceToView(backView,37)
    .heightIs(31)
    .widthIs(31);
    
    _sendNumTextView.sd_layout
    .rightSpaceToView(addButton, 8)
    .topSpaceToView(backView,37)
    .heightIs(31)
    .widthIs(42);
    
    
    bacSendNumView.sd_layout
    .topEqualToView(_sendNumTextView)
    .heightRatioToView(_sendNumTextView,1)
    .centerXEqualToView(_sendNumTextView)
    .widthIs(130);
    
//    bacSendNumView.backgroundColor = [UIColor redColor];
    
    subButton.sd_layout
    .rightSpaceToView(_sendNumTextView, 8)
    .topSpaceToView(backView,37)
    .heightIs(31)
    .widthIs(31);
    
    haveTitleLabel.sd_layout
    .leftSpaceToView(backView, 13)
    .topSpaceToView(backView,101)
    .heightIs(15)
    .widthIs(90);
    
    CGSize size=[haveNumLabel boundingRectWithSize:CGSizeMake(0, 21)];
    
    haveNumLabel.sd_layout
    .rightSpaceToView(backView, 14)
    .topSpaceToView(backView,101)
    .heightIs(14)
    .widthIs(size.width+5);
    
    flowerImage.sd_layout
    .rightSpaceToView(haveNumLabel, 8)
    .topSpaceToView(backView,96)
    .heightIs(21)
    .widthIs(18);
    
    UIView *grayView = [UIView new];
    grayView.backgroundColor = RGB(226, 226, 226);
    
    UIButton *getBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeSystem];
        [view setTitle:@"去赚取" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view addTarget:self action:@selector(getBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    UIButton *sendBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeSystem];
        [view setTitle:@"赠送" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    UIButton *cancelBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeSystem];
        [view setTitle:@"取消" forState:UIControlStateNormal];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        [view addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    [backView sd_addSubviews:@[grayView, getBtn, sendBtn, cancelBtn]];
    
    grayView.sd_layout
    .leftSpaceToView(backView,0)
    .rightSpaceToView(backView,0)
    .heightIs(5)
    .bottomSpaceToView(backView,50);
    
    getBtn.sd_layout
    .leftSpaceToView(backView,0)
    .bottomSpaceToView(backView,0)
    .heightIs(50)
    .widthIs(70);
    
    sendBtn.sd_layout
    .rightSpaceToView(backView,0)
    .bottomSpaceToView(backView,0)
    .heightIs(50)
    .widthIs(70);
    
    cancelBtn.sd_layout
    .leftSpaceToView(getBtn,30)
    .rightSpaceToView(sendBtn,30)
    .heightIs(50)
    .bottomSpaceToView(backView,0);
    
    [UIView animateWithDuration:0.2 animations:^{
        hiddenCtr.hidden = NO;
        backView.frame = CGRectMake(0, kScreenHeight-64-208, kScreenWidth, 208);
    }];
}

- (void)sendOtherNum:(UIGestureRecognizer *)ges{
    if (ges.state != UIGestureRecognizerStateEnded && ges.state != UIGestureRecognizerStateFailed){
        //通过使用 locationInView 这个方法,来获取到手势的坐标
        CGPoint location = [ges locationInView:ges.view.superview];
        ges.view.center = location;
    }

}

- (void)defaultCell {
    WEAK(weaklistArray, listArray);
    WEAK(weakSelf, self);
    WEAK(weakSendTextView, _sendNumTextView);
    _cellView.canEdit = NO;
    [_cellView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    _cellView.cell = ^(NSIndexPath *indexPath){
        
        UITableViewCell *cell = [weakSelf.cellView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row][0]];
        cell.textLabel.font = Title_Font;
        cell.textLabel.textColor = Base_Orange;
        
        for (UILabel *view in cell.contentView.subviews) {
            if (view.tag == 909) {
                [view removeFromSuperview];
            }
        }

        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 120, 40)];
        [cell.contentView addSubview:desLabel];
        desLabel.font = Title_Font;
        desLabel.tag = 909;
        desLabel.textColor = Color_Gray;
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row][1]];
        return cell;
    };
    _cellView.optionCellHeight = ^{
        return 40.f;
    };
    _cellView.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
    
    _cellView.selectedOption = ^(NSIndexPath *indexPath){
        NSLog(@"%ld",indexPath.row);
        weakSendTextView.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row][0]];

    };

}

- (void)getBtnAction:(UIButton *)sender{

    SignViewController *vc = [[SignViewController alloc] init];
    //    PhotoWallIndexViewController *vc = [[PhotoWallIndexViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
    [self hiddenAction:sender];

}

- (void)sendBtnAction:(UIButton *)sender{
    
    if ([_sendNumTextView.text integerValue] > [[AppUserIndex GetInstance].flowerNum integerValue]) {
        [ProgressHUD showError:@"鲜花数量不足"];
        return;
    }
    
    NSDictionary *commitDic = @{
                                @"rid":@"giveFlowers",
                                @"userid":[AppUserIndex GetInstance].role_id,
                                @"photoid":_model.picId,
                                @"goodid":@"1", //商品ID （默认为1 鲜花）
                                @"count":_sendNumTextView.text
                                };
    [ProgressHUD show:@""];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"data"] integerValue]>0) {
            [AppUserIndex GetInstance].flowerNum = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
        }
        [self hiddenAction:nil];
        if (_sendFlowerBlock) {
            NSInteger count = [_model.flowerNum integerValue]+[_sendNumTextView.text integerValue];
            _model.flowerNum = [NSString stringWithFormat:@"%ld",count];
            _sendFlowerBlock(self, _model);
        }
        [ProgressHUD showSuccess:@"赠送成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)cancelBtnAction:(UIButton *)sender{
    [self hiddenAction:sender];
}

- (void)subButtonAction:(UIButton *)sender{
    NSInteger num = [_sendNumTextView.text integerValue];
    if (num>1) {
        _sendNumTextView.text = [NSString stringWithFormat:@"%ld",num-1];
    }
}

- (void)addButtonAction:(UIButton *)sender{
    NSInteger num = [_sendNumTextView.text integerValue];
    if (num < [[AppUserIndex GetInstance].flowerNum integerValue]) {
        _sendNumTextView.text = [NSString stringWithFormat:@"%ld",num+1];
    }
}

- (void)hiddenAction:(UIButton *)sender{
    
    [UIView animateWithDuration:0.2 animations:^{
        backView.frame = CGRectMake(0, kScreenHeight-64, kScreenWidth, 208);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string length] > 0){
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9')) {//数据格式正确
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
        }
    }

    return  [ValidateObject validateNumber:string];
}

@end
