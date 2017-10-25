//
//  SchoolMapRouteViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/7/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SchoolMapRouteViewController.h"
#import "SpeechSynthesizer.h"
#import "NaviPointAnnotation.h"
#import "SelectableOverlay.h"
#import "RouteCollectionViewCell.h"
#import "DriveNaviViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MapInfoView.h"
#import "SDAutoLayout.h"

#import "SchoolPointAnnotation.h"

#define kRoutePlanInfoViewHeight    90.f
#define kRouteIndicatorViewHeight   64.f
#define kCollectionCellIdentifier   @"kCollectionCellIdentifier"

#define MAP_TYPE @{@"宿舍":@"1",@"教学楼":@"2",@"商店":@"3",@"餐厅":@"4",@"其他":@"5"};

@interface SchoolMapRouteViewController ()<MAMapViewDelegate, AMapNaviWalkManagerDelegate, DriveNaviViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITabBarDelegate>

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic, strong) UICollectionView *routeIndicatorView;
@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;
@property (nonatomic, assign) BOOL isClick;

@property (nonatomic, strong) MapInfoView *infoView;
@property (nonatomic, strong) UITabBar *tabBar;

@property (nonatomic, strong) NSMutableArray *currentAnniArray;

@property (nonatomic, strong) NSString *mapType;
@end

@implementation SchoolMapRouteViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"校园地图";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initProperties];
    
    [self initMapView];
    
    [self initDriveManager];
    
//    [self ininAnninInfo];
//    [self configSubViews];
    
    [self createFlyBtn];
    
    [self initRouteIndicatorView];
    
    [self createButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)loadData{
//    _mapType = @"";
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showMapAnnotationInfo",@"type":_mapType} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _currentAnniArray = [NSMutableArray array];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            SchoolPointAnnotation *pointAnnotation = [[SchoolPointAnnotation alloc] init];
            pointAnnotation.dataDic = dic;
            [_currentAnniArray addObject:pointAnnotation];
        }
        
        [_mapView addAnnotations:_currentAnniArray];
        
        //设置地图的中心
        if (_currentAnniArray.count > 0) {
            MAPointAnnotation *pointAnnotation = _currentAnniArray[0];
            _mapView.centerCoordinate = pointAnnotation.coordinate;
        }else{
            [ProgressHUD showError:@"暂无数据"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:@"网络异常"];

    }];
}

- (void)ininAnninInfo{
    _currentAnniArray = [NSMutableArray array];
    
    NSArray *latitudeArr = @[@"36.6846930000",@"36.6841810000",@"36.6838410000",@"36.6850750000"];
    NSArray *longitudeArr = @[@"117.1817990000",@"117.1817130000",@"117.1817720000",@"117.1817020000"];
    
    NSDictionary *dic0 = @{@"name":@"建大购物中心",@"des":@"建大购物中心建大购物中心建大购物中心建大购物中心建大购物中心建大购物中心建大购物中心建大购物中心建大购物中心建大购物中心建大购物中心建大购物中心"};
    
    NSDictionary *dic1 = @{@"name":@"万家隆超市",@"des":@"万家隆超市万家隆超市万家隆超市万家隆超市万家隆超市万家隆超市"};
    NSDictionary *dic2 = @{@"name":@"家家悦",@"des":@"家家悦家家悦家家悦家家悦家家悦家家悦"};
    NSDictionary *dic3 = @{@"name":@"商业街",@"des":@"商业街商业街商业街商业街商业街"};
    
    NSArray *arr = @[dic0,dic1,dic2,dic3];

    for (int i=0; i<latitudeArr.count; i++) {
        SchoolPointAnnotation *pointAnnotation = [[SchoolPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([latitudeArr[i] floatValue], [longitudeArr[i] floatValue]);
        pointAnnotation.title = @"顶联信息";
        pointAnnotation.subtitle = @"经十路";
        pointAnnotation.dataDic = arr[i];
        [_currentAnniArray addObject:pointAnnotation];
    }
}
//创建底部按钮
- (void)createButtons{
    NSInteger btnCount = 5;

    NSArray *titleArr = @[@"商店",@"餐厅",@"宿舍",@"教学楼",@"其他"];
    NSArray *imageArr = @[@"map_store",@"map_rest",@"map_zhu",@"map_jioa",@"map_else"];
    NSArray *selImageArr = @[@"map_store2",@"map_rest2",@"map_zhu2",@"map_jioa2",@"map_else"];
    NSMutableArray *itemsArray = [NSMutableArray array];
    for (int i=0; i<btnCount; i++) {
        
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:titleArr[i] image:[UIImage imageNamed:imageArr[i]] selectedImage:[UIImage imageNamed:selImageArr[i]]];
        tabItem.tag = i;
        
        [itemsArray addObject:tabItem];
    }
    
    
    _tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-49, kScreenWidth, 49)];
    [_tabBar setItems:itemsArray];
    _tabBar.delegate = self;
    [self.view addSubview:_tabBar];
    
    _infoView = [[MapInfoView alloc] init];
    WEAKSELF;
    _infoView.goBtnClickBlock = ^(NSDictionary *dataDic){
        [weakSelf routePlanAction:nil];
    };
    [self.view addSubview:_infoView];
    _infoView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);
    _infoView.hidden = YES;
}

