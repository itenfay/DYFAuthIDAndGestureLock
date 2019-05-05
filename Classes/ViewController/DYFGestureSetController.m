//
//  DYFGestureSetController.m
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFGestureSetController.h"
#import "DYFDefinition.h"

#import "UIView+Ext.h"
#import "CALayer+Shake.h"
#import "UIButton+EdgeInsets.h"

#import "DYFGestureView.h"
#import "DYFCircleView.h"
#import "DYFGestureShapeView.h"
#import "DYFSecurityHelper.h"

NSString * const promptDefaultMessage =       @"绘制解锁图案";
NSString * const promptSetAgainMessage =      @"再次绘制解锁图案";
NSString * const promptSetAgainErrorMessage = @"前后设置不一致";
NSString * const promptChangeGestureMessage = @"请输入原手势密码";
NSString * const promptPointShortMessage =    @"连接至少4个点，请重新设置";
NSString * const promptPasswordErrorMessage = @"手势密码错误";

#define MarginTop     25.0
#define Margin        8.0
#define ShapeWH       40.0
#define BottomHeight  44.0

@interface DYFGestureSetController ()

// 手势缩略图
@property (nonatomic, strong) DYFGestureShapeView *shapeView;
// 手势九宫格
@property (nonatomic, strong) DYFGestureView *gestureView;
@property (nonatomic, strong) UILabel *messageLabel;
// 底部的验证登录密码按钮
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic,  copy ) NSString *firstGestureCode;
@property (nonatomic,  copy ) DYFGestureSetBlock block;

@end

@implementation DYFGestureSetController

- (instancetype)init {
    self = [super init];
    if (self) {
        _gestureSetType = DYFGestureSetTypeChange;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    [self setupSubviews];
}

- (void)setupSubviews {
    // 针对和UIScrollView类无关控件的处理，这样设置坐标从(0,0)开始时，不会被导航条遮挡.
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shapeView];
    [self.view addSubview:self.messageLabel];
    //[self.view addSubview:self.bottomButton];
    // 底部按钮，只有修改/删除type显示
    //self.bottomButton.hidden = (self.gestureSetType != DYFGestureSetTypeSetting) ? NO : YES;
    if (self.gestureSetType != DYFGestureSetTypeSetting) {
        if ([self.shapeView superview]) {
            [self.shapeView removeFromSuperview];
        }
        self.messageLabel.top = MarginTop + Margin;
        self.messageLabel.text = promptChangeGestureMessage;
    }
    [self setupGestureView];
}

- (void)setupNav {
    self.title = @"设置手势密码";
    
    if (self.gestureSetType == DYFGestureSetTypeDelete) {
        self.title = @"验证手势密码";
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self navItemLeftButton]];
}

// 导航Item的左按钮
- (UIButton *)navItemLeftButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0.0, 0.0, 50.0, 36.0);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [button setTitleColor:UIColorFromRGB(31, 144, 230, 1.0) forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:DYFImageNamed(@"blueBack") forState:UIControlStateNormal];
    [button relayoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitleSpace:5];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// 手势九宫格
- (void)setupGestureView {
    [self.view addSubview:self.gestureView];
    // 是否显示指示手势划过的方向箭头, 在初始设置手势密码的时候才显示, 其他的不用显示
    self.gestureView.showArrowDirection = self.gestureSetType == DYFGestureSetTypeSetting ? YES : NO;
    
    DYFWeakSelf
    [self.gestureView setGestureResult:^BOOL(NSString *gestureCode) {
        return [weakSelf gestureResult:gestureCode];
    }];
}

// 验证手势密码成功后，修改手势密码用到
- (void)resetTopViews {
    if (self.gestureSetType != DYFGestureSetTypeChange) {
        return;
    }
    self.gestureSetType = DYFGestureSetTypeSetting;
    if (![self.shapeView superview]) {
        [self.view addSubview:self.shapeView];
    }
    self.firstGestureCode = nil;
    self.bottomButton.hidden = YES;
    self.messageLabel.top = MarginTop + ShapeWH + Margin;
    self.messageLabel.text = promptDefaultMessage;
    self.messageLabel.textColor = [UIColor blackColor];
}

#pragma mark - 懒加载

// 缩略图
- (DYFGestureShapeView *)shapeView {
    if (!_shapeView) {
        CGFloat shapX = (ScreenWidth - ShapeWH) * 0.5;
        _shapeView = [[DYFGestureShapeView alloc] initWithFrame:CGRectMake(shapX, MarginTop, ShapeWH, ShapeWH)];
        _shapeView.backgroundColor = [UIColor clearColor];
    }
    return _shapeView;
}

