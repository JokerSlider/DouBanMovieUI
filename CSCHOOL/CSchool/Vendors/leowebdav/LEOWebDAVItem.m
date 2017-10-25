//
//  LEOWebDAVItem.m
//  LEOWebDAV
//
//  Created by Liu Ley on 12-10-31.
//  Copyright (c) 2012年 SAE. All rights reserved.
//

#import "LEOWebDAVItem.h"
#import "LEOWebDAVUtility.h"
#import "LEOContentTypeConvert.h"

@interface LEOWebDAVItem ()
{
    LEOWebDAVItemType type;
    NSString *href;
    NSString *displayName;
    NSString *creationDate;
    NSString *modifiedDate;
    
    long long contentLength;
    
    NSURL *_rootURL;
    NSString *_relativeHref;
    NSString *_location;
    NSString *_contentSize;
    NSString *_cacheName;
    NSString *_contentType;
}
@end

@implementation LEOWebDAVItem
@synthesize type;
@synthesize href;
@synthesize creationDate,modifiedDate;
@synthesize contentLength;

- (id)init {
	self = [super init];
	if (self) {
		type = LEOWebDAVItemTypeFile;
	}
	return self;
}

-(id)initWithItem:(LEOWebDAVItem *)item{
    self = [self init];
	if (self) {
		type=item.type;
        href=[item.href copy];
        creationDate=[item.creationDate copy];
        modifiedDate=[item.modifiedDate copy];
        _contentType=[item.contentType copy];
        contentLength=item.contentLength;
        [self setRootURL:item.rootURL];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"href = %@; modificationDate = %@; contentLength = %lld; "
            @"contentType = %@; creationDate = %@; resourceType = %d; displayName=%@",
            href, modifiedDate, contentLength, _contentType,
            creationDate, type, self.displayName];
}

-(NSString*)displayName {
	if(displayName == nil || displayName.length == 0) {
		return [[href lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	} else {
		return displayName;
	}
}

-(void)setRootURL:(NSURL*)_rootUrl
{
    _rootURL=[_rootUrl copy];
    NSString *root=[_rootURL absoluteString];
    NSString *relativeRoot=[_rootURL relativePath];
    NSString *temp=[NSString stringWithString:href];
    if ([href hasPrefix:relativeRoot]) {
        temp=[temp substringFromIndex:relativeRoot.length ];
    }
    if([root rangeOfString:@"%"].length == 0) {
        temp = [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    _relativeHref=[[NSString alloc] initWithFormat:@"%@",temp];
}

-(NSString *)contentSize
{
    if (_contentSize == nil) {
            _contentSize=[[NSString alloc] initWithFormat:@"%@",[LEOWebDAVUtility formattedFileSize:contentLength]];
    }
    return _contentSize;
}

-(NSURL *)rootURL
{
    return _rootURL;
}

-(NSString *)url
{
    return [[_rootURL absoluteString] stringByAppendingString:_relativeHref];
}

-(NSString *)cacheName
{
    if (_cacheName ==nil) {
        NSString *name=[NSString stringWithFormat:@"%@_%@",self.url,self.creationDate];
        _cacheName = [[NSString alloc] initWithFormat:@"%@",[[LEOWebDAVUtility getInstance] md5ForData:[name dataUsingEncoding:NSUTF8StringEncoding]]];
    }
    return _cacheName;
}

-(NSString *)contentType
{
    if (_contentType==nil) {
        if (self.type==LEOWebDAVItemTypeCollection) {
            //
            _contentType=@"httpd/unix-directory";
        } else {
            NSString *_extend=[[self displayName] pathExtension];
            NSString *result=[[LEOExtensionToMIME getInstance] searchMimeFromExtension:_extend];
            _contentType=result==nil?@"default":result;
        }
    }
    return _contentType;
}

-(void)setContentType:(NSString *)contentType
{
    _contentType=nil;
    if (contentType==nil) {
        return;
    }
    if ([LEOWebDAVUtility isEmptyString:contentType]) {
        return;
    }
    _contentType=[contentType copy];
}

-(void)setLocation:(NSString *)location
{
    _location=[[NSString alloc] initWithString:location];
//    NSLog(@"href:%@;relative:%@;location:%@",href,_relativeHref,_location);
}

-(NSString *)relativeHref{
    return _relativeHref;
}

-(void)setShowEdit:(BOOL)showEdit{
    _showEdit = showEdit;
}

-(void)setBeSelected:(BOOL)beSelected{
    _beSelected = beSelected;
}

-(void)setSelected{
    _beSelected = YES;
}

//@property (assign) LEOWebDAVItemType type;
//@property (strong) NSString *href;
//@property (readonly) NSString *relativeHref;
//@property (readonly) NSString *displayName;
//@property (readonly) NSURL *rootURL;
//@property (readonly) NSString *url;
//@property (readonly) NSString *contentSize;
//@property (readonly) NSString *cacheName;
//@property (strong) NSString *creationDate;
//@property (strong) NSString *modifiedDate;
//@property (strong) NSString *contentType;
//@property (assign) long long contentLength;
//
//@property (nonatomic, assign) BOOL showEdit;//显示编辑样式
//@property (nonatomic, assign) BOOL beSelected;//被选中

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.type = [coder decodeIntForKey:@"type"];
        self.href = [coder decodeObjectForKey:@"href"];
        _relativeHref = [coder decodeObjectForKey:@"relativeHref"];
        displayName = [coder decodeObjectForKey:@"displayName"];
        _rootURL = [coder decodeObjectForKey:@"rootURL"];
//        _url = [coder decodeObjectForKey:@"url"];
        _contentSize = [coder decodeObjectForKey:@"contentSize"];
        _cacheName = [coder decodeObjectForKey:@"cacheName"];
        creationDate = [coder decodeObjectForKey:@"creationDate"];
        modifiedDate = [coder decodeObjectForKey:@"modifiedDate"];
        _contentType = [coder decodeObjectForKey:@"contentType"];
        contentLength = [coder decodeIntegerForKey:@"contentLength"];
        _showEdit = [coder decodeBoolForKey:@"showEdit"];
        _beSelected = [coder decodeBoolForKey:@"beSelected"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:self.type forKey:@"type"];
    [coder encodeObject:self.href forKey:@"href"];
    [coder encodeObject:self.relativeHref forKey:@"relativeHref"];
    [coder encodeObject:self.displayName forKey:@"displayName"];
    [coder encodeObject:self.rootURL forKey:@"rootURL"];
    [coder encodeObject:self.contentSize forKey:@"contentSize"];
    [coder encodeObject:self.cacheName forKey:@"cacheName"];
    [coder encodeObject:self.creationDate forKey:@"creationDate"];
    [coder encodeObject:self.modifiedDate forKey:@"modifiedDate"];
    [coder encodeObject:self.contentType forKey:@"contentType"];
    [coder encodeInteger:self.contentLength forKey:@"contentLength"];
    [coder encodeBool:self.showEdit forKey:@"showEdit"];
    [coder encodeBool:self.beSelected forKey:@"beSelected"];
}

@end
