//
//  MarketTypeCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MarketTypeCell.h"
#import "SDAutoLayout.h"
#import "UIView+UIViewController.h"
#import "UITextView+Placeholder.h"
#import "LPActionSheet.h"

@implementation MarketTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _typeBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"请选择分类" forState:UIControlStateNormal];
        view.titleLabel.font = Title_Font;
        view.titleLabel.textAlignment = NSTextAlignmentRight;
        [view setTitleColor:[UITextView defaultPlaceholderColor] forState:UIControlStateNormal];
        [view setTitleColor:Color_Black forState:UIControlStateSelected];
        [view addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        view.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        view;
    });
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_typeBtn];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,14)
    .topSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,5)
    .widthIs(150);
    
    _typeBtn.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,5)
    .widthIs(150);
}

- (void)typeBtnAction:(UIButton *)sender{
//    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:, nil];
//    [choiceSheet showInView:self.viewController.view];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in _typeArray) {
        [arr addObject:dic[@"CINAME"]];
    }
    [self.viewController.view endEditing:YES];
    [LPActionSheet showActionSheetWithTitle:@"请选择分类"
                          cancelButtonTitle:@"取消"
                     destructiveButtonTitle:@""
                          otherButtonTitles:arr
                                    handler:^(LPActionSheet *actionSheet, NSInteger index) {
                                        NSLog(@"%ld",index);
                                        if (_typeBlock) {
                                            _typeBlock(self,index-1);
                                        }
                                    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_typeBlock) {
        _typeBlock(self,buttonIndex);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
