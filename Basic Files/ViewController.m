//
//  ViewController.m
//
//  Created by Tenfay on 2017/7/21.
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "ViewController.h"
#import "DYFAppLock.h"

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

- (IBAction)validationAction:(UIButton *)sender {
    [self executeAuthentication];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
