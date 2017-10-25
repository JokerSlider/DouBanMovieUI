//
//  SearchBaseViewController.h
//  CSchool
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@protocol SearchBaseViewControllerDelegate
/**
 *  重写这个方法 自定义cell
 *
 *  @param tableView tableview
 *  @param indexPath indexPath
 *  @param dataArr   数据源
 *
 *  @return 返回自定义的cell
 */
-(UITableViewCell *)tableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath withDataSourceArr:(NSArray *)dataArr withSearchText:(NSString *)text;

-(CGFloat)tableView:(UITableView *)tableView heightForSearchRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectSearchRowAtIndexPath:(NSIndexPath *)indexPath;

@end;
@interface SearchBaseViewController : BaseViewController
@property (retain,nonatomic) id <SearchBaseViewControllerDelegate> delegate;
//数据源
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *originalArray;
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,strong)NSArray *seacrKeyArr;
@property (strong, nonatomic) UITableView *mainTableView;
@end
