//
//  ButtonAlertView.m
//  CPopView
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ButtonAlertView.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import "YLButton.h"
#import "LY_CircleButton.h"
#import "UIView+SDAutoLayout.h"
//#import "a"
#define Width  [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define marginX 40 //左右边距
#define marginY 40 //上下间距
#define Row     70 //水平间距

#define itemW   (Width-2*Row-marginX*2)/3.0
#define itemH   (Width-2*Row-marginX*2)/3.0+40
@implementation ButtonAlertView
{

    NSArray *_dataSouceArray;
    
    UIVisualEffectView *_bgImageView;
    UIImageView *_imageCC;
    UIScrollView *_mainScroView;
    UILabel *_myButtonTitle;//文件夹
    LY_CircleButton *_badgeV;
    NSMutableArray *_bgdgeViewArr;//角标数组


}
-(instancetype)initWithwithIconArr:(NSArray *)dataArr
{
    self = [super initWithFrame:CGRectMake(0, 0, Width, Height)];
    if (self) {
        _dataSouceArray = dataArr;
        [self loadSubViewswithDataSource];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleFuncMessage:) name:AllFunctionNotication object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAllFunction:) name:RemoveFunctionNotication object:nil];
    }
    return self;

}
-(void)setFileName:(NSString *)fileName
{
    _fileName = fileName;
    _myButtonTitle.text = _fileName;

}
-(void)loadSubViewswithDataSource
{
    _bgdgeViewArr = [NSMutableArray array];
    _bgImageView =({
        UIBlurEffect *light = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

        UIVisualEffectView  *view = [[UIVisualEffectView alloc] initWithEffect:light];
        view.frame = self.bounds;
        
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
        gester.numberOfTapsRequired = 1;
        [view addGestureRecognizer:gester];
        view.userInteractionEnabled = YES;
        view;
    });
    //大标题
    _myButtonTitle = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.font = [UIFont systemFontOfSize:30];
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    _mainScroView = ({
        UIScrollView *view = [UIScrollView new];
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissFromSuperMainScroView)];
        gester.numberOfTapsRequired = 1;
        [view addGestureRecognizer:gester];
        view;
    });
    [self addSubview:_bgImageView];
    [_bgImageView.contentView addSubview:_myButtonTitle];
    [_bgImageView.contentView addSubview:_mainScroView];
    _bgImageView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(self,0).bottomSpaceToView(self,0);
    _myButtonTitle.sd_layout.leftSpaceToView(_bgImageView.contentView,0).rightSpaceToView(_bgImageView.contentView,0).topSpaceToView(_bgImageView.contentView,90).heightIs(25);
    _mainScroView.sd_layout.leftSpaceToView(_bgImageView.contentView,0).rightSpaceToView(_bgImageView.contentView,0).topSpaceToView (_myButtonTitle,50).bottomSpaceToView(_bgImageView.contentView,0);
    [self addButton];
}
-(void)addButton
{
    int count;
    if (_dataSouceArray.count<3) {
        count = 1;
    }else{
        count = (int)_dataSouceArray.count/3;
    }
    //根据传入的图片数组进行初始化对应的点击item
        for (int j = 0; j<_dataSouceArray.count; j++) {
            
            UIView *item = [[UIView alloc] init];
            item.frame = CGRectMake(marginX +(Row+itemW)*(j%3), (itemH+marginY)*(j/3)+20, itemW+30, itemH);
            [_mainScroView addSubview:item];
            if (j == 0) {
                item.tag = 100+j;
            }else{
                item.tag = 10+j;
            }

            UIImageView *img = [UIImageView new ];
            NSDictionary *imageDic = _dataSouceArray[j];
            //new标示
//            UIImageView *newAppimage = [UIImageView new];
//            newAppimage.frame = CGRectMake(itemW-2, 0, 20, 9);
//            newAppimage.hidden = [imageDic[@"ai_id"] integerValue]-1==10?NO:YES;
//            newAppimage.hidden = YES;
//
//            [newAppimage setImage:[UIImage imageNamed:@"newApp"]];
//            [item addSubview:newAppimage];
//            
            NSInteger iconId = [imageDic[@"ai_id"] integerValue]-1;
            AppUserIndex *user = [AppUserIndex GetInstance];
            if (user.iconIDArray.count > iconId) {
            

            //            self.badgeV =  [[LY_CircleButton alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+24+imageView.frame.size.width, imageView.frame.origin.y+13/2, 13, 13)];

          
#ifdef isNewVer
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_new",user.iconIDArray[iconId]]];
#else
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",user.iconIDArray[iconId]]];
#endif
            }
            img.frame = CGRectMake(0, 0, itemW, itemW);
            img.layer.masksToBounds = YES;
            img.layer.cornerRadius = itemW/2;
            [item addSubview:img];
            _badgeV =  [[LY_CircleButton alloc]initWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width,img.frame.origin.y+10/2, 22, 13)];
            _badgeV.maxDistance = 30;
            _badgeV.hidden = YES;
            [_badgeV setBackgroundColor:[UIColor redColor]];
            _badgeV.layer.cornerRadius = _badgeV.bounds.size.width*0.5;
            _badgeV.titleLabel.font = [UIFont systemFontOfSize:9.0];
            [_badgeV setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _badgeV.layer.cornerRadius = _badgeV.bounds.size.height*0.5;
            _badgeV.layer.masksToBounds = YES;
            _badgeV.tag = iconId;
            [_badgeV addButtonAction:^(id sender) {
                LY_CircleButton *view =(LY_CircleButton *)sender;
                NSString *ai_id = [NSString stringWithFormat:@"%ld",view.tag];
                NSDictionary *dic = @{
                                      @"funcID":ai_id,
                                      @"msgNum":@"remove"
                                      };
                NSNotification *allFuncNote = [[NSNotification alloc]initWithName:RemoveFunctionNotication object:dic userInfo:nil];
                [[NSNotificationCenter defaultCenter]postNotification:allFuncNote];
                //将系统消息存档
                AppUserIndex *shareConfig = [AppUserIndex GetInstance];
                NSMutableArray *funcArr =[NSMutableArray arrayWithArray:shareConfig.funcMsgArr];
                [funcArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    if ([obj[@"funcID"] isEqualToString:ai_id]) {
                        // do sth
                        [funcArr removeObject:obj];
                        [funcArr addObject:dic];
                        *stop = YES;
                    }
                }];
                shareConfig.funcMsgArr = funcArr;
                [shareConfig saveToFile];
            }];
            [_bgdgeViewArr addObject:_badgeV];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, itemW+18, itemW, 15)];
            label.text = imageDic[@"ai_name"];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = RGB(85, 85, 85);
            [item addSubview:label];
            label.sd_layout.centerXIs(img.centerX);
            //UILabel 宽度自适应
            CGSize  size = [label boundingRectWithSize:CGSizeMake(0, 15)];
            label.sd_layout.widthIs(size.width);
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = item.bounds;
            [button setTitle:imageDic[@"ai_name"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            button.tag = iconId;
            //弹出的对应item的点击事件
            [button addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            [item addSubview:button];
            [_mainScroView setupAutoContentSizeWithBottomView:item bottomMargin:50];
            [item  addSubview:_badgeV];

        }
}
#pragma mark 处理全功能图
//处理全功能推送
-(void)handleFuncMessage:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    if (dict==nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        for (LY_CircleButton *view in _bgdgeViewArr) {
            if (view.tag == [dict[@"funcID"] intValue]) {
                view.hidden = NO;
                view.opaque = YES;
                NSString *msgNum = dict[@"msgNum"];
                if ([msgNum intValue]>99) {
                    msgNum = @"99+";
                    view.sd_layout.widthIs(22).heightIs(13);
                    view.layer.cornerRadius = view.bounds.size.height*0.5;
                }else if ([msgNum intValue]>0&&[msgNum intValue]<10){
                    view.sd_layout.widthIs(13).heightIs(13);
                    view.layer.cornerRadius = view.bounds.size.height*0.5;
                }else if ([msgNum intValue]>10&&[msgNum intValue]<99){
                    view.sd_layout.widthIs(21).heightIs(13);
                    view.layer.cornerRadius = view.bounds.size.height*0.5;
                }else{
                    msgNum=@"";
                    view.sd_layout.widthIs(8).heightIs(8);
                    view.layer.cornerRadius = view.bounds.size.height*0.5;
                }
                [view setTitle:msgNum forState:UIControlStateNormal];
                
            }
        }
        
    });
    
}
#pragma mark   移除全功能角标
-(void)removeAllFunction:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (LY_CircleButton *view in _bgdgeViewArr) {
            if (view.tag == [dict[@"funcID"] intValue]) {
                view.hidden = YES;
                view.opaque = NO;
                [self layoutSubviews];
                
            }
        }
    });
}

