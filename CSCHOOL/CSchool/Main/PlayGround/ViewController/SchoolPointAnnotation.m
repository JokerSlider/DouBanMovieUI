//
//  SchoolPointAnnotation.m
//  CSchool
//
//  Created by 左俊鑫 on 16/7/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SchoolPointAnnotation.h"

@implementation SchoolPointAnnotation

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.coordinate = CLLocationCoordinate2DMake([dataDic[@"MAILATITUDE"] floatValue], [dataDic[@"MAILONGITUDE"] floatValue]);

    self.title = dataDic[@"MAINAME"];
    self.subtitle = dataDic[@"MTNAME"];
}

@end
