//
//  LibraryBookDetailCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryBookDetailModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;

@end

@interface LibraryBookDetailCell : UITableViewCell

@property (nonatomic, retain) LibraryBookDetailModel *model;

@end
