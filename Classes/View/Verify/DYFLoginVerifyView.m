//
//  DYFLoginVerifyView.m
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFLoginVerifyView.h"
#import "DYFDefinition.h"

#import "UIView+Ext.h"
#import "CALayer+Shake.h"
#import "UIButton+EdgeInsets.h"

#import "DYFGestureView.h"
#import "DYFCircleView.h"
#import "DYFGestureShapeView.h"
#import "DYFSecurityHelper.h"

NSString *const passwordErrorMessage = @"手势密码错误";

#define MarginTop     64.0
#define Margin        15.0
#define BottomHeight  44.0
#define HeadWH        70.0
#define TouchIDHeight 100.0

@interface DYFLoginVerifyView () <UIAlertViewDelegate>
// 手势九宫格
@property (nonatomic, strong) DYFGestureView *gestureView;
// 手势错误的提示
@property (nonatomic, strong) UILabel *messageLabel;
// 顶部的头像按钮
@property (nonatomic, strong) UIImageView *headImageView;
// 底部的切换登录方式按钮
@property (nonatomic, strong) UIButton *bottomButton;
// 指纹验证按钮
@property (nonatomic, strong) UIButton *touchIDButton;

@property (nonatomic, assign) DYFLoginVerifyType verifyType;
@property (nonatomic,  copy ) DYFLoginVerifyBlock block;
@property (nonatomic,  copy ) DYFLoginOtherAccountBlock aBlock;

// 防止按钮重复点击
@property (nonatomic, assign) BOOL bottomBtnClick;
@property (nonatomic, assign) BOOL touchBtnClick;
@end

@implementation DYFLoginVerifyView

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 默认指纹密码登录
        _verifyType = DYFLoginVerifyTypeTouchID;
        [self layoutUI:_verifyType];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame verifyType:(DYFLoginVerifyType)verifyType {
    self = [super initWithFrame:frame];
    if (self) {
        _verifyType = verifyType;
        [self layoutUI:verifyType];
    }
    return self;
}

#pragma mark - 对外方法

- (void)setHeadImage:(UIImage *)headImage {
    _headImageView.image = headImage;
}

- (UIImage *)headImage {
    return _headImageView.image;
}

// 验证结果的回调
- (void)loginVerifyResult:(DYFLoginVerifyBlock)block {
    self.block = block;
}

// 登录其他账户回调
- (void)loginOtherAccountAction:(DYFLoginOtherAccountBlock)block {
    self.aBlock = block;
}

// 显示view(此方法是加载在window上, 遮住导航条)
- (void)showView {
    [UIView animateWithDuration:0.25 animations:^{
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self];
    } completion:^(BOOL finished) {
        self.alpha = 1.0;
    }];
}

#pragma mark - 布局UI

// 根据验证类型布局UI
- (void)layoutUI:(DYFLoginVerifyType)verifyType {
    self.alpha = 0.5;
    self.backgroundColor = [UIColor whiteColor];
    
    // 顶部的头像和底部的切换登录方式按钮，是共有的
    
    // 头像
    if (!_headImageView) {
        CGFloat posX = (ScreenWidth - HeadWH) * 0.5;
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, MarginTop, HeadWH, HeadWH)];
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = HeadWH * 0.5;
        _headImageView.contentMode = UIViewContentModeScaleToFill;
    }
    _headImageView.image = DYFImageNamed(@"defaultAvatar");
    [self addSubview:_headImageView];
    
    // 底部按钮
    if (!_bottomButton) {
        CGFloat posY = ScreenHeight - BottomHeight * 1.2;
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor clearColor];
        _bottomButton.frame = CGRectMake(0.0, posY, ScreenWidth, BottomHeight);
        _bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [_bottomButton setTitleColor:UIColorFromHex(0x3393F2, 1.0) forState:UIControlStateNormal];
            [_bottomButton setTitle:@"登录其他账户" forState:UIControlStateNormal];
    }
    [_bottomButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bottomButton];
    
    switch (verifyType) {
        case DYFLoginVerifyTypeTouchID: {
            // 指纹密码登录
            [self loginVerifyTouchID];
            break;
        }
        case DYFLoginVerifyTypeGesture: {
            // 手势密码登录
            [self loginVerifyGesture];
            break;
        }
        default:
            break;
    }
}

// 指纹密码登录
- (void)loginVerifyTouchID {
    if (!_touchIDButton) {
        CGFloat posY = CGRectGetMaxY(_headImageView.frame) + TouchIDHeight;
        UIButton *touchIDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        touchIDButton.frame = CGRectMake(0.0, posY, ScreenWidth, TouchIDHeight);
        [touchIDButton setImage:DYFImageNamed(@"fingerprint") forState:UIControlStateNormal];
        [touchIDButton setTitle:@"点击进行指纹解锁" forState:UIControlStateNormal];
        touchIDButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [touchIDButton setTitleColor:UIColorFromHex(0x3393F2, 1.0) forState:UIControlStateNormal];
        [touchIDButton relayoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitleSpace:6];
        _touchIDButton = touchIDButton;
    }
    [_touchIDButton addTarget:self action:@selector(touchIDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_touchIDButton];
    [self touchIDButtonAction:_touchIDButton];
}

// 手势密码登录
- (void)loginVerifyGesture {
    // 错误的警告Label
    if (!_messageLabel) {
        CGFloat labelY = CGRectGetMaxY(self.headImageView.frame) + Margin;
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, labelY, ScreenWidth, LabelHeight)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:16.0];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = DYFCircleErrorBlackColor;
        _messageLabel.text = [NSString stringWithFormat:@"请输入手势密码"];
    }
    [self addSubview:_messageLabel];
    
    // 手势九宫格
    if (!_gestureView) {
        CGFloat gestureViewX = (ScreenWidth - GestureWH) * 0.5;
        CGFloat gestureViewY = CGRectGetMaxY(self.messageLabel.frame) + LabelHeight;
        _gestureView = [[DYFGestureView alloc] initWithFrame:CGRectMake(gestureViewX, gestureViewY, GestureWH, GestureWH)];
    }
    
    //是否显示指示手势划过的方向箭头
    _gestureView.hideGesturePath = NO;
    [self addSubview:_gestureView];
    
    DYFWeakSelf
    [self.gestureView setGestureResult:^BOOL(NSString *gestureCode) {
        return [weakSelf gestureResult:gestureCode];
    }];
}

#pragma mark - 内部方法

// 手势密码结果的处理
- (BOOL)gestureResult:(NSString *)gestureCode {
    if (gestureCode.length >= 4) {
        // 验证原密码
        NSString *saveGestureCode = [DYFSecurityHelper gainGestureCodeKey];
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
    self.messageLabel.text =  passwordErrorMessage;
    self.messageLabel.textColor = DYFCircleErrorColor;
    [self.messageLabel.layer shake];
}

// 移除view
- (void)dismiss {
    DYFWeakSelf
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - action事件

// 进行指纹解锁按钮的action
- (void)touchIDButtonAction:(UIButton *)sender {
    if (self.touchBtnClick) {
        return;
    }
    self.touchBtnClick = YES;
    DYFWeakSelf
    [[DYFSecurityHelper sharedInstance] openTouchID:^(BOOL success, BOOL inputPassword, NSString *message) {
        weakSelf.touchBtnClick = NO;
        if (success) {
            [weakSelf dismiss];
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
    if (self.aBlock) {
        self.aBlock();
    }
}

@end
