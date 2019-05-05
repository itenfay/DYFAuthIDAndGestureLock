//
//  DYFGestureView.h
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYFGestureView : UIView

/**
 *  手势操作完成回调方法, 参数为手势划过的顺序密码0-8
 */
@property (nonatomic, copy) BOOL(^gestureResult)(NSString *gestureCode);

/**
 *  是否显示手势划过的轨迹
 */
@property (nonatomic, getter=isHideGesturePath) BOOL hideGesturePath;

/**
 *  是否显示手势划过的方向, 就是每个圆里的三角箭头
 */
@property (nonatomic, getter=isShowArrowDirection) BOOL showArrowDirection;

@end
