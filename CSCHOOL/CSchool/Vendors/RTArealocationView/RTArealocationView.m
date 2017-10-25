//
//  NRArealocationView.m
//  eLongRoom
//
//  Created by mac on 16/7/3.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "RTArealocationView.h"

#define NUM 3       // 菜单的层级

@interface RTArealocationView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger        selectedIndex[NUM];  // 每层选中的索引index
    CGFloat          leftWidth;           // 左边栏宽度
    NSMutableArray   *tableViewArr;       // 存放每层的tableView的数组
    UIView           *backgroundView;     // 背景view
    NSInteger        selectedRow;         // 选中的行
    UIImageView      *selIcon;            // 选中的icon
    UITableViewCell  *selCell;            // 选中的cell
    NSMutableArray   *titleArr;       // 存放每层的tableView的数组
    UITableView *_locationView;
}
@property (nonatomic,strong) NSMutableDictionary *selectedDic;
@end

@implementation RTArealocationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

#pragma mark - init
- (void)setupUI {
    [self setupSubViews];
    // 初始化 tableView
    for (int i=0; i<NUM; i++) {
        selectedIndex[i] = -1;
        _locationView = [[UITableView alloc] init];
        _locationView.dataSource = self;
        _locationView.delegate = self;
        _locationView.rowHeight = 48;
        _locationView.layer.borderWidth = 0.3;
        _locationView.layer.borderColor = [[UIColor lightGrayColor] CGColor];//设置列表边框
        _locationView.separatorColor = [UIColor lightGrayColor];//设置行间隔边框
        _locationView.frame = CGRectMake(0, 30, self.bounds.size.width, kScreenHeight);
        _locationView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableViewArr addObject:_locationView];
        
    }
    backgroundView = [[UIView alloc] init];
    [backgroundView addSubview:tableViewArr[0]];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
}
-(void)viewDidLayoutSubviews
{
    if ([_locationView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_locationView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_locationView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_locationView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma mark 编辑单元格
- (void)editAction {
    [tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        [tableView setEditing:!tableView.editing animated:YES];
        if (tableView.editing) {
            tableView.editing = YES;
        }
        else{
            tableView.editing = NO;
            if (self.selectedDic.count>0) {
                [self.selectedDic removeAllObjects];
            }
        }
    }];
}
-(void)reloadRTData
{
    for (UITableView *view in tableViewArr) {
        [view reloadData];
    }
}
#pragma mark - setupSubViews
- (void)setupSubViews {
    selIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nr_selected"]];
    selectedRow = 0;
    tableViewArr = [NSMutableArray array];
    titleArr = [NSMutableArray array];
    leftWidth = 90;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    __block NSInteger count;
    [tableViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == tableView) {
            if ([self.delegate respondsToSelector:@selector(arealocationView:countForClassAtLevel:index:selectedIndex:)]) {
                count = [self.delegate arealocationView:self countForClassAtLevel:idx index:selectedRow selectedIndex:selectedIndex];
                *stop = YES;
            }
        }
    }];
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"location_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = Color_Black;
        }
    [tableViewArr enumerateObjectsUsingBlock:^(UITableView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == tableView) {
            if ([self.delegate respondsToSelector:@selector(arealocationView:titleForClass:index:selectedIndex:)]) {
                
                cell.textLabel.text = [self.delegate arealocationView:self titleForClass:idx index:indexPath.row selectedIndex:selectedIndex];
                cell.textLabel.numberOfLines = 0;
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
        }
    }];
    
    return cell;
}
-(NSMutableDictionary*)selectedDic{
    if (_selectedDic==nil) {
        _selectedDic = [[NSMutableDictionary alloc]init];
    }
    return _selectedDic;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (selCell!=cell) {
        [selIcon removeFromSuperview];
        selCell.textLabel.textColor = Color_Black;
        selCell = cell;
    }
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    for (int i=0; i<tableViewArr.count; i++) {
        UITableView *tempTableView = tableViewArr[i];
        // 添加下一级tableView
        if (tempTableView == tableView && i!= tableViewArr.count - 1) {
            selectedRow = indexPath.row;
            selectedIndex[i] = indexPath.row;
            [tableViewArr[i+1] reloadData];
            if (![tableViewArr[i+1] superview]) {
                NSMutableArray *secondArr = [NSMutableArray array];
                for (NSDictionary *dic in _otherTableviewArr) {
                    [secondArr addObject:dic[@"district"]];
                }
                [backgroundView addSubview:tableViewArr[i+1]];
            }
            // 移除多余的tableView
            for (int j=i; j<tableViewArr.count-2; j++) {
                if ([tableViewArr[j+2] superview]) {
                    [tableViewArr[j+2] removeFromSuperview];
                }
            }
            [self adjustTableViews];
            break;
        }
        if (i == tableViewArr.count - 1) {
            [self saveSelectedIndex];
            // 改变选中颜色
            cell.textLabel.textColor = [UIColor orangeColor];
            if ([self.delegate respondsToSelector:@selector(arealocationView:finishChooseLocationAtIndexs:)]) {
                    if (!tableView.editing) {
                        [self.delegate arealocationView:self finishChooseLocationAtIndexs:selectedIndex];
                }
            }
        }
    }
}
#pragma mark - 保存tableView的选中项
- (void)saveSelectedIndex {
    
    [tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        selectedIndex[idx] = tableView.superview ? tableView.indexPathForSelectedRow.row : -1;
    }];
}
#pragma mark - 加载保存的tableView的选中项
- (void)loadSelectedIndex {
    
    [tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:
                                         selectedIndex[idx]
                                                           inSection:0]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
        
        // 将选中tableView添加到backgroundView上
        if ((selectedIndex[idx] !=-1 && !tableView.superview) || !idx) {
            [backgroundView addSubview:tableView];
        }
    }];
}

