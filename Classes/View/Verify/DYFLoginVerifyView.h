//
//  DYFLoginVerifyView.h
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DYFLoginVerifyType) {
    DYFLoginVerifyTypeTouchID, // 指纹密码验证登录
    DYFLoginVerifyTypeGesture  // 手势密码验证登录
};

typedef void(^DYFLoginVerifyBlock)(BOOL success);
typedef void(^DYFLoginOtherAccountBlock)();

@interface DYFLoginVerifyView : UIView
// 头像
@property (nonatomic, strong) UIImage *headImage;

- (instancetype)initWithFrame:(CGRect)frame verifyType:(DYFLoginVerifyType)verifyType;

// 显示view
- (void)showView;

// 验证结果的回调
- (void)loginVerifyResult:(DYFLoginVerifyBlock)block;

// 登录其他账户回调
- (void)loginOtherAccountAction:(DYFLoginOtherAccountBlock)block;

@end
