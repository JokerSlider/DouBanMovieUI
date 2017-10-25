//
//  PhotoWallIndexViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhotoWallIndexViewController.h"
#import "CCDraggableContainer.h"
#import "PhotoCarView.h"
#import "SDAutoLayout.h"
#import "HYAwesomeTransition.h"
#import "PhotoWallDetailViewController.h"
#import "SQMenuShowView.h"
#import "JKImagePickerController.h"
#import "MyFlowerListViewController.h"
#import "FlowerListViewController.h"
#import "PECropViewController.h"
#import "PhotoWallSendViewController.h"
#import <YYModel.h>
#import "SendFlowerView.h"
#import "XGAlertView.h"
#import "EditMymessageController.h"

@interface PhotoWallIndexViewController ()<CCDraggableContainerDataSource,CCDraggableContainerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate,JKImagePickerControllerDelegate,PECropViewControllerDelegate>

@property (nonatomic, strong) CCDraggableContainer *container;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;

@property (nonatomic, strong)HYAwesomeTransition *awesometransition; //转场动画

@property (nonatomic, strong) UIControl *backView;
@property (nonatomic, strong) NSMutableArray   *assetsArray;


@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation PhotoWallIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"照片墙";
    
    [self createViews];
    _dataSources = [NSMutableArray array];
    _pageNum = 1;
    [self loadData];

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(show)];
    WEAKSELF;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        weakSelf.backView.hidden = YES;
        NSLog(@"点击第%ld个item",index+1);
        switch (index) {
            case 0:
            {
                [self composePicAdd];
            }
                break;
            case 1:
            {
                [self openMyflowerPhotoWall];
            }
                break;
                case 2:
            {
                [self openflowerListVC];
            }
                break;
            default:
                break;
        }
    }];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppUserIndex *user = [AppUserIndex GetInstance];
    if ([user.headImageUrl isEqualToString:@""] || [user.nickName isEqualToString:@""]) {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"请先设置昵称和头像后使用！" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
        alert.isBackClick = YES;
        alert.tag = 101;
        [alert show];
        return;
    }
}

- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    if (view.tag == 101) {
        EditMymessageController *vc = [[EditMymessageController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(XGAlertView *)view didClickCancel:(NSString *)title{
    if (view.tag == 101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//我的个人中心
-(void)openMyflowerPhotoWall
{
    MyFlowerListViewController *vc = [[MyFlowerListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//排行榜
-(void)openflowerListVC
{
    FlowerListViewController *vc = [[FlowerListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)createViews{
    UIButton *flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flowerBtn setImage:[UIImage imageNamed:@"photoWall_flower_btn"] forState:UIControlStateNormal];
    [flowerBtn addTarget:self action:@selector(flowerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flowerBtn];
    
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgBtn setImage:[UIImage imageNamed:@"photoWall_liuyan"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:msgBtn];
    
    self.container = [[CCDraggableContainer alloc] initWithFrame:CGRectMake(0, 0, CCWidth, (kScreenHeight-64)*0.78) style:CCDraggableStyleDownOverlay];
    self.container.delegate = self;
    self.container.dataSource = self;
    [self.view addSubview:self.container];

    
    flowerBtn.sd_layout
    .topSpaceToView(_container,LayoutHeightCGFloat(12))
    .leftSpaceToView(self.view,LayoutWidthCGFloat(64))
    .widthIs(LayoutHeightCGFloat(76))
    .heightIs(LayoutHeightCGFloat(76));
    
    msgBtn.sd_layout
    .topSpaceToView(_container,LayoutHeightCGFloat(12))
    .rightSpaceToView(self.view,LayoutWidthCGFloat(64))
    .widthIs(LayoutHeightCGFloat(76))
    .heightIs(LayoutHeightCGFloat(76));
}

- (SQMenuShowView *)showView{
    
    if (_showView) {
        return _showView;
    }
    
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){kScreenWidth-113-10,5,113,0}
                                               items:@[@[@"我要发布",@"个人主页",@"排行榜单"],@[@"photoWall_publish",@"photoWall_photo_my",@"photoWall_rank"]]
                                           showPoint:(CGPoint){kScreenWidth-25,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    _showView.sq_selectColor = [UIColor whiteColor];
    
    
    _backView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_backView addTarget:self action:@selector(tapViewAction) forControlEvents:UIControlEventTouchUpInside];
    _backView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    _backView.hidden = YES;
    [self.view addSubview:_backView];
    [_backView addSubview:_showView];
    return _showView;
}

- (void)tapViewAction{
    _isShow = NO;
    [self.showView dismissView];
    _backView.hidden = YES;
}

- (void)show{
    _isShow = !_isShow;
    
    if (_isShow) {
        [self.showView showView];
        _backView.hidden = NO;
    }else{
        [self.showView dismissView];
        _backView.hidden = YES;
    }
    
}

- (void)loadData {
    
    NSDictionary *commitDic = @{
                                @"rid":@"findPhotowallInfo",
                                @"page":@(_pageNum),
                                @"pageCount":@"10"
                                };
    
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {

        for (NSDictionary *dic in responseObject[@"data"]) {
            PhotoCarModel *model = [[PhotoCarModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataSources addObject:model];

        }
        if (_pageNum==1) {
            [self.container reloadData];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
    
}

#pragma mark - CCDraggableContainer DataSource

- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    
    if (index == (5+(_pageNum-1)*10)) {
        _pageNum++;
        [self loadData];
    }
    PhotoCarView *cardView = [[PhotoCarView alloc] initWithFrame:draggableContainer.bounds];

    cardView.model = [_dataSources objectAtIndex:index];
    return cardView;
}

- (NSInteger)numberOfIndexs {
    return _dataSources.count;
}

#pragma mark - CCDraggableContainer Delegate

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
//    CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
    if (draggableDirection == CCDraggableDirectionLeft) {
//        self.disLikeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (draggableDirection == CCDraggableDirectionRight) {
//        self.likeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex {
    
    PhotoWallDetailViewController *vc = [[PhotoWallDetailViewController alloc] init];

    NSLog(@"点击了Tag为%ld的Card", (long)didSelectIndex);
    vc.model = _dataSources[didSelectIndex];
    vc.carView = _container.currentCards[0];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    if (_dataSources.count > 0 ) {
        [draggableContainer reloadData];
        _pageNum = 1;
        [self loadData];
    }
//
    
//
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)flowerBtnAction:(UIButton *)sender{
    if (_container.currentCards.count < 1) {
        return;
    }
    PhotoCarView *cardView = _container.currentCards[0];
    PhotoCarModel *model = _dataSources[cardView.tag];
    NSLog(@"%ld",cardView.tag);
    SendFlowerView *view = [[SendFlowerView alloc] init];
    view.model = model;
    view.sendFlowerBlock = ^(SendFlowerView *sendView,PhotoCarModel *model){
        cardView.model = model;
    };
    
    [self.view addSubview:view];
}

- (void)messageBtnAction:(UIButton *)sender{
    if (_container.currentCards.count < 1) {
        return;
    }
    PhotoCarView *cardView = _container.currentCards[0];

    PhotoWallDetailViewController *vc = [[PhotoWallDetailViewController alloc] init];
    
    vc.model = _dataSources[cardView.tag];
    vc.carView = cardView;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma Mark JKImagePikcer
- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = NO;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
//    imagePickerController.selectedAssetArray = self.assetsArray;
    imagePickerController.filterType = JKImagePickerControllerFilterTypePhotos;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    if ([assets count]<1) {
        return;
    }
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    JKAssets *selAsset = assets[0];
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:selAsset.assetPropertyURL resultBlock:^(ALAsset *asset) {
        if (asset) {
            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            [self openCaijian:image];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)openCaijian:(UIImage *)originImage{
    //打开图片剪裁
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = originImage;
    
    UIImage *image = originImage;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    controller.keepingCropAspectRatio = YES; //保持等比例
    controller.toolbarHidden = YES; //隐藏底部工具栏
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //    self.imageView.image = croppedImage;
    PhotoWallSendViewController *vc = [[PhotoWallSendViewController alloc] init];
    vc.image = croppedImage;
    vc.indexVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        [self updateEditButtonEnabled];
    //    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
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
