//
//  UIImage+Additional.m
//
//  Created by dyf on 2019/7/14.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "UIImage+Additional.h"

@implementation UIImage (Additional)

/**
 图片裁剪，适用于圆形头像之类
 
 @return 圆形图片
 */
- (UIImage *)yf_circleImage {
    // 1.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域
    [path addClip];
    // 4.画图
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
