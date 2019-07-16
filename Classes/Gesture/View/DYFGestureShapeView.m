//
//  DYFGestureShapeView.m
//
//  Created by dyf on 2017/7/24.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "DYFGestureShapeView.h"
#import "DYFCircleView.h"

@interface DYFGestureShapeView ()
@property (nonatomic, strong) NSMutableArray *numberArray;
@end

@implementation DYFGestureShapeView

- (NSMutableArray *)numberArray {
    if (!_numberArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:9];
        
        for (NSInteger i = 0; i < 9; i++) {
            NSNumber *n = [NSNumber numberWithInteger:0];
            [array addObject:n];
        }
        _numberArray = array;
    }
    return _numberArray;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef cr = UIGraphicsGetCurrentContext();
    
    CGFloat squareWH = MIN(rect.size.width, rect.size.height);
    CGFloat marginBorder = 3.f;
    CGFloat marginNear = 3.f;
    CGFloat circleWH = (squareWH - (marginBorder+marginNear) * 2)/3.0;
    
    for (NSInteger i = 0; i < 9; i++) {
        NSInteger currentRow = i / 3;
        NSInteger currentColumn = i % 3;
        CGFloat circleX = marginBorder + (marginNear + circleWH) * currentColumn;
        CGFloat circleY = marginBorder + (marginNear + circleWH) * currentRow;
        CGRect circleFrame = CGRectMake(circleX, circleY, circleWH, circleWH);
        
        CGContextAddEllipseInRect(cr, circleFrame);
        [CircleNormalColor set];
        
        NSNumber *n = [self.numberArray objectAtIndex:i];
        if (n.integerValue == 1) {
            CGContextFillPath(cr);
        } else {
            CGContextSetLineWidth(cr, 1.0);
            CGContextStrokePath(cr);
        }
    }
}

- (void)setGestureCode:(NSString *)gestureCode {
    _gestureCode = gestureCode;
    
    self.numberArray = nil;
    for (NSInteger i = 0; i < gestureCode.length; i++) {
        NSString *subStr = [gestureCode substringWithRange:NSMakeRange(i, 1)];
        NSInteger subInt = subStr.integerValue;
        [self.numberArray replaceObjectAtIndex:subInt withObject:[NSNumber numberWithInteger:1]];
    }
    
    [self setNeedsDisplay];
}

@end
