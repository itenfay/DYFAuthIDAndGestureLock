//
//  UIButton+EdgeInsets.h
//
//  Created by dyf on 2017/7/26.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleImageLeft,
    ButtonEdgeInsetsStyleImageRight,
    ButtonEdgeInsetsStyleImageTop,
    ButtonEdgeInsetsStyleImageBottom
};

@interface UIButton (EdgeInsets)

/**
 调整按钮图片和标题的位置
 
 @param style EdgeInsets类型
 @param space 图片和标题的空隙
 */
- (void)applyWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style space:(CGFloat)space;

@end
