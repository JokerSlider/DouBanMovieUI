//
//  XuebaRankCell.h
//  CSchool
//
//  Created by 左俊鑫 on 2017/9/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XuebaModel : NSObject

@property (nonatomic, copy) NSString *xm;
@property (nonatomic, copy) NSString *txdz;
@property (nonatomic, copy) NSString *cj;
@property (nonatomic, copy) NSString *pm;
//@property (nonatomic, copy) NSString *xm;
//@property (nonatomic, copy) NSString *xm;


@end

@interface XuebaRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (nonatomic, retain) XuebaModel *model;

@end
