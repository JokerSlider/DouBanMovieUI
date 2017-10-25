//
//  XGWebDavUploadManager.m
//  CSchool
//
//  Created by 左俊鑫 on 17/5/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "XGWebDavUploadManager.h"
#import "LEOWebDAVDownloadRequest.h"
#import "LEOWebDAVItem.h"
#import "XGWebDavManager.h"
#import "LEOWebDAVClient.h"
#import "ProgressHUD.h"
#import "YYCache.h"
#import "LEOUtility.h"
#import "XGCacheDef.h"
#import "LEOWebDAVUploadRequest.h"

@implementation XGWebDavUploadManager
{
    LEOWebDAVClient *_currentClient;
    YYCache *_cache;
}
static XGWebDavUploadManager * manager;
+ (XGWebDavUploadManager *)shareUploadManager{
    static dispatch_once_t oneTime;
    dispatch_once(&oneTime, ^{
        manager = [[XGWebDavUploadManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self readDownArray];
        _uploadingArray = [NSMutableArray array];
    }
    return self;
}

- (void)saveDownArray{
    
    [_cache setObject:[NSKeyedArchiver archivedDataWithRootObject:_didUploadArray] forKey:DidUpload];
    [_cache setObject:_uploadDic forKey:UploadDic];
    return;
    
    
}

- (void)readDownArray{
    
    _cache = [YYCache cacheWithName:UploadCacheName];
    
    if ([_cache objectForKey:DidUpload]) {
        _didUploadArray = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[_cache objectForKey:DidUpload]];
    }else{
        _didUploadArray = [NSMutableArray array];
        [_cache setObject:[NSKeyedArchiver archivedDataWithRootObject:_didUploadArray] forKey:DidUpload];
    }
    
    if ([_cache objectForKey:UploadDic]) {
        _uploadDic = (NSMutableDictionary *)[_cache objectForKey:UploadDic];
    }else{
        _uploadDic = [NSMutableDictionary dictionary];
    }
    
    return;
    
}

- (void)addUploadUrl:(NSString *)url{
    [self setupClient];
    
    
    if (!_uploadingArray) {
        _uploadingArray = [NSMutableArray array];
    }
    if (!_didUploadArray) {
        _didUploadArray = [NSMutableArray array];
    }
    
    NSData *data = [NSData dataWithContentsOfFile:url];
    
//    NSArray *arr = [url componentsSeparatedByString:@"/"];
    
    NSString *path = [[XGWebDavUploadManager shareUploadManager].selctPath stringByAppendingPathComponent:url.lastPathComponent];
    
    LEOWebDAVUploadRequest *upRequest=[[LEOWebDAVUploadRequest alloc] initWithPath:path];

    upRequest.data = data;
    upRequest.delegate=self;
    [_currentClient enqueueRequest:upRequest];
    upRequest.fileUrl = url;
    [_uploadingArray addObject:url];
}

- (void)addUpload:(NSData *)data{
    
    [self setupClient];
    
    
    if (!_uploadingArray) {
        _uploadingArray = [NSMutableArray array];
    }
    if (!_didUploadArray) {
        _didUploadArray = [NSMutableArray array];
    }
    
//    if ([_uploadingArray containsObject:item]) {
//        [ProgressHUD showError:@"已经在上传队列"];
//        return;
//    }else if ([_didUploadArray containsObject:item]){
//        [ProgressHUD showSuccess:@"已经上传完成"];
//        return;
//    }
    
//    if ([[_uploadDic allKeys] containsObject:item.url]) {
//        if ([[_uploadDic objectForKey:item.url] isEqualToString:@"1"]) {
//            [ProgressHUD showSuccess:@"已经上传完成"];
//            return;
//        }
//    }
    
//    NSArray *arr = [fileUrl componentsSeparatedByString:@"/"];
    LEOWebDAVUploadRequest *upRequest=[[LEOWebDAVUploadRequest alloc] initWithPath:@"111"];
//    downRequest.item = item;
    upRequest.data = data;
    upRequest.delegate=self;
    [_currentClient enqueueRequest:upRequest];
//    [_uploadingArray addObject:data];
}

- (void)setupClient{
    XGWebDavManager *manager = [XGWebDavManager sharWebDavmManager];
    _currentClient=[[LEOWebDAVClient alloc] initWithRootURL:[NSURL URLWithString:manager.url]
                                                andUserName:manager.userName
                                                andPassword:manager.password];
}

- (void)requestDidBegin:(LEOWebDAVRequest *)request{
    
}

- (void)request:(LEOWebDAVRequest *)request didReceivedProgress:(float)percent
{
    LEOWebDAVDownloadRequest *req=(LEOWebDAVDownloadRequest *)request;
    LEOWebDAVItem *downloadItem=req.item;
    
    if (_receivedProgressClick) {
        _receivedProgressClick([_uploadingArray indexOfObject:downloadItem], percent);
    }
    
    NSLog(@"---%f===%@",percent,downloadItem.displayName);
}

- (void)request:(LEOWebDAVRequest *)request didSendBodyData:(CGFloat)percent{
     NSLog(@"---%f==%s",percent,"UP");
}

- (void)request:(LEOWebDAVRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
- (void)request:(LEOWebDAVRequest *)request didSucceedWithResult:(id)result{
    NSLog(@"SUCCESS");
    LEOWebDAVUploadRequest *req=(LEOWebDAVUploadRequest *)request;
    NSString *url = req.fileUrl;
//    LEOWebDAVItem *downloadItem=req.item;
    
    //上传成功，将正在上传的数据转存到上传完成里。
    [_uploadingArray removeObject:url];
    [_didUploadArray addObject:url];
    [_uploadDic setObject:@"1" forKey:url];
    
    [self saveDownArray];
    
    if (_taskDidDown) {
//        _taskDidDown([_uploadingArray indexOfObject:downloadItem], downloadItem);
    }
    //将上传下来的数据写入本地文件。
// /Users/zuojunxin/Library/Saved Searches/.DockTags/红色.tag6.savedSearch   NSData *myDate=result;
//    NSString *cacheFolder=[[LEOUtility getInstance] cachePathWithName:@"download"];
//    NSString *cacheUrl=[cacheFolder stringByAppendingPathComponent:downloadItem.displayName];
//    [myDate writeToFile:cacheUrl atomically:YES];
}
@end
