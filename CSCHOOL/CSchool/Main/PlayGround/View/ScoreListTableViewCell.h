//
//  ScoreListTableViewCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/5/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *classXuefenLabel;

@property (nonatomic, strong) NSDictionary *dataDic;

@end
