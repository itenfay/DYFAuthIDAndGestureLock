//
//  DYFCircleView.h
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

// 根据Hex值转换成颜色，格式: CCColorFromHex(0xFF0000, 1.0)
#define CCColorFromHex(hex, alp) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alp]

// 手势圆圈正常的颜色
#define CircleNormalColor       CCColorFromHex(0x33CCFF, 1.f)
// 手势圆圈选中的颜色
#define CircleSelectedColor     CCColorFromHex(0x3393F2, 1.f)
// 手势圆圈错误的颜色
#define CircleErrorColor        CCColorFromHex(0xFF0033, 1.f)

typedef NS_ENUM(NSInteger, CircleViewStatus) {
    CircleViewStatusNormal,
    CircleViewStatusSelected,
    CircleViewStatusSelectedAndShowArrow,
    CircleViewStatusError,
    CircleViewStatusErrorAndShowArrow,
};

@interface DYFCircleView : UIView

@property (nonatomic, assign) CircleViewStatus circleStatus;

/**
 * 相邻两圆圈连线的方向角度
 */
@property (nonatomic) CGFloat angle;

@end
