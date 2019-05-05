//
//  DYFGestureSetController.h
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DYFGestureSetType) {
    DYFGestureSetTypeSetting = 1,   // 设置
    DYFGestureSetTypeDelete,        // 删除设置
    DYFGestureSetTypeChange         // 修改
};

// 设置的结果
typedef void (^DYFGestureSetBlock)(BOOL success);

@interface DYFGestureSetController : UIViewController

@property (nonatomic, assign) DYFGestureSetType gestureSetType;

// 设置手势完成的回调
- (void)gestureSetComplete:(DYFGestureSetBlock)block;

@end
