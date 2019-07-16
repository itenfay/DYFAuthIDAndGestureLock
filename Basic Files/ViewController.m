//
//  ViewController.m
//
//  Created by dyf on 2017/7/21.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "ViewController.h"
#import "DYFSecurityHelper.h"
#import "DYFAuthenticationView.h"
#import "DYFAuthIDAndGestureLockSettingsController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"App Lock";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)settingsAction:(id)sender {
    DYFAuthIDAndGestureLockSettingsController *vc = [[DYFAuthIDAndGestureLockSettingsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)validationAction:(UIButton *)sender {
    [self execureAuthentication];
}

- (void)execureAuthentication {
    BOOL isAuthIDOpen = [DYFSecurityHelper authIDOpen];
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
            NSLog(@"验证成功");
        }
    }];
    
    [authView loginOtherAccountWithCompletion:^{
        NSLog(@"登录其他账户");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