-(void)dissFromSuperMainScroView{
    [self dismissView];
    [self.delegate dissFromSuperMainScroView];
}

-(void)show
{
    self.frame = CGRectMake(0, Height, Width, Height);
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, 0, Width, Height);
    }];

}
-(void)dismissView
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect rect=self.frame;
        rect.origin.y=667;
        
        [UIView animateWithDuration:0.2f animations:^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.3f];
            self.alpha = 0.0f;
            [UIView commitAnimations];
            self.frame=rect;
        }];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

-(void)itemSelected:(UIButton *)sender{
    [self dismissView];
    [self.delegate itemDidSelected:sender];
    NSString *tag = [NSString stringWithFormat:@"%ld",sender.tag];
    NSDictionary *dic = @{
                          @"funcID":tag,
                          @"msgNum":@"remove"
                          };
    NSNotification *allFuncNote = [[NSNotification alloc]initWithName:RemoveFunctionNotication object:dic userInfo:nil];
    [self removeAllFunction:allFuncNote];
    [[NSNotificationCenter defaultCenter]postNotification:allFuncNote];
    
    AppUserIndex *shareConfig = [AppUserIndex GetInstance];
    NSMutableArray *funcArr =[NSMutableArray arrayWithArray:shareConfig.funcMsgArr];
    [funcArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"funcID"] isEqualToString:tag]) {
            // do sth
            [funcArr removeObject:obj];
            [funcArr addObject:dic];
            *stop = YES;
        }
    }];
    shareConfig.funcMsgArr = funcArr;
    [shareConfig saveToFile];
}



-(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AllFunctionNotication object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:RemoveFunctionNotication object:nil];

}

@end
