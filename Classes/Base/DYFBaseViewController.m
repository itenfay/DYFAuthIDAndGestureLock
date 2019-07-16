//
//  DYFBaseViewController.m
//
//  Created by dyf on 2017/8/2.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFBaseViewController.h"

@interface DYFBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation DYFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
