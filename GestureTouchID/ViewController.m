//
//  ViewController.m
//
//  Created by dyf on 2017/7/21.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "ViewController.h"
#import "DYFSecurityHelper.h"
#import "DYFLoginVerifyView.h"
#import "DYFGestureTouchIDSettingController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)gestureTouchIDSetting:(id)sender {
    DYFGestureTouchIDSettingController *gtsc = [[DYFGestureTouchIDSettingController alloc] init];
    [self.navigationController pushViewController:gtsc animated:YES];
}

- (IBAction)validateGestureTouchID:(UIButton *)sender {
    [self execLoginVerify];
}

- (void)execLoginVerify {
    BOOL isTouchIDOpen = [DYFSecurityHelper touchIDOpenStatus];
    BOOL isGestureOpen = [DYFSecurityHelper gestureOpenStatus];
    if (!isTouchIDOpen && !isGestureOpen) {
        return;
    }
    
    DYFLoginVerifyType type = DYFLoginVerifyTypeGesture;
    if (isTouchIDOpen) {
        type = DYFLoginVerifyTypeTouchID;
    }
    
    DYFLoginVerifyView *verifyView = [[DYFLoginVerifyView alloc] initWithFrame:[UIScreen mainScreen].bounds verifyType:type];
    verifyView.headImage = [UIImage imageNamed:@"cat49334.jpg"];
    [verifyView showView];
    
    [verifyView loginVerifyResult:^(BOOL success) {
        if (success) {
            NSLog(@"TouchID验证成功");
        }
    }];
    
    [verifyView loginOtherAccountAction:^{
        NSLog(@"TouchID登录其他账户");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
