//
//  DYFAuthIDAndGestureLockSettingsCell.m
//
//  Created by dyf on 2017/8/2.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFAuthIDAndGestureLockSettingsCell.h"
#import "UIView+Ext.h"

@implementation DYFAuthIDAndGestureLockSettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (UILabel *)m_textLabel {
    if (!_m_textLabel) {
        _m_textLabel = [[UILabel alloc] init];
        _m_textLabel.adjustsFontSizeToFitWidth = YES;
        _m_textLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _m_textLabel;
}

- (UISwitch *)m_switch {
    if (!_m_switch) {
        _m_switch = [[UISwitch alloc] init];
        _m_switch.on = NO;
    }
    return _m_switch;
}

- (void)addSubviews {
    [self addSubview:self.m_textLabel];
    [self addSubview:self.m_switch];
}

- (void)layoutSubviews {
    self.m_textLabel.left = 20.f;
    self.m_textLabel.width = 200.f;
    self.m_textLabel.height = 28.f;
    self.m_textLabel.top = (AGLSettingsCellHeight - self.m_textLabel.height)/2.f;
    
    self.m_switch.top = (AGLSettingsCellHeight - self.m_switch.height)/2.f;
    self.m_switch.right = DYFScreenWidth - self.m_textLabel.left;
}

@end
