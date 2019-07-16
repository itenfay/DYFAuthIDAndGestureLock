//
//  UIViewController+Message.m
//
//  Created by dyf on 2019/7/14.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "UIViewController+Message.h"

@implementation UIViewController (Message)

- (void)yf_showMessage:(NSString *)message {
    if (@available(iOS 8.0, *)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:NULL];
        [self performSelector:@selector(dismissMessageBox:) withObject:alertController afterDelay:1.f];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alertView show];
        [self performSelector:@selector(dismissMessageBox:) withObject:alertView afterDelay:1.f];
    }
}

- (void)dismissMessageBox:(id)objc {
    if ([objc isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alertController = (UIAlertController *)objc;
        [alertController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        UIAlertView *alertView = (UIAlertView *)objc;
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

@end
