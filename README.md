[如果此项目能帮助到你，就请你给一颗星。谢谢！(If this project can help you, please give it a star. Thanks!)](https://github.com/dgynfi/DYFAuthIDAndGestureLock)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/DYFAuthIDAndGestureLock.svg?style=flat)](http://cocoapods.org/pods/DYFAuthIDAndGestureLock)&nbsp;
![CocoaPods](http://img.shields.io/cocoapods/p/DYFAuthIDAndGestureLock.svg?style=flat)&nbsp;

## DYFAuthIDAndGestureLock

手势密码解锁和 TouchID (指纹) / FaceID(面容) 解锁，代码简洁高效。(Gesture passcode unlocking and TouchID (fingerprint) / FaceID (facial features) unlocking, its code is concise and efficient.)

## Group (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFAuthIDAndGestureLock/raw/master/images/g614799921.jpg" width="30%" />
</div>

## Installation

Using [CocoaPods](https://cocoapods.org):

```
pod 'DYFAuthIDAndGestureLock', '~> 1.0.2'
```

Or

```
# Install lastest version.
pod 'DYFAuthIDAndGestureLock'
```

## Preview

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFAuthIDAndGestureLock/raw/master/images/AuthIDAndGestureLockPreview.gif" width="30%" />
</div>

## Usage

- 添加Face ID隐私 (Add Privacy)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFAuthIDAndGestureLock/raw/master/images/faceid_privacy.png" width="50%" />
</div>

```
<key>NSFaceIDUsageDescription</key>
<string>验证Face ID，是否允许App访问？</string>
```

- 导入头文件 (Import Header)

```
#import "DYFAppLock.h"
```

- 手势密码和TouchID/FaceID设置 (Gesture Passcode and TouchID/FaceID Settings)

支持push和模态两种场景过渡 (Supporting push or modal transition)

```
- (IBAction)settingsAction:(id)sender {
    static BOOL pushOrPresent = YES;

    DYFAuthIDAndGestureLockSettingsController *vc = [[DYFAuthIDAndGestureLockSettingsController alloc] init];
    if (pushOrPresent) {
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // When presents view controller, please add navigation controller.
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:NULL];
    }

    pushOrPresent = !pushOrPresent;
}
```

- 验证 (Authentication)

```
- (void)executeAuthentication {
    BOOL isAuthIDOpen      = [DYFSecurityHelper authIDOpen];
    BOOL isGestureCodeOpen = [DYFSecurityHelper gestureCodeOpen];
    if (!isAuthIDOpen && !isGestureCodeOpen) {
        return;
    }

    DYFAuthenticationType type = DYFAuthenticationTypeGesture;
    if (isAuthIDOpen) {
        type = DYFAuthenticationTypeAuthID;
    }

    DYFAuthenticationView *authView = [[DYFAuthenticationView alloc] initWithFrame:[UIScreen mainScreen].bounds authenticationType:type];
    authView.avatarImage = [UIImage imageNamed:@"cat49334.jpg"];
    [authView show];

    [authView authenticateWithCompletion:^(BOOL success) {
        if (success) {
            // 进行相应的操作
            NSLog(@"验证成功");
        }
    }];

    [authView loginOtherAccountWithCompletion:^{
        // 进行其他账户登录操作
        NSLog(@"登录其他账户");
    }];
}
```

## Code Sample

- [Code Sample Portal](https://github.com/dgynfi/DYFAuthIDAndGestureLock/blob/master/Basic%20Files/ViewController.m)
