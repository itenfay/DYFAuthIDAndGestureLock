//
//  DYFAuthenticationView.m
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017 dyf. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "DYFAuthenticationView.h"
#import "DYFAppLockDefines.h"

#import "UIView+Ext.h"
#import "CALayer+Shake.h"
#import "UIButton+EdgeInsets.h"
#import "UIImage+Additional.h"

#import "DYFGestureView.h"
#import "DYFCircleView.h"
#import "DYFGestureShapeView.h"
#import "DYFSecurityHelper.h"

#define MarginTop             80.f
#define Margin                20.f
#define BottomHeight          48.f
#define AvatarWH              80.f
#define XIDHeight             90.f

@interface DYFAuthenticationView ()
// 手势九宫格
@property (nonatomic, strong) DYFGestureView            *gestureView;
// 手势错误的提示
@property (nonatomic, strong) UILabel                   *messageLabel;
// 顶部的头像按钮
@property (nonatomic, strong) UIImageView               *avatarImageView;
// 底部的切换登录方式按钮
@property (nonatomic, strong) UIButton                  *bottomButton;
// 指纹验证按钮
@property (nonatomic, strong) UIButton                  *XIDButton;

@property (nonatomic, assign) DYFAuthenticationType     authType;

@property (nonatomic,  copy ) DYFAuthenticationBlock    completionHandler;
@property (nonatomic,  copy ) DYFLoginOtherAccountBlock aCompletionHandler;

// 防止按钮重复点击
@property (nonatomic, assign) BOOL                      bottomBtnClick;
@property (nonatomic, assign) BOOL                      touchBtnClick;
@end

@implementation DYFAuthenticationView

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 默认指纹密码登录
        _authType = DYFAuthenticationTypeAuthID;
        [self layoutUI:_authType];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame authenticationType:(DYFAuthenticationType)authenticationType {
    self = [super initWithFrame:frame];
    if (self) {
        _authType = authenticationType;
        [self layoutUI:authenticationType];
    }
    return self;
}

#pragma mark - 对外方法

- (void)setAvatarImage:(UIImage *)avatarImage {
    _avatarImageView.image = [avatarImage yf_circleImage];
}

- (UIImage *)avatarImage {
    return _avatarImageView.image;
}

- (void)authenticateWithCompletion:(DYFAuthenticationBlock)completionHandler {
    self.completionHandler = completionHandler;
}

- (void)loginOtherAccountWithCompletion:(DYFLoginOtherAccountBlock)completionHandler {
    self.aCompletionHandler = completionHandler;
}

// 显示View (加载在Window上, 遮住导航条)
- (void)show {
    [UIView animateWithDuration:0.3f animations:^{
        UIWindow *window = [UIApplication.sharedApplication.delegate window];
        [window addSubview:self];
    } completion:^(BOOL finished) {
        self.alpha = 1.f;
    }];
}

#pragma mark - 布局UI

// 根据验证类型布局UI
- (void)layoutUI:(DYFAuthenticationType)authType {
    self.alpha = 0.5f;
    self.backgroundColor = [UIColor whiteColor];
    
    // 顶部的头像和底部的切换登录方式按钮是共有的
    // 头像
    if (!_avatarImageView) {
        CGFloat posX = (DYFScreenWidth - AvatarWH) * 0.5;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, MarginTop, AvatarWH, AvatarWH)];
        //_avatarImageView.contentMode = UIViewContentModeScaleToFill;
    }
    UIImage *originAvatarImg = DYFImageNamed(@"default_avatar");
    _avatarImageView.image = [originAvatarImg yf_circleImage];
    [self addSubview:_avatarImageView];
    
    // 底部按钮
    if (!_bottomButton) {
        CGFloat posY = DYFScreenHeight - BottomHeight * 1.2;
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor clearColor];
        _bottomButton.frame = CGRectMake(0.0, posY, DYFScreenWidth, BottomHeight);
        _bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [_bottomButton setTitleColor:DYFColorFromHex(0x3393F2, 1.0) forState:UIControlStateNormal];
        [_bottomButton setTitle:@"登录其他账户" forState:UIControlStateNormal];
    }
    [_bottomButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bottomButton];
    
    switch (authType) {
        case DYFAuthenticationTypeAuthID: {
            [self executeAuthIDUnlock];
            break;
        }
        case DYFAuthenticationTypeGesture: {
            [self executeGestureCodeUnlock];
            break;
        }
        default:
            break;
    }
}

