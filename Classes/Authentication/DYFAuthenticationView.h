//
//  DYFAuthenticationView.h
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DYFAuthenticationType) {
    DYFAuthenticationTypeAuthID, // 指纹ID/面容ID验证
    DYFAuthenticationTypeGesture // 手势密码验证
};

typedef void(^DYFAuthenticationBlock)(BOOL success);
typedef void(^DYFLoginOtherAccountBlock)();

@interface DYFAuthenticationView : UIView
// 头像
@property (nonatomic, strong) UIImage *avatarImage;

// 实例化
- (instancetype)initWithFrame:(CGRect)frame authenticationType:(DYFAuthenticationType)authenticationType;

// 显示View
- (void)show;

// 验证
- (void)authenticateWithCompletion:(DYFAuthenticationBlock)completionHandler;

// 登录其他账户
- (void)loginOtherAccountWithCompletion:(DYFLoginOtherAccountBlock)completionHandler;

@end
