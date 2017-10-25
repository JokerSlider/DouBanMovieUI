//
//  KVOHeaderView.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/23.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "KVOHeaderView.h"
#import "UIImage+JQImage.h"
@interface KVOHeaderView()
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *emailButton;
@property (nonatomic,strong)  UILabel   *title;

@end
@implementation KVOHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.searchBar];
        [self addSubview:self.searchButton];
        [self addSubview:self.emailButton];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth-100)/2, self.center.y  , 100, 30)];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor whiteColor];
        self.title.text = @"豆瓣电影";
        self.title.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.title];
        
        
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    for (UITableView *tableView in self.tableViews) {
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    UITableView *tableView = (UITableView *)object;
    CGFloat tableViewoffsetY = tableView.contentOffset.y;
    
    UIColor * color = [UIColor whiteColor];
    CGFloat alpha = MIN(1, tableViewoffsetY/136);
    
    self.backgroundColor = [color colorWithAlphaComponent:alpha];
    
    if (tableViewoffsetY < 125){
        
        [UIView animateWithDuration:0.25 animations:^{
            self.searchButton.hidden = NO;
            [self.emailButton setBackgroundImage:[UIImage imageNamed:@"location_red"] forState:UIControlStateNormal];
            self.searchBar.frame = CGRectMake(-(KscreenWidth-60), 30, KscreenWidth-80, 30);
            self.emailButton.alpha = 1-alpha;
            self.searchButton.alpha = 1-alpha;
            self.title.hidden = NO;
            
        }];
    } else if (tableViewoffsetY >= 125){
        
        [UIView animateWithDuration:0.25 animations:^{
            self.searchBar.frame = CGRectMake(20, 30, KscreenWidth-80, 30);
            self.searchButton.hidden = YES;
            self.emailButton.alpha = 1;
            [self.emailButton setBackgroundImage:[UIImage imageNamed:@"location_black"] forState:UIControlStateNormal];
            self.title.hidden = YES;
        }];
    }
    
}


- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-(KscreenWidth-60), 30, KscreenWidth-80, 30)];
        _searchBar.placeholder = @"搜索你喜欢的电影";
        _searchBar.layer.cornerRadius = 15;
        _searchBar.layer.masksToBounds = YES;
        
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:_searchBar.frame.size] forState:UIControlStateNormal];
        
        [_searchBar setBackgroundImage:[UIImage imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.4] size:_searchBar.frame.size] ];
        
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        
        
    }
    return _searchBar;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"home_search_icon"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchButton;
}

- (UIButton *)emailButton {
    if (!_emailButton) {
        _emailButton = [[UIButton alloc] initWithFrame:CGRectMake(KscreenWidth-45, 30, 30, 30)];
        [_emailButton setBackgroundImage:[UIImage imageNamed:@"location_red"] forState:UIControlStateNormal];
        [_emailButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _emailButton;
}


-(void)setTitleString:(NSString *)titleString
{
    _title.text = _titleString;
}

#pragma mark  delegate
-(void)leftAction:(UIButton *)sender
{
    if (self.delegate&&[self respondsToSelector:@selector(leftAction:)]) {
        [self.delegate leftBtnAction:sender];
    }
}
-(void)rightAction:(UIButton *)sender
{
    if (self.delegate&&[self respondsToSelector:@selector(rightAction:)]) {
        [self.delegate rightBtnAction:sender];
    }
}

@end
