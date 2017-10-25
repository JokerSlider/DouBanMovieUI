//
//  YunLogoImageHelper.m
//  CSchool
//
//  Created by 左俊鑫 on 17/5/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunLogoImageHelper.h"
#import "LEOWebDAVItem.h"
#import "YYWebImage.h"
#import "XGWebDavManager.h"
#import <MobileVLCKit/MobileVLCKit.h>

@implementation YunLogoImageHelper
{
    GetImageBlock _imageBlock;
    LEOWebDAVItem *_model;
}
static YYCache *_dataCache;

- (void)imageWithType:(LEOWebDAVItem *)model getImage:(GetImageBlock)imageBlock{
    _imageBlock = imageBlock;
    _model = model;
    [self changeImage];
}

- (void)changeImage{
    NSString *type = [_model.contentType componentsSeparatedByString:@"/"][0];

    
    if (_model.type == LEOWebDAVItemTypeCollection) {
        //文件夹
        _imageBlock([UIImage imageNamed:@"pan_floder"]);
    }else if ([type isEqualToString:@"image"]){
        NSURL *url = [NSURL URLWithString:_model.url];
        
        YYWebImageManager *manager = [YYWebImageManager sharedManager];
        manager.username = [XGWebDavManager sharWebDavmManager].userName;
        manager.password = [XGWebDavManager sharWebDavmManager].password;
        //设置图片文件缩略图，进行缓存
        [[UIImageView new] yy_setImageWithURL:url
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
                                    _imageBlock(image);
                                }];
    }else if([type isEqualToString:@"video"]){
        
        //设置video第一帧图片缓存
        _dataCache = [YYCache cacheWithName:@"YUNPAN_LOGO"];
        if ([_dataCache objectForKey:_model.url]) {
            _imageBlock((UIImage *)[_dataCache objectForKey:_model.url]);
        }else{
            //没有缓存则进行读取第一帧图片
            [self getVideoPreViewImage:_model.url];
        }
        
    }else{
        _imageBlock([UIImage imageNamed:@"pan_yunlogo"]);
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
    _imageBlock([UIImage imageWithCGImage:thumbnail]);
    //写入缓存
    [_dataCache setObject:[UIImage imageWithCGImage:thumbnail] forKey:_model.url];
}

@end
