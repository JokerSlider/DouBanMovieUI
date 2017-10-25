//
//  LEOWebDAVItem.h
//  LEOWebDAV
//
//  Created by Liu Ley on 12-10-31.
//  Copyright (c) 2012年 SAE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	LEOWebDAVItemTypeFile,
	LEOWebDAVItemTypeCollection
} LEOWebDAVItemType;

@interface LEOWebDAVItem : NSObject
@property (assign) LEOWebDAVItemType type;
@property (strong) NSString *href;
@property (readonly) NSString *relativeHref;
@property (readonly) NSString *displayName;
@property (readonly) NSURL *rootURL;
@property (readonly) NSString *url;
@property (readonly) NSString *contentSize;
@property (readonly) NSString *cacheName;
@property (strong) NSString *creationDate;
@property (strong) NSString *modifiedDate;
@property (strong) NSString *contentType;
@property (assign) long long contentLength;

@property (nonatomic, assign) BOOL showEdit;//显示编辑样式
@property (nonatomic, assign) BOOL beSelected;//被选中

-(void)setRootURL:(NSURL *)rootUrl;
-(void)setLocation:(NSString *)location;
-(id)initWithItem:(LEOWebDAVItem *)item;
-(void)setShowEdit:(BOOL)showEdit;
-(void)setBeSelected:(BOOL)beSelected;
-(void)setSelected;

@end
