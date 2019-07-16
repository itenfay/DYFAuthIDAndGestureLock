//
//  DYFAppLockConstant.h
//  DYFAuthIDAndGestureLock
//
//  Created by dyf on 2019/7/7.
//  Copyright © 2019 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

// ID密码是否开启的key
FOUNDATION_EXPORT NSString *const kAuthIDOpen;
// 手势密码是否开启的key
FOUNDATION_EXPORT NSString *const kGustureCodeOpen;
// 手势密码记录的Key
FOUNDATION_EXPORT NSString *const kGustureCodeRecord;
// 手势密码轨迹是否显示的key
FOUNDATION_EXPORT NSString *const kGustureCodeTrackShown;

// 设置手势密码
FOUNDATION_EXPORT NSString *const kSetGustureCodeText;
// 验证手势密码
FOUNDATION_EXPORT NSString *const kVerifyGustureCodeText;
// 手势密码错误
FOUNDATION_EXPORT NSString *const kPasswordErrorMessage;

// 绘制解锁图案
FOUNDATION_EXPORT NSString *const kPromptDefaultMessage;
// 请再次绘制解锁图案
FOUNDATION_EXPORT NSString *const kPromptSetAgainMessage;
// 与上一次输入不一致，请重新设置
FOUNDATION_EXPORT NSString *const kPromptSetAgainErrorMessage;
// 请输入原手势密码
FOUNDATION_EXPORT NSString *const kPromptChangeGestureMessage;
// 密码太短，至少3位，请重新设置"
FOUNDATION_EXPORT NSString *const kPromptPointShortMessage;
// 手势密码错误
FOUNDATION_EXPORT NSString *const kPromptPasswordErrorMessage;
