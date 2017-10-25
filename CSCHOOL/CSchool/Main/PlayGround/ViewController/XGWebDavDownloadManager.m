//
//  XGWebDavDownloadManager.m
//  CSchool
//
//  Created by 左俊鑫 on 17/5/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "XGWebDavDownloadManager.h"
#import "LEOWebDAVDownloadRequest.h"
#import "LEOWebDAVItem.h"
#import "XGWebDavManager.h"
#import "LEOWebDAVClient.h"
#import "ProgressHUD.h"
#import "YYCache.h"
#import "LEOUtility.h"
#import "XGCacheDef.h"

@implementation XGWebDavDownloadManager
{
    LEOWebDAVClient *_currentClient;
    YYCache *_cache;
}
static XGWebDavDownloadManager * manager;
+ (XGWebDavDownloadManager *)shareDownloadManager{
    static dispatch_once_t oneTime;
    dispatch_once(&oneTime, ^{
        manager = [[XGWebDavDownloadManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self readDownArray];
        _downloadingArray = [NSMutableArray array];
    }
    return self;
}

- (void)saveDownArray{
    
    [_cache setObject:[NSKeyedArchiver archivedDataWithRootObject:_didDownloadArray] forKey:DidDownload];
    [_cache setObject:_downloadDic forKey:DownloadDic];
    return;


}

- (void)readDownArray{
    
    _cache = [YYCache cacheWithName:DownloadCacheName];
    
    if ([_cache objectForKey:DidDownload]) {
        _didDownloadArray = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[_cache objectForKey:DidDownload]];
    }else{
        _didDownloadArray = [NSMutableArray array];
        [_cache setObject:[NSKeyedArchiver archivedDataWithRootObject:_didDownloadArray] forKey:DidDownload];
    }
    
    if ([_cache objectForKey:DownloadDic]) {
        _downloadDic = (NSMutableDictionary *)[_cache objectForKey:DownloadDic];
    }else{
        _downloadDic = [NSMutableDictionary dictionary];
    }

    return;

}

- (void)addDownload:(LEOWebDAVItem *)item{

    [self setupClient:item.url];

    
    if (!_downloadingArray) {
        _downloadingArray = [NSMutableArray array];
    }
    if (!_didDownloadArray) {
        _didDownloadArray = [NSMutableArray array];
    }
    
    if ([_downloadingArray containsObject:item]) {
        [ProgressHUD showError:@"已经在下载队列"];
        return;
    }else if ([_didDownloadArray containsObject:item]){
        [ProgressHUD showSuccess:@"已经下载完成"];
        return;
    }
    
    if ([[_downloadDic allKeys] containsObject:item.url]) {
        if ([[_downloadDic objectForKey:item.url] isEqualToString:@"1"]) {
            [ProgressHUD showSuccess:@"已经下载完成"];
            return;
        }
    }

    
    LEOWebDAVDownloadRequest *downRequest=[[LEOWebDAVDownloadRequest alloc] initWithPath:item.href];
    downRequest.item = item;
    downRequest.delegate=self;
    [_currentClient enqueueRequest:downRequest];
    [_downloadingArray addObject:item];
}

- (void)setupClient:(NSString *)url{
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
        _receivedProgressClick([_downloadingArray indexOfObject:downloadItem], percent);
    }
    
    NSLog(@"---%f===%@",percent,downloadItem.displayName);
}

- (void)request:(LEOWebDAVRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
- (void)request:(LEOWebDAVRequest *)request didSucceedWithResult:(id)result{
    NSLog(@"SUCCESS");
    LEOWebDAVDownloadRequest *req=(LEOWebDAVDownloadRequest *)request;
    LEOWebDAVItem *downloadItem=req.item;
    //下载成功，将正在下载的数据转存到下载完成里。
    [_downloadingArray removeObject:downloadItem];
    [_didDownloadArray addObject:downloadItem];
    [_downloadDic setObject:@"1" forKey:downloadItem.url];
    
    [self saveDownArray];

    if (_taskDidDown) {
        _taskDidDown([_downloadingArray indexOfObject:downloadItem], downloadItem);
    }
    //将下载下来的数据写入本地文件。
    NSData *myDate=result;
    NSString *cacheFolder=[[LEOUtility getInstance] cachePathWithName:@"download"];
    NSString *cacheUrl=[cacheFolder stringByAppendingPathComponent:downloadItem.displayName];
    [myDate writeToFile:cacheUrl atomically:YES];
}

@end
