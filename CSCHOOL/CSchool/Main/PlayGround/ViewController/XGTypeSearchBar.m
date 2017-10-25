//
//  XGTypeSearchBar.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "XGTypeSearchBar.h"
#import "MLMOptionSelectView.h"
#import "SDAutoLayout.h"
#import "UIView+UIViewController.h"

@implementation XGTypeSearchBar
{
    NSArray *_typeArray;
    MLMOptionSelectView *_cellView;
    UIView *_cellViewBackView;
    UILabel *typeButton;
    NSDictionary *_typeDic;
}


-(instancetype)initWithTypeArray:(NSArray *)typeArray{
    self = [super init];
    if (self) {
        _typeArray = typeArray;
        [self setup];
    }
    return self;
}

- (void)setup{

    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    [self addSubview:backView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    cancelButton.sd_layout
    .rightSpaceToView(self,5)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,5)
    .widthIs(60);
    
    backView.sd_layout
    .rightSpaceToView(cancelButton,5)
    .leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0);
    
    _cellView = [[MLMOptionSelectView alloc] initOptionView];
    _cellViewBackView = [[UIView alloc] init];
    _cellView.backColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    
    [backView addSubview:_cellViewBackView];
    typeButton = [[UILabel alloc] init];
    typeButton.text = _typeArray[0][@"value"];
    _typeDic = _typeArray[0];
    typeButton.font = Title_Font;
    typeButton.textColor = Color_Black;
    [backView addSubview:typeButton];

    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"librarysanjiao"];
    [backView addSubview:iconImageView];
    
    _textField = [[UITextField alloc] init];
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.delegate = self;
    _textField.tintColor = [UIColor darkGrayColor];
    _textField.font = [UIFont systemFontOfSize:14];
    [backView addSubview:_textField];
    
    _cellViewBackView.sd_layout
    .leftSpaceToView(backView,5)
    .topSpaceToView(backView,0)
    .bottomSpaceToView(backView,0)
    .widthIs(80);
    
    typeButton.sd_layout
    .leftSpaceToView(backView,9)
    .topSpaceToView(backView,0)
    .bottomSpaceToView(backView,0)
    .widthIs(30);
    
    iconImageView.sd_layout
    .leftSpaceToView(typeButton,5)
    .centerYEqualToView(typeButton)
    .widthIs(9)
    .heightIs(6);
    
    _textField.sd_layout
    .leftSpaceToView(iconImageView,5)
    .topSpaceToView(backView,6)
    .bottomSpaceToView(backView,5)
    .rightSpaceToView(backView,10);
 
    [typeButton tapHandle:^{
        [self defaultCell];
        _cellView.vhShow = NO;
        _cellView.optionType = MLMOptionSelectViewTypeArrow;
#warning ---- 想保持无论何种情况都左、右对齐,可以选择自己想要对齐的边，重新设置edgeInset
        CGRect rect = [MLMOptionSelectView targetView:_cellViewBackView];
        _cellView.edgeInsets = UIEdgeInsetsMake(10, rect.origin.x, 10, SCREEN_WIDTH - rect.origin.x - rect.size.width);
        
        [_cellView showOffSetScale:0.2 viewWidth:80 targetView:_cellViewBackView direction:MLMOptionSelectViewBottom];
    }];
}

- (void)cancelButtonAction:(UIButton *)sender{
    if (_searchCancel) {
        _searchCancel();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text length]<1) {
        return NO;
    }
    if (_searchClick) {
        [_textField endEditing:YES];
        _searchClick(textField.text, _typeDic);
    }
    return YES;
}

- (void)setTypeButtonTitleWithType:(NSString *)type{
    for (NSDictionary *dic in _typeArray) {
        if ([dic[@"key"] isEqualToString:type]) {
            typeButton.text = dic[@"value"];
        }
    }
}

- (void)defaultCell {
    WEAK(weaklistArray, _typeArray);
    WEAK(weakSelf, self);
    WEAK(weakCellView, _cellView);
    
//    WEAK(weakSendTextView, _sendNumTextView);
    _cellView.canEdit = NO;
    [_cellView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    _cellView.cell = ^(NSIndexPath *indexPath){
        
        UITableViewCell *cell = [weakCellView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row][@"value"]];
        cell.textLabel.font = Title_Font;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
    
        return cell;
    };
    _cellView.optionCellHeight = ^{
        return 40.f;
    };
    _cellView.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
    
    WEAK(weakTypeBtn, typeButton);

    _cellView.selectedOption = ^(NSIndexPath *indexPath){
        NSLog(@"%ld",indexPath.row);
        weakTypeBtn.text = weaklistArray[indexPath.row][@"value"];
//        weakSendTextView.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row][0]];
        _typeDic = weaklistArray[indexPath.row];
    };
    
}

@end
