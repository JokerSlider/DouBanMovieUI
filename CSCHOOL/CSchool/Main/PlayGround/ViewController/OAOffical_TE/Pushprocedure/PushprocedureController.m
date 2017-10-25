//
//  PushprocedureController.m
//  CSchool
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "PushprocedureController.h"
#import "OAModel.h"
#import "YYModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OAInputCell.h"
#import "OAPushFooterView.h"
#import "OAChoseNodeController.h"

@interface PushprocedureController ()<UITableViewDelegate,UITableViewDataSource,OAPushDelegate>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic,strong)NSMutableArray *ListArr;
@property (nonatomic,strong)NSMutableArray *keyArr;

@property (nonatomic,copy)NSString *contentStr;
@end

@implementation PushprocedureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写流程信息";
    [self loadData];
    [self createView];
    self.view.backgroundColor = Base_Color2;
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource =self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.backgroundColor = Base_Color2;
    [self.view addSubview:self.mainTableView];

    OAPushFooterView *footerview = [[OAPushFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerview.delegate = self;
    self.mainTableView.tableFooterView = footerview;

    
}
//加载数据
-(void)loadData
{
    _ListArr = [NSMutableArray array];
    _keyArr = [NSMutableArray array];
    NSArray *souresArr;
    if (_isEdit) {
        souresArr = _listMArr;
    }else{
        [ProgressHUD show:@"正在加载..."];
        _modelArr = [NSMutableArray array];
        NSString *url = [NSString stringWithFormat:@"%@/getFlowForm",OABase_URL];

        [NetworkCore requestMD5POST:url parameters:@{@"scode":[AppUserIndex GetInstance].schoolCode,@"fid":@"1"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            NSLog(@"%@",responseObject);
            for (NSDictionary *dicObj in responseObject) {
                OAModel *model = [[OAModel alloc]init];
                [model yy_modelSetWithDictionary:dicObj];
                [_modelArr addObject:model];
            }
            [self.mainTableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            NSLog(@"%@",error);
            [JohnAlertManager showFailedAlert:error[@"content"] andTitle:@"提示"];
        }];
    }
}

#pragma mark  Delegate and  DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OAModel *model = _modelArr[indexPath.row];
    static NSString *cellID = @"OAselectCell";
    OAInputCell   *cell =[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OAInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.inputText.tag = indexPath.row;
  
    cell.selectEndBlock = ^(NSString *text,NSString *ID,NSInteger index){
        NSLog(@"输入的字符串:%@,下标:%ld",text,(long)index);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *key = model.filedName;
        model.filedSubTitle = text;
        [dic setValue:text forKey:key];
        NSMutableArray *listtmpArr = [NSMutableArray arrayWithArray:_ListArr];
        
        if ([_keyArr containsObject:key]) {
            NSInteger Objindex = [_keyArr indexOfObject:key];
            [listtmpArr replaceObjectAtIndex:Objindex withObject:dic];
            _ListArr = listtmpArr;
            
        }else{
            [_ListArr addObject:dic];
            [_keyArr addObject:key];
        }

    };
    return cell;
}

#pragma mark OAPushDelegate
-(void)pushProdure:(UIButton *)sender
{
    //编辑的时候回调
    if (_isEdit) {
        if (_oaEditBlock) {
            if (_ListArr.count>0) {
                for (NSDictionary *dic in _ListArr) {
                    for (NSString *key in dic) {
                        int  index = [key intValue];
                        NSString *value = dic[key];
                        OAModel *model = _modelArr[index];
                        [_modelArr replaceObjectAtIndex:index withObject:model];
                    }
                }
                _oaEditBlock(_modelArr);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else{
        //
        [self appendingString];
        return;
        
        OAChoseNodeController   *vc = [[OAChoseNodeController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        NSLog(@"%@",_ListArr);
        if (_ListArr.count<_modelArr.count) {
            [JohnAlertManager showFailedAlert:@"请将表格填全!" andTitle:@"提示"];
            return;
        }else{
            //选择转交部门
            OAChoseNodeController   *vc = [[OAChoseNodeController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    
    }
}
/*
 
 bz^^df=-=chry^^=-=fwxm^^=-=hylx^^2**1=-=hymc^^=-=hyrs^^=-=hysmc^^11636-单乐乐=-=jssj^^2017-07-11 12:00=-=kssj^^2017-07-11 08:30=-=lxfs^^=-=lxr^^12764-李伟=-=shb^^=-=zbdw^^100004-党委宣传部=-=zcr^^=-=zynr^^3
 
 key^^value， =-=(中间的间隔)，  value中带**表示复选框选的两个值，bm^^11636-测试部门1,11636-测试部门1       user^^11636-单乐乐,11636-单乐乐
 */
//拼接字符串
-(void)appendingString{
    NSLog(@"%@",_listMArr);
}
//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 50;
    Class currentClass = [OAInputCell class];
    OAModel *model = _modelArr[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
