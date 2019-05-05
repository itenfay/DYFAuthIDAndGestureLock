//
//  DYFSecurityHelper.m
//
//  Created by dyf on 2017/7/21.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFSecurityHelper.h"
#import "DYFDefinition.h"
#import "UIView+Ext.h"

@import LocalAuthentication;

@interface DYFSecurityHelper ()

@property (nonatomic, copy) DYFTouchIDOpenBlock block;

@end

@implementation DYFSecurityHelper

// 单例
+ (DYFSecurityHelper *)sharedInstance {
    static DYFSecurityHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

#pragma mark - 手势密码（Public）

// 手势密码的开启状态
+ (BOOL)gestureOpenStatus {
    NSNumber *tempNum = [NSStdUserDefaults objectForKey:Gesture_Password_Open];
    BOOL gestureOpen = tempNum ? [tempNum boolValue] : NO;
    return gestureOpen;
}

// 手势密码轨迹显示开启状态
+ (BOOL)gestureShowStatus {
    NSNumber *tempNum = [NSStdUserDefaults objectForKey:Gesture_Password_Show];
    BOOL gestureShow = tempNum ? [tempNum boolValue] : NO;
    return gestureShow;
}

// 关闭/开启手势密码
+ (void)openGesture:(BOOL)open {
    NSNumber *tempNum = open ? @(1) : @(0);
    [NSStdUserDefaults setObject:tempNum forKey:Gesture_Password_Open];
    [NSStdUserDefaults setObject:tempNum forKey:Gesture_Password_Show];
    [NSStdUserDefaults synchronize];
    if (!open) {
        [self saveGestureCodeKey:nil];
    }
}

// 关闭/开启手势密码
+ (void)openGestureShow:(BOOL)open {
    NSNumber *tempNum = open ? @(1) : @(0);
    [NSStdUserDefaults setObject:tempNum forKey:Gesture_Password_Show];
    [NSStdUserDefaults synchronize];
}

// 获取保存手势密码的code
+ (NSString *)gainGestureCodeKey {
    NSString *gestureCode = [NSStdUserDefaults objectForKey:Gesture_Code_Key];
    return gestureCode ? gestureCode : @"";
}

// 保存手势密码的code
+ (void)saveGestureCodeKey:(NSString *)gestureCode {
    [NSStdUserDefaults setObject:gestureCode forKey:Gesture_Code_Key];
    [NSStdUserDefaults synchronize];
}

#pragma mark - TouchID（Public）

// touchID开启状态
+ (BOOL)touchIDOpenStatus {
    NSNumber *tempNum = [NSStdUserDefaults objectForKey:TouchID_Password_Open];
    BOOL touchID = tempNum ? [tempNum boolValue] : NO;
    return touchID;
}

// 关闭/开启touchID
+ (void)touchIDOpen:(BOOL)open {
    NSNumber *tempNum = open ? @(1) : @(0);
    [NSStdUserDefaults setObject:tempNum forKey:TouchID_Password_Open];
    [NSStdUserDefaults synchronize];
}

// 开启指纹扫描的函数
- (void)openTouchID:(DYFTouchIDOpenBlock)block {
    self.block = block;
    [self openTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics touchIDBlock:block];
}

#pragma mark - TouchID（Private）

/*
typedef NS_ENUM(NSInteger, LAError) {
    LAErrorAuthenticationFailed,    // 验证信息出错，就是说你指纹不对
    LAErrorUserCancel               // 用户取消了验证
    LAErrorUserFallback             // 用户点击了手动输入密码的按钮，所以被取消了
    LAErrorSystemCancel             // 被系统取消，就是说你现在进入别的应用了，不在刚刚那个页面，所以没法验证
    LAErrorPasscodeNotSet           // 用户没有设置TouchID
    LAErrorTouchIDNotAvailable      // 用户设备不支持TouchID
    LAErrorTouchIDNotEnrolled       // 用户没有设置手指指纹
    LAErrorTouchIDLockout           // 用户错误次数太多，现在被锁住了
    LAErrorAppCancel                // 在验证中被其他app中断
    LAErrorInvalidContext           // 请求验证出错
}

typedef NS_ENUM(NSInteger, LAPolicy) {
    LAPolicyDeviceOwnerAuthenticationWithBiometrics NS_ENUM_AVAILABLE(NA, 8_0) __WATCHOS_AVAILABLE(3.0) __TVOS_AVAILABLE(10.0) = kLAPolicyDeviceOwnerAuthenticationWithBiometrics,
    LAPolicyDeviceOwnerAuthentication NS_ENUM_AVAILABLE(10_11, 9_0) = kLAPolicyDeviceOwnerAuthentication
    
}
第一个枚举LAPolicyDeviceOwnerAuthenticationWithBiometrics就是说，用的是手指指纹去验证的；NS_ENUM_AVAILABLE(NA, 8_0) iOS8可用
第二个枚举LAPolicyDeviceOwnerAuthentication少了WithBiometrics则是使用TouchID或者密码验证,默认是错误两次指纹或者锁定后,弹出输入密码界面;NS_ENUM_AVAILABLE(10_11, 9_0) iOS9可用
*/

// 开启指纹扫描
- (void)openTouchIDWithPolicy:(LAPolicy)policy touchIDBlock:(DYFTouchIDOpenBlock)block {
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"验证登录密码";
    // LAPolicyDeviceOwnerAuthentication
    DYFWeakSelf
    [context evaluatePolicy:policy localizedReason:@"通过Home键验证指纹" reply:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = @"";
            if (success) {
                message = @"通过了Touch ID指纹验证";
                block(YES, NO, message);
            } else {
                BOOL inputPassword = NO;
                //失败操作
                LAError errorCode = error.code;
                switch (errorCode) {
                    case LAErrorAuthenticationFailed: {
                        // -1
                        message = @"指纹不匹配";
                    }
                        break;
                        
                    case LAErrorUserCancel: {
                        // -2
                        message = @"用户取消验证Touch ID";
                    }
                        break;
                        
                    case LAErrorUserFallback: {
                        // -3
                        inputPassword = YES;
                        message = @"用户选择输入密码";
                    }
                        break;
                        
                    case LAErrorSystemCancel: {
                        // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                        message = @"取消授权，如其他应用切入";
                    }
                        break;
                        
                    case LAErrorPasscodeNotSet: {
                        // -5
                        message = @"设备系统未设置密码";
                    }
                        break;
                        
                    case LAErrorTouchIDNotAvailable: {
                        // -6
                        message = @"此设备不支持Touch ID";
                    }
                        break;
                        
                    case LAErrorTouchIDNotEnrolled: {
                        // -7
                        message = @"用户未录入指纹";
                    }
                        break;
                        
                    case LAErrorTouchIDLockout: {
                        // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                        if (iOS9plus) {
                            [weakSelf openTouchIDWithPolicy:LAPolicyDeviceOwnerAuthentication touchIDBlock:block];
                        }
                        message = @"Touch ID被锁，需要用户输入密码解锁";
                    }
                        break;
                        
                    case LAErrorAppCancel: {
                        // -9 如突然来了电话，电话应用进入前台，APP被挂起啦
                        message = @"用户不能控制情况下APP被挂起";
                    }
                        break;
                        
                    case LAErrorInvalidContext: {
                        // -10
                        message = @"Touch ID 失效";
                    }
                        break;
                        
                    default: {
                        message = @"此设备不支持Touch ID";
                    }
                        break;
                }
                block(success, inputPassword, message);
            }
        });
    }];
}

@end