- (void)createFlyBtn{
    
    UIButton *baodaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [baodaoBtn setImage:[UIImage imageNamed:@"map_s"] forState:UIControlStateNormal];
    baodaoBtn.frame = CGRectMake(kScreenWidth-80, LayoutHeightCGFloat(150), 60, 60);
    [baodaoBtn addTarget:self action:@selector(loadYinxinInfo:) forControlEvents:UIControlEventTouchUpInside];
    baodaoBtn.tag = 2000;
    [self.view addSubview:baodaoBtn];
    
    UIButton *susheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [susheBtn setImage:[UIImage imageNamed:@"map_q"] forState:UIControlStateNormal];
    susheBtn.frame = CGRectMake(kScreenWidth-80,  LayoutHeightCGFloat(230), 60, 60);
    [susheBtn addTarget:self action:@selector(loadYinxinInfo:) forControlEvents:UIControlEventTouchUpInside];
    susheBtn.tag = 2001;
    [self.view addSubview:susheBtn];
}

- (void)loadYinxinInfo:(UIButton *)sender{
    NSString *name = @"";
    NSInteger type = sender.tag - 2000;
    if (sender.tag == 2000) {
        name = [AppUserIndex GetInstance].XYMC;
    }else if (sender.tag == 2001){
        name = [AppUserIndex GetInstance].SSLH;
    }
    [_mapView removeAnnotations:_currentAnniArray];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getPlaceLongLat", @"name":name, @"type":@(type)} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        _currentAnniArray = [NSMutableArray array];
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            SchoolPointAnnotation *pointAnnotation = [[SchoolPointAnnotation alloc] init];
            pointAnnotation.dataDic = responseObject[@"data"];
            [_currentAnniArray addObject:pointAnnotation];
        }
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            SchoolPointAnnotation *pointAnnotation = [[SchoolPointAnnotation alloc] init];
            pointAnnotation.dataDic = dic;
            [_currentAnniArray addObject:pointAnnotation];
        }

        
        [_mapView addAnnotations:_currentAnniArray];
        
        //设置地图的中心
        if (_currentAnniArray.count > 0) {
            MAPointAnnotation *pointAnnotation = _currentAnniArray[0];
            _mapView.centerCoordinate = pointAnnotation.coordinate;
        }else{
            [ProgressHUD showError:@"暂无数据"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)initProperties
{
    //为了方便展示驾车多路径规划，选择了固定的起终点
    self.startPoint = [AMapNaviPoint locationWithLatitude:36.657463 longitude:117.124450];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:36.667463 longitude:117.315495];
    self.routeIndicatorInfoArray = [NSMutableArray array];
}

//初始化地图
- (void)initMapView
{
    if (self.mapView == nil)
    {
        [AMapServices sharedServices].apiKey = @"5137fcb4d6c0f296636cde19e04fa725";

        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height)];
        [self.mapView setDelegate:self];
        
        self.mapView.zoomLevel = 15;
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
//        _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
        [self.view addSubview:self.mapView];
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }else{
//        view.image = [UIImage imageNamed:@"map_locate"];
    }
}

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviWalkManager alloc] init];
        [self.driveManager setDelegate:self];
    }
}

