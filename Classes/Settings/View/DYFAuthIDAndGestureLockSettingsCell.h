//
//  DYFAuthIDAndGestureLockSettingsCell.h
//
//  Created by dyf on 2017/8/2.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYFAppLockDefines.h"

#define AGLSettingsCellHeight 44.f

@interface DYFAuthIDAndGestureLockSettingsCell : UITableViewCell

@property (nonatomic, strong) UILabel  *m_textLabel;
@property (nonatomic, strong) UISwitch *m_switch;

@end
