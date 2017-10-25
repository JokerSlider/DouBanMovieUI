//
//  OAMainCell.m
//  CSchool
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAMainCell.h"
#import "OAModel.h"
#import "UIView+SDAutoLayout.h"
#import "YLButton.h"
#import "PushprocedureController.h"
#import "UIView+UIViewController.h"
#import "YLButton.h"
#import "MyPushProController.h"
@interface   OAMainCell()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@end
@implementation OAMainCell
{
    NSMutableArray *_modelArr;
    UIImageView *_iconImage;
    UILabel *_titleL;
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
#pragma mark 创建视图
-(void)createView
{
    _iconImage= ({
        UIImageView *view = [UIImageView new];
        view;
    });
    _titleL = ({
        UILabel *view  = [UILabel new];
        view.font = Title_Font;
        view.textColor = RGB(85, 85, 85);
        view;
    });
    [self.contentView sd_addSubviews:@[_iconImage,_titleL]];
    
    _iconImage.sd_layout.leftSpaceToView(self.contentView,13).topSpaceToView(self.contentView,10).widthIs(15).heightIs(15);
    _titleL.sd_layout.leftSpaceToView(_iconImage,5).topSpaceToView(self.contentView,10).widthIs(100).heightIs(15);
}
#pragma mark 加载数据
-(void)setModel:(OAModel *)model
{
    _model = model;
   
    _modelArr = [NSMutableArray array];
    for (NSDictionary *dic in model.data) {
        OAModel *model = [[OAModel alloc]init];
        [model yy_modelSetWithDictionary:dic];
        [_modelArr addObject:model];
    }
    
    if (!model.icon_xh||model.icon_xh.length == 0) {
        model.icon_xh = @"4";
    }
    [_iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"OA_z%d",[model.icon_xh intValue] -1000+1]]];
    [_titleL setText:model.mi_name];
    
    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 15)];
    _titleL.sd_layout.widthIs(size.width);
    //布局控件
    [self setFaceFrame:_modelArr];
}
- (void)setFaceFrame:(NSArray *)functionArr
 {
    
    //列数
     NSInteger colFaces = 4;
    //行数
     NSInteger rowFaces = 2;
     //设置face按钮frame
     CGFloat FaceW = 80;//按钮宽
     CGFloat FaceH = 60;//按钮高
     CGFloat marginX = (kScreenWidth - colFaces * FaceW) / (colFaces + 1);
     CGFloat marginY = (280-rowFaces*FaceH)/(rowFaces+1);
    //表情数量
    NSInteger FaceCount = functionArr.count;
    //每页表情数和scrollView页数；
     NSInteger PageFaceCount = colFaces * rowFaces ;//8 个
     
     NSInteger SCPages = FaceCount / PageFaceCount +1  ;//页数
     if (FaceCount==PageFaceCount) {
         SCPages = 1;
     }
     CGFloat scViewH = 280;//rowFaces * (FaceH + marginY) + marginY*2 + 10;
    //初始化scrollView
     self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, scViewH)];
     self.scrollView.contentSize = CGSizeMake(kScreenWidth * SCPages, scViewH);
     self.scrollView.pagingEnabled = YES;
     self.scrollView.bounces = NO;
     self.scrollView.delegate = self;
     self.scrollView.showsVerticalScrollIndicator = NO;
     self.scrollView.showsHorizontalScrollIndicator = NO;
     self.scrollView.userInteractionEnabled = YES;
     [self.contentView addSubview:self.scrollView];
    //初始化贴在sc上的view
     UIView * BtnView = [[UIView alloc] init];
     BtnView.userInteractionEnabled = YES;
     BtnView.frame = CGRectMake(0, 0, kScreenWidth * SCPages, scViewH);
     [self setupAutoHeightWithBottomView:BtnView bottomMargin:10];

     [self.scrollView addSubview:BtnView];
     for (NSInteger i = 0; i < FaceCount; i ++)
        {
            //当前页数
            NSInteger currentPage = i / PageFaceCount;
            //当前行
            NSInteger rowIndex = i / colFaces - (currentPage * rowFaces);
            //当前列
            NSInteger colIndex = i % colFaces;
            //viewW * currentPage换页
            CGFloat btnX = marginX + colIndex * (FaceW + marginX) + kScreenWidth * currentPage;
            
            CGFloat btnY = rowIndex * (marginY + FaceH) + marginY;
            
            YLButton * funtionBtn = [YLButton buttonWithType:UIButtonTypeCustom];
            
            funtionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            
            [funtionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            funtionBtn.imageRect = CGRectMake(25, 0, 30, 30);
            
            funtionBtn.titleRect = CGRectMake(0, 35, 80, 30);
            
            [funtionBtn.titleLabel setNumberOfLines:0];
            
            [funtionBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            funtionBtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
            
            funtionBtn.frame = CGRectMake(btnX, btnY, FaceW, FaceH);
            
            OAModel *model = functionArr[i];
                 
            [funtionBtn setTitle:model.mi_name forState:UIControlStateNormal];
            
            NSString *imageName = [NSString stringWithFormat:@"OA_%@",model.icon_xh];//流程名   取名
            
            [funtionBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
            [funtionBtn addTarget:self action:@selector(openProcedureVC:) forControlEvents:UIControlEventTouchUpInside];
            
            funtionBtn.tag = i;
            
            [BtnView addSubview:funtionBtn];
        }
     
        CGFloat pageH = 10;
        CGFloat pageW = kScreenWidth;
        CGFloat pageX = 0;
        CGFloat pageY = scViewH - pageH - marginY;
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageX, pageY, pageW, pageH)];
        self.pageControl.numberOfPages = SCPages;
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        [self.contentView addSubview:self.pageControl];
        if (SCPages==1) {
            self.pageControl.hidden = YES;
        }

        _pageControl.sd_layout.rightSpaceToView(self.contentView,20).bottomSpaceToView(self.contentView,10).widthIs(50).heightIs(10);

}
#pragma mark -UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    self.pageControl.currentPage = page;
    
}
#pragma mark 打开指定页面
-(void)openProcedureVC:(UIButton *)sender{
    if (![_model.mi_state boolValue]) {
        [JohnAlertManager showFailedAlert:@"暂无权限使用" andTitle:@"提示"];
        return;
    }
    [self openListView:(int)sender.tag];
    /** 
     
    暂时隐藏掉发起功能
    PushprocedureController *vc = [PushprocedureController new];
    vc.fid = @"1";
    [self.viewController.navigationController pushViewController:vc animated:YES];
     **/
}

-(void)openListView:(int)index
{
    //打开列表页面  进行筛选
    MyPushProController  *vc = [MyPushProController new];
    OAModel *model = _modelArr[index];
    vc.procedureName = model.mi_name;
    vc.procedureID = model.fi_id;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
