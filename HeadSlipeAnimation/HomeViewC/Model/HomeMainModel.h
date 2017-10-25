//
//  HomeMainModel.h
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeMainModel : NSObject
@property (nonatomic,copy) NSDictionary *rating;//评分
@property (nonatomic,copy) NSString *max;//最高得分
@property (nonatomic,copy) NSString *average;
@property (nonatomic,copy) NSString *stars;//星星
@property (nonatomic,copy) NSString *min;//最低分
@property (nonatomic,copy) NSArray  *genres;//电影类型
@property (nonatomic,copy) NSString *title;//电影名称
@property (nonatomic,copy) NSArray  *casts;//演员列表
@property (nonatomic,copy) NSString *name;//演员名称  或  导演名称
@property (nonatomic,copy) NSArray  *directors;//导演
@property (nonatomic,copy) NSString *year;//演员名称
@property (nonatomic,copy) NSDictionary  *images;//海报
@property (nonatomic,copy) NSString *small;//缩图
@property (nonatomic,copy) NSString *large;//大图
@property (nonatomic,copy) NSString *medium;//中等

@property (nonatomic,copy) NSString *movieID;//中等

@property (nonatomic,copy) NSArray *countries;//国家

@property (nonatomic,copy) NSString *wish_count;//想看,

@property (nonatomic,copy) NSString *collect_count;//看过,

@property (nonatomic,copy) NSString *summary;

@property (nonatomic,copy)NSString *userid;

@property (nonatomic,copy)NSString *uuid;
@property (nonatomic,copy)NSString *major;
@property (nonatomic,copy)NSString *minor;
@property (nonatomic,copy)NSString *proximity;
@property (nonatomic,copy)NSString *accuracy;
@property (nonatomic,copy)NSString *rssi;
@property (nonatomic,copy)NSString *distance;
@property (nonatomic,copy)NSString *schoolCode;



/*
 {
 "rating": {
 "max": 10,
 "average": 7.4,
 "stars": "40",
 "min": 0
 },
 "genres": [
 "动作"
 ],
 "title": "战狼2",
 "casts": [
 {
 subjects
 "alt": "https://movie.douban.com/celebrity/1000525/",
 "avatars": {
 "small": "https://img3.doubanio.com/img/celebrity/small/39105.jpg",
 "large": "https://img3.doubanio.com/img/celebrity/large/39105.jpg",
 "medium": "https://img3.doubanio.com/img/celebrity/medium/39105.jpg"
 },
 "name": "吴京",
 "id": "1000525"
 },
 {
 "alt": "https://movie.douban.com/celebrity/1100321/",
 "avatars": {
 "small": "https://img1.doubanio.com/img/celebrity/small/1415801312.29.jpg",
 "large": "https://img1.doubanio.com/img/celebrity/large/1415801312.29.jpg",
 "medium": "https://img1.doubanio.com/img/celebrity/medium/1415801312.29.jpg"
 },
 "name": "弗兰克·格里罗",
 "id": "1100321"
 },
 {
 "alt": "https://movie.douban.com/celebrity/1274840/",
 "avatars": {
 "small": "https://img3.doubanio.com/img/celebrity/small/1401440361.14.jpg",
 "large": "https://img3.doubanio.com/img/celebrity/large/1401440361.14.jpg",
 "medium": "https://img3.doubanio.com/img/celebrity/medium/1401440361.14.jpg"
 },
 "name": "吴刚",
 "id": "1274840"
 }
 ],
 "collect_count": 355947,
 "original_title": "战狼2",
 "subtype": "movie",
 "directors": [
 {
 "alt": "https://movie.douban.com/celebrity/1000525/",
 "avatars": {
 "small": "https://img3.doubanio.com/img/celebrity/small/39105.jpg",
 "large": "https://img3.doubanio.com/img/celebrity/large/39105.jpg",
 "medium": "https://img3.doubanio.com/img/celebrity/medium/39105.jpg"
 },
 "name": "吴京",
 "id": "1000525"
 }
 ],
 "year": "2017",
 "images": {
 "small": "https://img3.doubanio.com/view/movie_poster_cover/ipst/public/p2485983612.jpg",
 "large": "https://img3.doubanio.com/view/movie_poster_cover/lpst/public/p2485983612.jpg",
 "medium": "https://img3.doubanio.com/view/movie_poster_cover/spst/public/p2485983612.jpg"
 },
 "alt": "https://movie.douban.com/subject/26363254/",
 "id": "26363254"
 }
 */
@end
