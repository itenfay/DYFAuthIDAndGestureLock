//
//  DYFCircleView.h
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

// 根据Hex值转换成颜色，格式:DYFColorFromHex(0xFF0000, 1.0)
#define DYFColorFromHex(hex, alp) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alp]

// 手势圆圈正常的颜色
#define DYFCircleNormalColor     DYFColorFromHex(0x33CCFF, 1.0)
// 手势圆圈选中的颜色
#define DYFCircleSelectedColor   DYFColorFromHex(0x3393F2, 1.0)
// 手势圆圈错误的颜色
#define DYFCircleErrorColor      DYFColorFromHex(0xFF0033, 1.0)
// 手势圆圈错误的颜色
#define DYFCircleErrorBlackColor DYFColorFromHex(0x000000, 1.0)

typedef NS_ENUM(NSInteger, GestureViewStatus) {
    GestureViewStatusNormal,
    GestureViewStatusSelected,
    GestureViewStatusSelectedAndShowArrow,
    GestureViewStatusError,
    GestureViewStatusErrorAndShowArrow,
};

@interface DYFCircleView : UIView

@property (nonatomic, assign) GestureViewStatus circleStatus;

/**
 * 相邻两圆圈连线的方向角度
 */
@property (nonatomic) CGFloat angle;

@end
