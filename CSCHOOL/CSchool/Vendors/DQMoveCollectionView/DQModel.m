//
//  DQModel.m
//  Init
//
//  Created by 邓琪 dengqi on 2016/12/16.
//  Copyright © 2016年 zhaoshijie. All rights reserved.
//

#import "DQModel.h"

@implementation DQModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.image forKey:@"image"] ;
    [aCoder encodeObject:self.title forKey:@"title"] ;
    [aCoder encodeObject:self.ai_id forKey:@"ai_id"] ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init] ;
    if(self)
    {
        self.image = [aDecoder decodeObjectForKey:@"image"] ;
        self.title = [aDecoder decodeObjectForKey:@"title"] ;
        self.ai_id = [aDecoder decodeObjectForKey:@"ai_id"] ;
    }
    return self ;
}
@end
