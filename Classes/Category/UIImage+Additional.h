//
//  UIImage+Additional.h
//
//  Created by dyf on 2019/7/14.
//  Copyright © 2019 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Additional)

/**
 图片裁剪，适用于圆形头像之类
 
 @return 圆形图片
 */
- (UIImage *)yf_circleImage;

@end

NS_ASSUME_NONNULL_END
