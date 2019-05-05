//
//  DYFLoadingObject.h
//
//  Created by dyf on 2017/7/27.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "SVProgressHUD.h"

#import <Foundation/Foundation.h>

@interface DYFLoadingObject : NSObject

+ (void)startLoading;
+ (void)startLoadingWithText:(NSString *)text;
+ (void)stopLoading;

+ (void)stopLoadingAndShowOK:(NSString *)text;
+ (void)stopLoadingAndShowError:(NSString *)text;

+ (void)showOK:(NSString *)text;
+ (void)showError:(NSString *)text;

@end
