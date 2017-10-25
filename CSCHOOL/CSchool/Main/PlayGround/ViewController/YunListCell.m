//
//  YunListCell.m
//  CSchool
//
//  Created by 左俊鑫 on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunListCell.h"
#import "SDAutoLayout.h"
#import "YunListBottomView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XGWebDavManager.h"
#import "YYWebImage.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "YYCache.h"
#import "XGWebDavDownloadManager.h"
#import "UIView+UIViewController.h"
#import "YunFolderViewController.h"
#import "XGAlertView.h"
#import "LEOWebDAVClient.h"
#import "LEOWebDAVDeleteRequest.h"
#import "LPActionSheet.h"
#import "LEOWebDAVMoveRequest.h"

@implementation YunListCell
{
    UIImageView *_logoImageView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    UIButton *_selectButton;
    UIButton *_showButton;
    YunListBottomView *_bottomView;
    LEOWebDAVClient *_currentClient;
}

static YYCache *_dataCache;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.clipsToBounds = YES;
    
    _logoImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view;
    });
    
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view.lineBreakMode = NSLineBreakByTruncatingMiddle;
        view;
    });
    
    _subTitleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = Color_Gray;
        view;
    });
    
    _selectButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"pan_unselected"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"pan_select"] forState:UIControlStateSelected];
        view.clipsToBounds = YES;
        view;
    });
    
    _showButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"pan_down"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"pan_up"] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    WEAKSELF;
    _bottomView = ({
        YunListBottomView *view = [[YunListBottomView alloc] init];
        view.bottomClick = ^(UIButton *sender) {
            
        };
        view;
    });
    
    _bottomView.bottomClick = ^(UIButton *sender){
        if (sender.tag == 2) {
            XGWebDavDownloadManager *manager = [XGWebDavDownloadManager shareDownloadManager];
            [manager addDownload:_model];
        }else if (sender.tag == 3){
            XGAlertView *alert = [[XGAlertView alloc] initWithTarget:weakSelf withTitle:@"提示" withContent:@"确定要删除吗" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
            [alert show];
        }else if (sender.tag == 4) {
            
            [LPActionSheet showActionSheetWithTitle:@"请选择分类"
                                  cancelButtonTitle:@"取消"
                             destructiveButtonTitle:@""
                                  otherButtonTitles:@[@"复制",@"移动",@"重命名"]
                                            handler:^(LPActionSheet *actionSheet, NSInteger index) {
                                                NSLog(@"%ld",index);
                                                switch (index) {
                                                    case 1:
                                                    {
                                                        YunFolderViewController *vc = [[YunFolderViewController alloc] initWithPath:nil];
                                            
                                                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                            
                                                        vc.currentItem = weakSelf.model;
                                                        vc.yunFolderType = YunFolderCopy;
                                                        [weakSelf.viewController presentViewController:nav animated:YES completion:nil];
                                                    }
                                                        break;
                                                    case 2:
                                                    {
                                                        YunFolderViewController *vc = [[YunFolderViewController alloc] initWithPath:nil];
                                                        
                                                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                                        
                                                        vc.currentItem = weakSelf.model;
                                                        vc.yunFolderType = YunFolderMove;
                                                        [weakSelf.viewController presentViewController:nav animated:YES completion:nil];
                                                    }
                                                        break;
                                                    case 3:{
                                                        XGAlertView *alert = [[XGAlertView alloc] initWithTitle:@"请输入文件名" withUnit:@"" click:^(NSString *index){
                                                            NSString *ext = [weakSelf.model.displayName pathExtension];
                                                            
                                                            NSString *path = [[weakSelf.model.href stringByDeletingLastPathComponent] stringByAppendingPathComponent:index];
                                                            
                                                            if ([ext length] > 0) {
                                                                path = [NSString stringWithFormat:@"%@.%@",[[weakSelf.model.href stringByDeletingLastPathComponent] stringByAppendingPathComponent:index],ext];
                                                            }
                                                            [weakSelf newNameAction:weakSelf.model.href withNewPath:path];

                                                        }];
                                                        alert.textField.keyboardType = UIKeyboardTypeDefault;
                                                        alert.textField.placeholder = @"文件名称";
                                                        //    [alert.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                                                        [alert show];
                                                    }
                                                        break;
                                                    default:
                                                        break;
                                                }
                                            }];
            
//            YunFolderViewController *vc = [[YunFolderViewController alloc] initWithPath:nil];
//            
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            
//            vc.currentItem = weakSelf.model;
//            vc.yunFolderType = YunFolderMove;
//            [weakSelf.viewController presentViewController:nav animated:YES completion:nil];
            
        }
    };
    
    [self.contentView sd_addSubviews:@[_logoImageView, _titleLabel, _subTitleLabel, _selectButton, _showButton, _bottomView]];
    
    _logoImageView.sd_layout
    .leftSpaceToView(self.contentView,30)
    .topSpaceToView(self.contentView,12)
    .widthIs(36)
    .heightIs(36);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_logoImageView,10)
    .topSpaceToView(self.contentView,15)
    .heightIs(16)
    .rightSpaceToView(self.contentView,45);
    
    _subTitleLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,7)
    .heightIs(9);
    
    _showButton.sd_layout
    .rightSpaceToView(self.contentView,14)
    .widthIs(30)
    .heightIs(30)
    .topSpaceToView(self.contentView,15);
    
    _bottomView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(_logoImageView,12)
    .heightIs(50);
    
    _selectButton.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,24)
    .widthIs(13)
    .heightIs(13);
    
    _selectButton.hidden = YES;
}