// 指纹/面容解锁
- (void)executeAuthIDUnlock {
    if (!_XIDButton) {
        CGFloat posY = CGRectGetMaxY(_avatarImageView.frame) + XIDHeight;
        UIButton *XIDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        XIDButton.frame = CGRectMake(DYFScreenWidth/4.f, posY, DYFScreenWidth/2.f, XIDHeight);
        if (DYFSecurityHelper.faceIDAvailable) {
            [XIDButton setImage:DYFImageNamed(@"faceID") forState:UIControlStateNormal];
            [XIDButton setTitle:@"点击进行面容解锁" forState:UIControlStateNormal];
        } else {
            [XIDButton setImage:DYFImageNamed(@"fingerprint") forState:UIControlStateNormal];
            [XIDButton setTitle:@"点击进行指纹解锁" forState:UIControlStateNormal];
        }
        XIDButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [XIDButton setTitleColor:DYFColorFromHex(0x3393F2, 1.0) forState:UIControlStateNormal];
        [XIDButton applyWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop space:10.f];
        _XIDButton = XIDButton;
    }
    [_XIDButton addTarget:self action:@selector(authIDButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_XIDButton];
    
    [self authIDButtonClicked:_XIDButton];
}

// 手势密码解锁
- (void)executeGestureCodeUnlock {
    // 错误的警告Label
    if (!_messageLabel) {
        CGFloat labelY = CGRectGetMaxY(self.avatarImageView.frame) + Margin;
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, labelY, DYFScreenWidth, DYFLabelHeight)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:16.f];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = DYFColorFromHex(0x000000, 1.f);
        _messageLabel.text = [NSString stringWithFormat:@"请输入手势密码"];
    }
    [self addSubview:_messageLabel];
    
    // 手势九宫格
    if (!_gestureView) {
        CGFloat gestureViewX = (DYFScreenWidth - DYFGestureWH) * 0.5;
        CGFloat gestureViewY = CGRectGetMaxY(self.messageLabel.frame) + DYFLabelHeight;
        _gestureView = [[DYFGestureView alloc] initWithFrame:CGRectMake(gestureViewX, gestureViewY, DYFGestureWH, DYFGestureWH)];
    }
    
    //是否显示指示手势划过的方向箭头
    _gestureView.hideGesturePath = NO;
    [self addSubview:_gestureView];
    
    @DYFWeakObject(self)
    [self.gestureView setGestureResult:^BOOL(NSString *gestureCode) {
        return [weak_self gestureResult:gestureCode];
    }];
}

#pragma mark - 内部方法

// 手势密码结果的处理
- (BOOL)gestureResult:(NSString *)gestureCode {
    if (gestureCode.length >= 3) {
        // 验证原密码
        NSString *saveGestureCode = [DYFSecurityHelper getGestureCode];
        if ([gestureCode isEqualToString:saveGestureCode]) {
            // 验证成功 进行进一步处理
            [self dismiss];
            return YES;
        }
        // 错误就提醒
        [self showGestureCodeErrorMessage];
    } else {
        [self showGestureCodeErrorMessage];
    }
    
    return NO;
}

// 手势密码错误的提示
- (void)showGestureCodeErrorMessage {
    self.messageLabel.text = kPasswordErrorMessage;
    self.messageLabel.textColor = CircleErrorColor;
    [self.messageLabel.layer shake];
}

// 移除view
- (void)dismiss {
    @DYFWeakObject(self)
    [UIView animateWithDuration:0.3f animations:^{
        weak_self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weak_self removeFromSuperview];
    }];
}

#pragma mark - action事件

- (void)authIDButtonClicked:(UIButton *)sender {
    if (self.touchBtnClick) {
        return;
    }
    
    self.touchBtnClick = YES;
    
    @DYFWeakObject(self)
    [DYFSecurityHelper.sharedHelper evaluateAuthID:^(BOOL success, BOOL inputPassword, NSString *message) {
        weak_self.touchBtnClick = NO;
        if (success) {
            [weak_self dismiss];
        }
    }];
}

// 登录其他账户
- (void)bottomButtonAction:(UIButton *)sender {
    if (self.bottomBtnClick) {
        return;
    }
    
    self.bottomBtnClick = YES;
    [self dismiss];
    self.bottomBtnClick = NO;
    
    !self.aCompletionHandler ?: self.aCompletionHandler();
}

@end
