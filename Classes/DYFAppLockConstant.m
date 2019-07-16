//
//  DYFAppLockConstant.m
//
//  Created by dyf on 2019/7/7.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "DYFAppLockConstant.h"

// ID密码是否开启的key
NSString *const kAuthIDOpen                 = @"kAuthIDOpen";
// 手势密码是否开启的key
NSString *const kGustureCodeOpen            = @"kGustureCodeOpen";
// 手势密码记录的Key
NSString *const kGustureCodeRecord          = @"kGustureCodeRecord";
// 手势密码轨迹是否显示的key
NSString *const kGustureCodeTrackShown      = @"kGustureCodeTrackShown";

NSString *const kSetGustureCodeText         = @"设置手势密码";
NSString *const kVerifyGustureCodeText      = @"验证手势密码";
NSString *const kPasswordErrorMessage       = @"手势密码错误";

NSString *const kPromptDefaultMessage       = @"绘制解锁图案";
NSString *const kPromptSetAgainMessage      = @"请再次绘制解锁图案";
NSString *const kPromptSetAgainErrorMessage = @"与上一次输入不一致，请重新设置";
NSString *const kPromptChangeGestureMessage = @"请输入原手势密码";
NSString *const kPromptPointShortMessage    = @"密码太短，至少3位，请重新设置";
NSString *const kPromptPasswordErrorMessage = @"手势密码错误";