#pragma mark - showArealocationView
- (void)showArealocationInView:(UIView *)view {
    
    backgroundView.frame = self.bounds;
    // 添加backgroundView
    if(!backgroundView.superview) {
        [self addSubview:backgroundView];
    }
    [self loadSelectedIndex];
    [self adjustTableViews];
    [view addSubview:self];
    
}

#pragma mark - dismissArealocationView
- (void)dismissArealocationView {
    
    if(self.superview) {
        [UIView animateWithDuration:.5f animations:^{
            self.alpha = .0f;
        } completion:^(BOOL finished) {
            [backgroundView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperview];
            }];
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 调整表视图的位置和大小
- (void)adjustTableViews {
    
    __block NSInteger showTableCount = 0;  // 显示的tableView数量
    
    [tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL *stop) {
        
        if(tableView.superview) {
            showTableCount ++;
        }
    }];
    // 调整tableView的宽度
    for(int i=0; i<showTableCount;i++) {
        UITableView *tableView = [tableViewArr objectAtIndex:i];
        CGRect frame = tableView.frame;
        UILabel *title = [[UILabel alloc]init];
        title.layer.borderColor = [UIColor lightGrayColor].CGColor;
        title.layer.borderWidth = 1;
        title.textColor = Color_Black;
        title.textAlignment =NSTextAlignmentCenter;
        title.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(16.0)];
        if (i==0) {
            frame.size.width = leftWidth;
            frame.origin.x = 0;
            title.frame= CGRectMake(frame.origin.x,0, leftWidth, 30);
            title.text = _totalTiltle[i];
            title.font = [UIFont systemFontOfSize:14];
        }else if(i==1){
            CGFloat rightWidth = ((kScreenWidth - leftWidth) / (NUM - 1))-1;
            frame.origin.x = leftWidth + rightWidth * (i-1)+i;
            frame.size.width = rightWidth;
            title.frame= CGRectMake(frame.origin.x,0, rightWidth, 30);
            title.text = _totalTiltle[i];
            title.font = [UIFont systemFontOfSize:14];
        }else{
            CGFloat rightWidth = ((kScreenWidth - leftWidth) / (NUM - 1))-1;
            frame.origin.x = leftWidth + rightWidth * (i-1)+i;
            frame.size.width = rightWidth;
            title.frame= CGRectMake(frame.origin.x,0, rightWidth, 30);
            title.text = _totalTiltle[i];
            title.font = [UIFont systemFontOfSize:14];
        }
        tableView.backgroundColor = [UIColor whiteColor];
        frame.size.height = self.frame.size.height-30;
        tableView.frame = frame;
        [backgroundView addSubview:title];
    }
}
#pragma mark - 设置选中的cell
- (void)selectRowWithSelectedIndex:(NSInteger *)selectIndex {
    
    for (int i=0; i<NUM; i++) {
        
        UITableView *tableView = tableViewArr[i];
        
        if (selectIndex[i]!=-1) {
            
            [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex[i] inSection:0]];
        }
  
    }
}

@end

