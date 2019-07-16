//
//  DYFSecurityHelper.h
//
//  Created by dyf on 2017/7/21.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 AuthID验证的回调函数
 
 @param success       验证的结果
 @param inputPassword 输入登录密码的验证
 @param message       提示信息
 */
typedef void (^DYFAuthIDEvaluationBlock)(BOOL success, BOOL inputPassword, NSString *message);

@interface DYFSecurityHelper : NSObject

// 单例
+ (instancetype)sharedHelper;

// 手势密码是否开启
+ (BOOL)gestureCodeOpen;

// 关闭/开启手势密码
+ (void)setGestureCodeOpen:(BOOL)open;

// 手势密码轨迹是否显示
+ (BOOL)gestureCodeTrackShown;

// 关闭/开启手势密码轨迹
+ (void)setGestureCodeTrackShown:(BOOL)shown;

// 获取保存手势密码
+ (NSString *)getGestureCode;

// 保存手势密码
+ (void)setGestureCode:(NSString *)gestureCode;

// AuthID是否开启
+ (BOOL)authIDOpen;

// 关闭/开启AuthID
+ (void)setAuthIDOpen:(BOOL)open;

// 能否验证
+ (BOOL)canAuthenticate;

// 设备是否支持Face ID
+ (BOOL)faceIDAvailable;

// 设备是否支持Touch ID
+ (BOOL)touchIDAvailable;

// 验证AuthID
- (void)evaluateAuthID:(DYFAuthIDEvaluationBlock)block;

@end
