//
//  DYFGestureSettingsController.m
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFGestureSettingsController.h"
#import "DYFAppLockDefines.h"

#import "CALayer+Shake.h"
#import "UIView+Ext.h"
#import "UIButton+EdgeInsets.h"

#import "DYFCircleView.h"
#import "DYFGestureView.h"
#import "DYFGestureShapeView.h"

#import "DYFSecurityHelper.h"
#import "UIViewController+Message.h"

#define MarginTop                     30.f
#define Margin                        10.f
#define ShapeWH                       40.f
#define BottomHeight                  50.f

@interface DYFGestureSettingsController ()
// 手势缩略图
@property (nonatomic, strong) DYFGestureShapeView *shapeView;
// 手势九宫格
@property (nonatomic, strong) DYFGestureView *gestureView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic,   copy) NSString *firstGestureCode;

@property (nonatomic,   copy) DYFGestureSettingsBlock completionHandler;
@end

@implementation DYFGestureSettingsController

- (instancetype)init {
    self = [super init];
    if (self) {
        _gestureSettingsType = DYFGestureSettingsTypeChange;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBar];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)configureNavigationBar {
    self.title = NSLocalizedString(kSetGustureCodeText, nil);
    
    if (self.gestureSettingsType == DYFGestureSettingsTypeDelete) {
        self.title = NSLocalizedString(kVerifyGustureCodeText, nil);
    }
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -20;
    UIBarButtonItem *baclItem = [[UIBarButtonItem alloc] initWithCustomView:[self backButton]];
    self.navigationItem.leftBarButtonItems = @[spaceItem, baclItem];
}

- (void)setupSubviews {
    // 设置坐标从(0, 0)开始时，不会被导航条遮挡.
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.shapeView];
    [self.view addSubview:self.messageLabel];
    
    if (self.gestureSettingsType != DYFGestureSettingsTypeSet) {
        if ([self.shapeView superview]) {
            [self.shapeView removeFromSuperview];
        }
        self.messageLabel.top = MarginTop + Margin;
        self.messageLabel.text = NSLocalizedString(kPromptChangeGestureMessage, nil);
    }
    
    [self setupGestureView];
}

// 导航Item的返回按钮
- (UIButton *)backButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:DYFImageNamed(@"blue_back") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(3, -10, 3, 30);
    
    return button;
}

// 手势九宫格
- (void)setupGestureView {
    [self.view addSubview:self.gestureView];
    
    // 是否显示指示手势划过的方向箭头, 在初始设置手势密码的时候才显示, 其他的不用显示
    self.gestureView.showArrowDirection = (self.gestureSettingsType == DYFGestureSettingsTypeSet) ? YES : NO;
    
    @DYFWeakObject(self)
    [self.gestureView setGestureResult:^BOOL(NSString *gestureCode) {
        return [weak_self gestureResult:gestureCode];
    }];
}

// 验证手势密码成功后，修改手势密码
- (void)resetTopViews {
    if (self.gestureSettingsType != DYFGestureSettingsTypeChange) {
        return;
    }
    
    self.gestureSettingsType = DYFGestureSettingsTypeSet;
    if (![self.shapeView superview]) {
        [self.view addSubview:self.shapeView];
    }
    
    self.firstGestureCode = nil;
    
    self.messageLabel.top = MarginTop + ShapeWH + Margin;
    self.messageLabel.text = NSLocalizedString(kPromptDefaultMessage, nil);
    self.messageLabel.textColor = [UIColor blackColor];
}

#pragma mark - 懒加载

// 缩略图
- (DYFGestureShapeView *)shapeView {
    if (!_shapeView) {
        CGFloat shapeX = (DYFScreenWidth - ShapeWH) * 0.5;
        _shapeView = [[DYFGestureShapeView alloc] initWithFrame:CGRectMake(shapeX, MarginTop, ShapeWH, ShapeWH)];
        _shapeView.backgroundColor = [UIColor clearColor];
    }
    return _shapeView;
}

