//
//  CALayer+Shake.m
//
//  Created by dyf on 2017/7/21.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "CALayer+Shake.h"

@implementation CALayer (Shake)

- (void)shake {
    CAKeyframeAnimation * keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat x = 5;
    keyAnimation.values = @[@(-x),@(0),@(x),@(0),@(-x),@(0),@(x),@(0)];
    keyAnimation.duration = 0.3;
    keyAnimation.repeatCount = 2;
    keyAnimation.removedOnCompletion = YES;
    [self addAnimation:keyAnimation forKey:nil];
}

@end