// 手势九宫格
- (DYFGestureView *)gestureView {
    if (!_gestureView) {
        CGFloat gestureViewX = (ScreenWidth - GestureWH) * 0.5;
        CGFloat gestureViewY = MarginTop * 2.0 + Margin + ShapeWH + LabelHeight;
        _gestureView = [[DYFGestureView alloc] initWithFrame:CGRectMake(gestureViewX, gestureViewY, GestureWH, GestureWH)];
    }
    return _gestureView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        CGFloat labelY = MarginTop + ShapeWH + Margin;
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, labelY, ScreenWidth, LabelHeight)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:16.0];
        _messageLabel.text = promptDefaultMessage;
    }
    return _messageLabel;
}

// 底部按钮
- (UIButton *)bottomButton {
    if (!_bottomButton) {
        CGFloat posY = DYFViewHeight - BottomHeight * 1.5;
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor clearColor];
        _bottomButton.frame = CGRectMake(0.0, posY, ScreenWidth, BottomHeight);
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_bottomButton setTitleColor:UIColorFromHex(0x666666, 1.0) forState:UIControlStateNormal];
        [_bottomButton setTitle:@"验证登录密码" forState:UIControlStateNormal];
        //[_bottomButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

#pragma mark - 对外方法

// 设置手势完成的回调
- (void)gestureSetComplete:(DYFGestureSetBlock)block {
    self.block = block;
}

#pragma mark - action事件

- (void)back {
    // 点击返回设置失败
    if (self.block) {
        self.block(NO);
    }
    [self popViewController];
}

#pragma mark - 对内方法

// 重设手势
- (void)resetGesture {
    //[self.navigationItem.rightBarButtonItem setEnabled:NO];
    self.shapeView.gestureCode = nil;
    self.firstGestureCode = nil;
    self.messageLabel.text = promptDefaultMessage;
    self.messageLabel.textColor = [UIColor blackColor];
    self.bottomButton.hidden = YES;
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

// 手势密码结果的处理
- (BOOL)gestureResult:(NSString *)gestureCode {
    if (self.gestureSetType == DYFGestureSetTypeSetting) {
        // 首次设置手势密码
        if (gestureCode.length >= 4) {
            if (!self.firstGestureCode) {
                self.shapeView.gestureCode = gestureCode;
                self.firstGestureCode = gestureCode;
                self.messageLabel.text = promptSetAgainMessage;
                return YES;
            } else if ([self.firstGestureCode isEqualToString:gestureCode]) {
                // 第二次绘制成功，返回上一页
                [DYFSecurityHelper saveGestureCodeKey:gestureCode];
                if (self.block) {
                    self.block(YES);
                }
                [self popViewController];
                return YES;
            }
        }
        // 点数少于4 或者 前后不一致
        if (gestureCode.length < 4 || self.firstGestureCode != nil) {
            // 点数少于4 或者 前后不一致
            self.messageLabel.text = gestureCode.length < 4 ? promptPointShortMessage : promptSetAgainErrorMessage;
            self.messageLabel.textColor = DYFCircleErrorBlackColor;
            [self.messageLabel.layer shake];
            
            [self performSelector:@selector(resetGesture) withObject:nil afterDelay:1.0];
            
            return NO;
        }
        
    } else if (self.gestureSetType == DYFGestureSetTypeDelete) {
        // 关闭手势密码
        if ([self verifyGestureCodeWithCode:gestureCode]) {
            //密码验证成功，回调关闭你手势密码
            [DYFSecurityHelper saveGestureCodeKey:nil];
            if (self.block) {
                self.block(YES);
            }
            [self popViewController];
            return YES;
        }
        return NO;
        
    } else if (self.gestureSetType == DYFGestureSetTypeChange) {
        // 修改手势密码，修改前先验证原密码
        if ([self verifyGestureCodeWithCode:gestureCode]) {
            [self resetTopViews];
            return YES;
        }
        return NO;
    }
    
    return NO;
}

// 验证原密码
- (BOOL)verifyGestureCodeWithCode:(NSString *)gestureCode {
    NSString *saveGestureCode = [DYFSecurityHelper gainGestureCodeKey];
    if ([gestureCode isEqualToString:saveGestureCode]) {
        return YES;
    } else {
        self.messageLabel.text = promptPasswordErrorMessage;
        self.messageLabel.textColor = DYFCircleErrorBlackColor;
        [self.messageLabel.layer shake];
        return NO;
    }
}

- (void)dealloc {
    DYFDLog(@"** [%@ dealloc] **",  NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