- (void)initRouteIndicatorView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _routeIndicatorView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - kRouteIndicatorViewHeight, CGRectGetWidth(self.view.bounds), kRouteIndicatorViewHeight) collectionViewLayout:layout];
    
    _routeIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _routeIndicatorView.backgroundColor = [UIColor clearColor];
    _routeIndicatorView.pagingEnabled = YES;
    _routeIndicatorView.showsVerticalScrollIndicator = NO;
    _routeIndicatorView.showsHorizontalScrollIndicator = NO;
    
    _routeIndicatorView.delegate = self;
    _routeIndicatorView.dataSource = self;
    
    [_routeIndicatorView registerClass:[RouteCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
    
    [self.view addSubview:_routeIndicatorView];
}

//初始化坐标大头针
- (void)initAnnotations
{
    NaviPointAnnotation *beginAnnotation = [[NaviPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude)];
    beginAnnotation.title = @"起始点";
    beginAnnotation.navPointType = NaviPointAnnotationStart;
    
    [self.mapView addAnnotation:beginAnnotation];
    
    NaviPointAnnotation *endAnnotation = [[NaviPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude)];
    endAnnotation.title = @"终点";
    endAnnotation.navPointType = NaviPointAnnotationEnd;
    
    [self.mapView addAnnotation:endAnnotation];
}

#pragma mark - SubViews

- (void)configSubViews
{
    UILabel *startPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.bounds), 20)];
    
    startPointLabel.textAlignment = NSTextAlignmentCenter;
    startPointLabel.font = [UIFont systemFontOfSize:14];
    startPointLabel.text = [NSString stringWithFormat:@"起 点：%f, %f", self.startPoint.latitude, self.startPoint.longitude];
    
    [self.view addSubview:startPointLabel];
    
    UILabel *endPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.bounds), 20)];
    
    endPointLabel.textAlignment = NSTextAlignmentCenter;
    endPointLabel.font = [UIFont systemFontOfSize:14];
    endPointLabel.text = [NSString stringWithFormat:@"终 点：%f, %f", self.endPoint.latitude, self.endPoint.longitude];
    
    [self.view addSubview:endPointLabel];
    
    UIButton *routeBtn = [self createToolButton];
    [routeBtn setFrame:CGRectMake((CGRectGetWidth(self.view.bounds)-80)/2.0, 55, 80, 30)];
    [routeBtn setTitle:@"路径规划" forState:UIControlStateNormal];
    [routeBtn addTarget:self action:@selector(routePlanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:routeBtn];
}

- (UIButton *)createToolButton
{
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    toolBtn.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    toolBtn.layer.borderWidth  = 0.5;
    toolBtn.layer.cornerRadius = 5;
    
    [toolBtn setBounds:CGRectMake(0, 0, 80, 30)];
    [toolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    toolBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    return toolBtn;
}

#pragma mark - Button Action

- (void)routePlanAction:(id)sender
{
//    [self initAnnotations];
    if (_mapView.userLocation.location) {
        _isClick = NO;
        //规划路线 起点--终点
        //    [self.driveManager calculateWalkRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]];
        [self.driveManager calculateWalkRouteWithEndPoints:@[self.endPoint]];
    }else{
        [ProgressHUD showError:@"没有定位权限，请检查定位服务权限。"];
    }
    
}

#pragma mark - Handle Navi Routes

- (void)showNaviRoutes
{
    if (!self.driveManager.naviRoute)
    {
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
//    [self removeNaviRoutes];
    AMapNaviRoute *aRoute = self.driveManager.naviRoute;
    int count = (int)[[aRoute routeCoordinates] count];
    
    //添加路径Polyline
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++)
    {
        AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
        coords[i].latitude = [coordinate latitude];
        coords[i].longitude = [coordinate longitude];
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    
    SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
    [selectablePolyline setRouteID:self.driveManager.naviRouteID];
    
    [self.mapView addOverlay:selectablePolyline];
    free(coords);
    
    
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
    [self.routeIndicatorView reloadData];
    
    [self selectNaviRouteWithID:self.driveManager.naviRouteID];
}

- (void)removeNaviRoutes{
    //移除路径规划的路线
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (void)selectNaviRouteWithID:(NSInteger)routeID
{
    if ([self.driveManager recalculateWalkRoute])
    {
        [self selecteOverlayWithRouteID:routeID];
    }
    else
    {
        NSLog(@"路径选择失败!");
    }
}

//根据id设置路线样式
- (void)selecteOverlayWithRouteID:(NSInteger)routeID
{
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
         if ([overlay isKindOfClass:[SelectableOverlay class]])
         {
             SelectableOverlay *selectableOverlay = overlay;
             
             /* 获取overlay对应的renderer. */
             MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
             
             if (selectableOverlay.routeID == routeID)
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = YES;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                 overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                 
                 /* 修改overlay覆盖的顺序. */
                 [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
             }
             else
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = NO;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.regularColor;
                 overlayRenderer.strokeColor = selectableOverlay.regularColor;
             }
             
             //             [overlayRenderer glRender];
         }
     }];
    
}


