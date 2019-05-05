//
//  DYFSecurityHelper.h
//
//  Created by dyf on 2017/7/21.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  指纹密码结果的回调函数
 *
 *  @param success       验证的结果
 *  @param inputPassword 输入登录密码验证
 *  @param message       验证结果的提示信息
 */
typedef void (^DYFTouchIDOpenBlock)(BOOL success, BOOL inputPassword, NSString *message);

@interface DYFSecurityHelper : NSObject

// 单例
+ (instancetype)sharedInstance;

// 手势密码的开启状态
+ (BOOL)gestureOpenStatus;

// 手势密码轨迹显示开启状态
+ (BOOL)gestureShowStatus;

// 关闭/开启手势密码
+ (void)openGesture:(BOOL)open;

// 关闭/开启手势密码
+ (void)openGestureShow:(BOOL)open;

// 获取保存手势密码的code
+ (NSString *)gainGestureCodeKey;

// 保存手势密码的code
+ (void)saveGestureCodeKey:(NSString *)gestureCode;

// 关闭/开启touchID
+ (void)touchIDOpen:(BOOL)open;

// touchID开启状态
+ (BOOL)touchIDOpenStatus;

// 开启指纹扫描的函数
- (void)openTouchID:(DYFTouchIDOpenBlock)block;

@end
