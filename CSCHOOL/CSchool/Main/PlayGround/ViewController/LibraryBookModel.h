//
//  LibraryBookModel.h
//  CSchool
//
//  Created by 左俊鑫 on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryBookModel : NSObject

@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *publicName;
@property (nonatomic, copy) NSString *tiaomaNum;
@property (nonatomic, copy) NSString *haveNum;
@property (nonatomic, copy) NSString *canrentNum;
@property (nonatomic, copy) NSString *suoshuNum;

@property (nonatomic, copy) NSString *M_ISBN;
@property (nonatomic, copy) NSString *PRICE; //价格
@property (nonatomic, copy) NSString *M_PUB_YEAR; //出版年份
@property (nonatomic, copy) NSString *docType; //文献类型
@property (nonatomic, copy) NSString *IN_DATE; // 入藏日期
@property (nonatomic, copy) NSString *publicYear; //出版年

@property (nonatomic, copy) NSString *BOOK_STAT_CODE; //图书馆藏状态
//@property (nonatomic, copy) NSString *bookStatus;


@end
