//
//  DYFLoadingObject.m
//
//  Created by dyf on 2017/7/27.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFLoadingObject.h"

@implementation DYFLoadingObject

+ (void)startLoading {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
}

+ (void)startLoadingWithText:(NSString *)text {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:text];
}

+ (void)stopLoading {
    [SVProgressHUD dismiss];
}

+ (void)stopLoadingAndShowOK:(NSString *)text {
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showSuccessWithStatus:text];
}

+ (void)stopLoadingAndShowError:(NSString *)text {
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showErrorWithStatus:text];
}

+ (void)showOK:(NSString *)text {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showSuccessWithStatus:text];
}

+ (void)showError:(NSString *)text {
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showErrorWithStatus:text];
}

@end
