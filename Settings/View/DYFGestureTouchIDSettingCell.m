//
//  DYFGestureTouchIDSettingCell.m
//
//  Created by dyf on 2017/8/2.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFGestureTouchIDSettingCell.h"
#import "UIView+Ext.h"
#import "DYFDefinition.h"

@implementation DYFGestureTouchIDSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    _mTextLabel = [[UILabel alloc] init];
    _mTextLabel.left = 10;
    _mTextLabel.width = 200;
    _mTextLabel.height = 28;
    _mTextLabel.top = (GTSettingCellHeight - 28)/2;
    _mTextLabel.adjustsFontSizeToFitWidth = YES;
    _mTextLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:_mTextLabel];
    
    _mSwitch = [[UISwitch alloc] init];
    _mSwitch.on = NO;
    _mSwitch.top = (GTSettingCellHeight - _mSwitch.height)/2;
    _mSwitch.right = ScreenWidth - 10;
    [self addSubview:_mSwitch];
}

@end
