//
//  PXRequest.m
//  
//
//  Created by mac on 16/3/21.
//
//

#import "PXRequest.h"

@implementation PXRequest
//开始异步请求
- (void)startAsynrc
{
    self.data = [NSMutableData data];
    self.connection = [NSURLConnection connectionWithRequest:self delegate:self];
}

- (void)cancel
{
    [self.connection cancel];
}

#pragma  mark -
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.block(_data);
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"出错信息 = %@",error);
}


@end