#pragma mark waldManager delegate

/**
 *  发生错误时,会调用代理的此方法
 *
 *  @param error 错误信息
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager error:(NSError *)error{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

/**
 *  步行路径规划成功后的回调函数
 */
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager{
    NSLog(@"onCalculateRouteSuccess");
    
#warning 这里规划成功后会一直调用，先用BOOL值进行约束。需要排查原因
    if (!_isClick) {
        [self showNaviRoutes];
        _isClick = YES;
    }
    
}
    

/**
 *  步行路径规划失败后的回调函数
 *
 *  @param error 错误信息,error.code参照AMapNaviCalcRouteState
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

/**
 *  启动导航后回调函数
 *
 *  @param naviMode 导航类型，参考AMapNaviMode
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager didStartNavi:(AMapNaviMode)naviMode{

}

/**
 *  出现偏航需要重新计算路径时的回调函数
 */
- (void)walkManagerNeedRecalculateRouteForYaw:(AMapNaviWalkManager *)walkManager{

}

/**
 *  导航播报信息回调函数
 *
 *  @param soundString 播报文字
 *  @param soundStringType 播报类型,参考AMapNaviSoundType
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType{
}

/**
 *  模拟导航到达目的地停止导航后的回调函数
 */
- (void)walkManagerDidEndEmulatorNavi:(AMapNaviWalkManager *)walkManager{

}

/**
 *  导航到达目的地后的回调函数
 */
- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager;{

}

#pragma mark - DriveNaviView Delegate

- (void)driveNaviViewCloseButtonClicked
{
    //开始导航后不再允许选择路径，所以停止导航
    [self.driveManager stopNavi];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return self.routeIndicatorInfoArray.count;
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RouteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    
    cell.shouldShowPrevIndicator = (indexPath.row > 0 && indexPath.row < _routeIndicatorInfoArray.count);
    cell.shouldShowNextIndicator = (indexPath.row >= 0 && indexPath.row < _routeIndicatorInfoArray.count-1);
    cell.info = self.routeIndicatorInfoArray[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) - 10, CGRectGetHeight(collectionView.bounds));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DriveNaviViewController *driveVC = [[DriveNaviViewController alloc] init];
    [driveVC setDelegate:self];
    
    //将driveView添加到AMapNaviDriveManager中
    [self.driveManager addDataRepresentative:driveVC.driveView];
    
    [self.navigationController pushViewController:driveVC animated:NO];
    [self.driveManager startEmulatorNavi];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    RouteCollectionViewCell *cell = [[self.routeIndicatorView visibleCells] firstObject];
    
    if (cell.info)
    {
        [self selectNaviRouteWithID:cell.info.routeID];
    }
}

#pragma mark - MAMapView Delegate
//大头针视图代理
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NaviPointAnnotation class]]) //导航大头针
    {
        static NSString *annotationIdentifier = @"NaviPointAnnotationIdentifier";
        
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.draggable      = NO;
        
        NaviPointAnnotation *navAnnotation = (NaviPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NaviPointAnnotationStart)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
        }
        else if (navAnnotation.navPointType == NaviPointAnnotationEnd)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
        }
        
        return pointAnnotationView;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]) //普通大头针
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
//        annotationView.image = [UIImage imageNamed:@"map_locate"];
        return annotationView;
    }
    return nil;
}

/*!
 @brief 当选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([view.annotation isKindOfClass:[SchoolPointAnnotation class]]){
        _infoView.hidden = NO;
        SchoolPointAnnotation *annotation = view.annotation;
        self.endPoint   = [AMapNaviPoint locationWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
        self.infoView.dataDic = annotation.dataDic;
    }
}

/*!
 @brief 当取消选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    [self removeNaviRoutes];

    if (![view.annotation isKindOfClass:[MAUserLocation class]]){
        _infoView.hidden = YES;
    }
    
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[SelectableOverlay class]])
    {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma  mark UITabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
   
    
    [_mapView removeAnnotations:_currentAnniArray];
//    _mapType = [MAP_TYPE objectForKey:@""];
    NSDictionary *dic = MAP_TYPE;
    _mapType = dic[item.title];
    [self loadData];
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