-(void)setupClient{
    XGWebDavManager *manager = [XGWebDavManager sharWebDavmManager];
    _currentClient=[[LEOWebDAVClient alloc] initWithRootURL:[NSURL URLWithString:manager.url]
                                                andUserName:manager.userName
                                                andPassword:manager.password];
}


/**
 重命名操作

 @param originPath 原始路径
 @param newPath 新路径+新文件名
 */
- (void)newNameAction:(NSString *)originPath withNewPath:(NSString *)newPath{
    if (_currentClient==nil) {
        [self setupClient];
    }
    
    LEOWebDAVMoveRequest *request = [[LEOWebDAVMoveRequest alloc] initWithPath:originPath];
    request.delegate = self;
    request.destinationPath = newPath;
    [_currentClient enqueueRequest:request];
}

- (void)deleteAction{
    if (_currentClient==nil) {
        [self setupClient];
    }
    
    LEOWebDAVDeleteRequest *request = [[LEOWebDAVDeleteRequest alloc] initWithPath:_model.href];
    request.delegate = self;
    request.info = _model;
    [_currentClient enqueueRequest:request];
}

- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    [self deleteAction];
}

//网络请求，获取到列表信息
- (void)request:(LEOWebDAVRequest *)aRequest didSucceedWithResult:(id)result
{
    if ([aRequest isKindOfClass:[LEOWebDAVDeleteRequest class]]) {
        NSLog(@"删除成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationYunListReload object:self];
        
    }else if ([aRequest isKindOfClass:[LEOWebDAVMoveRequest class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationYunListReload object:self];
    }
}

- (void)setModel:(LEOWebDAVItem *)model{
    _model = model;
    
    _titleLabel.text = model.displayName;
    _subTitleLabel.text = model.modifiedDate;
    
    _selectButton.hidden = !model.showEdit; //编辑状态可用
    _selectButton.selected = model.beSelected; //按钮设置选中状态
    _showButton.hidden = model.showEdit;   //编辑状态显示
    
    NSString *type = [model.contentType componentsSeparatedByString:@"/"][0];
    
    
    //对文件格式进行分类处理
    if (model.type == LEOWebDAVItemTypeCollection) {
        _logoImageView.image = [UIImage imageNamed:@"pan_floder"];
    }else if([type isEqualToString:@"image"]){
        NSURL *url = [NSURL URLWithString:model.url];

        YYWebImageManager *manager = [YYWebImageManager sharedManager];
        manager.username = [XGWebDavManager sharWebDavmManager].userName;
        manager.password = [XGWebDavManager sharWebDavmManager].password;
        //设置图片文件缩略图，进行缓存
        [_logoImageView yy_setImageWithURL:url
                          placeholder:nil
                              options:YYWebImageOptionSetImageWithFadeAnimation
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                             }
                            transform:^UIImage *(UIImage *image, NSURL *url) {
                                image = [image yy_imageByResizeToSize:CGSizeMake(30, 30) contentMode:UIViewContentModeScaleToFill];
                                return image;
                            }
                           completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                               if (from == YYWebImageFromDiskCache) {
                                   NSLog(@"load from disk cache");
                               }
                               
                           }];
        
    }else if([type isEqualToString:@"video"]){
        
        //设置video第一帧图片缓存
        _dataCache = [YYCache cacheWithName:@"YUNPAN_LOGO"];
        if ([_dataCache objectForKey:model.url]) {
            _logoImageView.image = (UIImage *)[_dataCache objectForKey:model.url];
        }else{
            //没有缓存则进行读取第一帧图片
            [self getVideoPreViewImage:model.url];
        }
   
    }else{
        _logoImageView.image = [UIImage imageNamed:@"pan_yunlogo"];
    }

}

//根据视频URL获取缩略图
- (void) getVideoPreViewImage:(NSString *)url
{
    
   VLCMediaPlayer *player = [[VLCMediaPlayer alloc] init];

    
    player.media = [[VLCMedia alloc] initWithURL:[NSURL URLWithString:url]];

    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        
        [player.media storeCookie:[NSString stringWithFormat:@"%@=%@",cookie.name, cookie.value] forHost:cookie.domain path:cookie.path];
        
    }
    //初始化并设置代理
    VLCMediaThumbnailer *thumbnailer = [VLCMediaThumbnailer thumbnailerWithMedia:player.media andDelegate:self];
//    self.thumbnailer = thumbnailer;
    //开始获取缩略图
    [thumbnailer fetchThumbnail];
    
}

//获取缩略图超时
- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer{
    NSLog(@"getThumbnailer time out.");
}
//获取缩略图成功
- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail{
    //获取缩略图
     _logoImageView.image = [UIImage imageWithCGImage:thumbnail];
    //写入缓存
    [_dataCache setObject:_logoImageView.image forKey:_model.url];
}

- (void)showAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_showButtonClick) {
        _showButtonClick(_model);
    }
}

- (void)viewSelected{
    _selectButton.selected = !_selectButton.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    _selectButton.selected = !_selectButton.selected;
    
    // Configure the view for the selected state
}

@end
