//
//  DYFDefinition.h
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#ifndef DYFDefinition_h
#define DYFDefinition_h

// 指纹密码是否开启的key
#define TouchID_Password_Open      @"TouchID_Password_Open"
// 手势密码是否开启的key
#define Gesture_Password_Open      @"Gesture_Password_Open"
// 记录手势密码的Key
#define Gesture_Code_Key           @"Gesture_Code_Key"
// 手势密码是否显示轨迹的key
#define Gesture_Password_Show      @"Gesture_Password_Show"

// 手势、指纹密码资源bundle名称
#define DYFGTResBundleName         @"DYFGestureTouchIDRes.bundle"

#define ScreenBounds  [UIScreen mainScreen].bounds
#define ScreenWidth   ScreenBounds.size.width
#define ScreenHeight  ScreenBounds.size.height
#define DYFViewHeight CGRectGetHeight(ScreenBounds) - 44.0 - 20.0 // 去掉导航条的高度

// 手势密码提示Label的高度
#define LabelHeight 20.0f
// 手势密码九宫格view的宽高
#define GestureWH   280.0f

// 手势、指纹密码资源bundle路径
#define DYFGTResBundlePath [[NSBundle mainBundle] pathForResource:DYFGTResBundleName ofType:nil]

// 通过名字获取图像
#define DYFImageNamed(name) [UIImage imageNamed:[DYFGTResBundlePath stringByAppendingPathComponent:(name)]]

// 对于block的弱引用
#define DYFWeakSelf __weak __typeof(self) weakSelf = self;

// User Defaults
#define NSStdUserDefaults  [NSUserDefaults standardUserDefaults]

// ios版本判断
#define DYFSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
// ios9+判断
#define iOS9plus (DYFSystemVersion >= 9.0)

// 根据16位Hex值转换成颜色，格式:UIColorFromHex(0xFF0000, 1.0)
#define UIColorFromHex(hex, alp) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alp]

// 根据RBG值转换成颜色, 格式:UIColorFromRGB(255, 255, 255, 1.0)
#define UIColorFromRGB(r, g, b, alp) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alp]

#ifdef DEBUG
    #define DYFDLog(fmt, ...) NSLog((@"[file:%s] [func:%s] [line:%d] " fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DYFDLog(...) {}
#endif

#endif /* DYFDefinition_h */