// 手势九宫格
- (DYFGestureView *)gestureView {
    if (!_gestureView) {
        CGFloat gestureViewX = (DYFScreenWidth - DYFGestureWH) * 0.5;
        CGFloat gestureViewY = MarginTop * 2 + Margin + ShapeWH + DYFLabelHeight;
        _gestureView = [[DYFGestureView alloc] initWithFrame:CGRectMake(gestureViewX, gestureViewY, DYFGestureWH, DYFGestureWH)];
    }
    return _gestureView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        CGFloat labelY = MarginTop + ShapeWH + Margin;
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(Margin, labelY, DYFScreenWidth - 2 * Margin, DYFLabelHeight)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:16.f];
        _messageLabel.text = NSLocalizedString(kPromptDefaultMessage, nil);
    }
    return _messageLabel;
}

#pragma mark - 对外方法

// 手势设置完成的回调
- (void)gestureSettingsWithCompletion:(DYFGestureSettingsBlock)completionHandler {
    self.completionHandler = completionHandler;
}

#pragma mark - action事件

// 点击返回设置失败
- (void)back {
    !self.completionHandler ?: self.completionHandler(NO);
    [self popVC];
}

#pragma mark - 对内方法

// 重设手势
- (void)resetGesture {
    //[self.navigationItem.rightBarButtonItem setEnabled:NO];
    self.shapeView.gestureCode = nil;
    self.firstGestureCode = nil;
    self.messageLabel.text = NSLocalizedString(kPromptDefaultMessage, nil);
    self.messageLabel.textColor = DYFColorFromHex(0x000000, 1.f);
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

// 手势密码的结果处理
- (BOOL)gestureResult:(NSString *)gestureCode {
    if (self.gestureSettingsType == DYFGestureSettingsTypeSet) {
        
        // 首次设置手势密码
        if (gestureCode.length >= 3) {
            
            if (!self.firstGestureCode) {
                
                self.shapeView.gestureCode = gestureCode;
                self.firstGestureCode = gestureCode;
                self.messageLabel.text = NSLocalizedString(kPromptSetAgainMessage, nil);
                
                return YES;
                
            } else if ([self.firstGestureCode isEqualToString:gestureCode]) {
                
                // 第二次绘制成功，返回上一页
                [DYFSecurityHelper setGestureCode:gestureCode];
                
                !self.completionHandler ?: self.completionHandler(YES);
                [self yf_showMessage:@"设置成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self popVC];
                });
                
                return YES;
            }
            
        }
        
        // 点数少于3 或者 前后不一致
        if (gestureCode.length < 3 || self.firstGestureCode != nil) {
            
            // 点数少于3 或者 前后不一致
            self.messageLabel.text = NSLocalizedString(gestureCode.length < 3 ? kPromptPointShortMessage : kPromptSetAgainErrorMessage, nil);
            self.messageLabel.textColor = DYFColorFromHex(0x000000, 1.f);
            [self.messageLabel.layer shake];
            
            [self performSelector:@selector(resetGesture) withObject:nil afterDelay:1.0];
            
            return NO;
            
        }
        
    } else if (self.gestureSettingsType == DYFGestureSettingsTypeDelete) {
        
        // 密码验证
        if ([self verifyGestureCode:gestureCode]) {
            // 验证成功，关闭手势密码
            [DYFSecurityHelper setGestureCode:nil];
            
            !self.completionHandler ?: self.completionHandler(YES);
            [self popVC];
            
            return YES;
        }
        
        return NO;
        
    } else if (self.gestureSettingsType == DYFGestureSettingsTypeChange) {
        
        // 修改手势密码，修改前先验证原密码
        if ([self verifyGestureCode:gestureCode]) {
            [self resetTopViews];
            return YES;
        }
        
        return NO;
        
    }
    
    return NO;
}

// 验证原密码
- (BOOL)verifyGestureCode:(NSString *)gestureCode {
    NSString *gCode = [DYFSecurityHelper getGestureCode];
    if ([gCode isEqualToString:gestureCode]) {
        return YES;
    } else {
        self.messageLabel.text = NSLocalizedString(kPromptPasswordErrorMessage, nil);
        self.messageLabel.textColor = DYFColorFromHex(0x000000, 1.f);
        [self.messageLabel.layer shake];
        
        return NO;
    }
}

- (void)dealloc {
    DYFDLog(@"%s",  __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
