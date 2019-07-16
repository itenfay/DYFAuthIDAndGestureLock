//
//  DYFGestureSettingsController.h
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFBaseViewController.h"

typedef NS_ENUM(NSInteger, DYFGestureSettingsType) {
    DYFGestureSettingsTypeSet = 1,  // 设置
    DYFGestureSettingsTypeDelete,   // 删除设置
    DYFGestureSettingsTypeChange    // 修改
};

// 设置的回调函数
typedef void (^DYFGestureSettingsBlock)(BOOL successful);

@interface DYFGestureSettingsController : DYFBaseViewController

@property (nonatomic, assign) DYFGestureSettingsType gestureSettingsType;

// 手势设置完成的回调
- (void)gestureSettingsWithCompletion:(DYFGestureSettingsBlock)completionHandler;

@end
