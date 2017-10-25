//
//  LibraryHiddenView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibraryHiddenView.h"
#import "LibraryBookLocationCell.h"
#import "SDAutoLayout.h"

@implementation LibraryHiddenView
{
    NSArray *_dataArray;
    UITableView *_tableView;
    CGFloat _totalHeight;
    UIImageView *_buttonImageView;
    UIView *_bacView;
    UIView *_contentView;
    UIButton *showButton;
}
-(instancetype)initWithDataSource:(NSArray *)dataArray{
    self = [super init];
    if (self) {
        _dataArray = dataArray;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.frame = CGRectMake(0, kScreenHeight-45-64, kScreenWidth, 45);

    _bacView = [UIView new];
    _bacView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [self addSubview:_bacView];
    _bacView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight );
    _bacView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView:)];
    [_bacView addGestureRecognizer:tap];
    _bacView.userInteractionEnabled = YES;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    _contentView.backgroundColor = RGB(245, 245, 245);
    [self addSubview:_contentView];
    
    showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showButton.frame = CGRectMake(0, 0, kScreenWidth, 44.5);
    [showButton addTarget:self action:@selector(showButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:showButton];
    showButton.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 16, 100, 13)];
    titleLabel.text = @"馆藏状态";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB(85, 85, 85);
    [showButton addSubview:titleLabel];
    
    _buttonImageView = [[UIImageView alloc] init];
    _buttonImageView.image = [UIImage imageNamed:@"libraryopen"];
    [showButton addSubview:_buttonImageView];
    
    
    
    _buttonImageView.sd_layout
    .rightSpaceToView(showButton,12)
    .topSpaceToView(showButton,12)
    .widthIs(23)
    .heightIs(23);
    
    CGFloat tHeight = 75*_dataArray.count;
    
    CGFloat maxHeight = kScreenHeight*0.6;
    
    CGFloat height = tHeight>maxHeight?(height=maxHeight):(height=tHeight);
    _totalHeight = height+45;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_contentView addSubview:_tableView];
    [_tableView reloadData];
}

- (void)showButtonAction:(UIButton *)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (!sender.selected) {
            self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-45);
            
            _contentView.frame = CGRectMake(0, kScreenHeight-_totalHeight-64, kScreenWidth, _totalHeight);
            _buttonImageView.image = [UIImage imageNamed:@"libraryopen-down"];
            _bacView.hidden = NO;
        }else{
            self.frame = CGRectMake(0, kScreenHeight-45-64, kScreenWidth, 45);
            
            _contentView.frame = CGRectMake(0, 0, kScreenWidth, 45);
            _buttonImageView.image = [UIImage imageNamed:@"libraryopen"];
            _bacView.hidden = YES;
            
        }
        sender.selected = !sender.selected;
    } completion:^(BOOL finished) {
        ;
    }];

}

- (void)hiddenView:(UITapGestureRecognizer *)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenHeight-45-64, kScreenWidth, 45);
        _contentView.frame = CGRectMake(0, 0, kScreenWidth, 45);

    } completion:^(BOOL finished) {
        ;
    }];
    
    _buttonImageView.image = [UIImage imageNamed:@"libraryopen"];
    _bacView.hidden = YES;
    showButton.selected = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LibraryBookLocationCell";
    LibraryBookLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LibraryBookLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    //    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model"];
    return 75;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
