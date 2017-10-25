//
//  XGStationPointView.m
//  XGBusRouteView
//
//  Created by 左俊鑫 on 16/12/15.
//  Copyright © 2016年 Xin the Great. All rights reserved.
//

#import "XGStationPointView.h"
#import "YYTextView.h"

@implementation XGStationPointView
{
    StationDirection _stationDirection;
    NSString *_nameString;
    YYTextView *nameLabel;
    BOOL _isEnd;
}
- (instancetype)initWithDirection:(StationDirection)stationDirection withName:(NSString *)name isEnd:(BOOL)isEnd
{
    self = [super init];
    if (self) {
        _stationDirection = stationDirection;
        _nameString = name;
        _isEnd = isEnd;
        [self createViews];
    }
    return self;
}

- (void)createViews{
    
    if (_isEnd) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-8, -11, 21, 21)];
        _imageView.image = [UIImage imageNamed:@"bus_qidian"];
        [self addSubview:_imageView];
    }else{
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        point.backgroundColor = [UIColor whiteColor];
        point.layer.cornerRadius = 8;
        [self addSubview:point];
        
        UIView *centView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 12, 12)];
        centView.layer.cornerRadius = 6;
        centView.backgroundColor = Base_Orange;
        [point addSubview:centView];
    }
    

    
    nameLabel = [[YYTextView alloc] init];
    nameLabel.text = _nameString;
    nameLabel.font = [UIFont systemFontOfSize:12];
//    nameLabel.verticalForm = YES;
    nameLabel.editable = NO;
    nameLabel.textColor = RGB(85, 85, 85);
    [self addSubview:nameLabel];
    switch (_stationDirection) {
        case StationBottom:
        {
            if (_isEnd) {
                if (_nameString.length>4) {
                    nameLabel.frame = CGRectMake(-20, 2, 60, 38);
                }else{
                    nameLabel.frame = CGRectMake(-40, 2, 60, 25);
                }
            }else{
                if (_nameString.length>4) {
                    nameLabel.frame = CGRectMake(-12, 16, 60, 38);
                }else{
                    nameLabel.frame = CGRectMake(-6, 16, 60, 30);
                }
            }
            
        }
            break;
        case StationRight:{
            nameLabel.frame = CGRectMake(14, -5, 60, 38);
        }
            break;
        case StationLeft:{
            nameLabel.frame = CGRectMake(-38, -5, 60, 38);
        }
            break;
        default:
            break;
    }
    
    
}

- (void)setStationDirection:(StationDirection)stationDirection{
    _stationDirection = stationDirection;
    switch (_stationDirection) {
        case StationBottom:
        {
            if (_isEnd) {
                if (_nameString.length>4) {
                    nameLabel.frame = CGRectMake(-20, 10, 60, 38);
                }else{
                    nameLabel.frame = CGRectMake(-14, 10, 60, 30);
                }
            }else{
                if (_nameString.length>4) {
                    nameLabel.frame = CGRectMake(-12, 16, 60, 38);
                }else{
                    nameLabel.frame = CGRectMake(-6, 16, 60, 30);
                }
            }
        }
            break;
        case StationRight:{
            nameLabel.frame = CGRectMake(14, -5, 60, 38);
        }
            break;
        case StationLeft:{
            nameLabel.frame = CGRectMake(-38, -5, 60, 38);
        }
            break;
        default:
            break;
    }
    
}

@end
