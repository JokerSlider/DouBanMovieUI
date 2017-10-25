//
//  PXRequest.h
//  
//
//  Created by mac on 16/3/21.
//
//

#import <Foundation/Foundation.h>
typedef void(^FinshLoadBlock) (NSData *);
@interface PXRequest : NSMutableURLRequest<NSURLConnectionDataDelegate>


@property (nonatomic,strong)NSMutableData *data;         //加载的数据
@property (nonatomic,strong)NSURLConnection *connection; //连接对象
@property (nonatomic,strong)FinshLoadBlock block;        //定义一个block 数据加载完后调用

- (void)startAsynrc; //开始请求

- (void)cancel;      //取消请求

@end
