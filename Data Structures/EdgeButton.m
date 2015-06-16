//
//  EdgeButton.m
//  Data Structures
//
//  Created by Rishabh Jain on 6/11/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//

#import "EdgeButton.h"
//static BOOL flag = YES;

@implementation EdgeButton{
    CGRect rectangle;
    UIColor *star;
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
    NSLog(@"Reached Edge Draw Rect:");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetShouldAntialias(ctx, YES);
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    
    CGContextSetStrokeColorWithColor(ctx,[UIColor blueColor].CGColor);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
//    [self addTarget:self action:@selector(wasDragged:withEvent:)
//   forControlEvents:UIControlEventTouchDragInside];
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:button] anyObject];
    CGPoint previousLocation = [touch previousLocationInView:button];
    
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    button.center = CGPointMake(button.center.x + delta_x,
                                button.center.y + delta_y);
    
}

- (void)translateEdgeForPoint:(CGPoint*)one AndPoint:(CGPoint*)two{
    NSLog(@"%f \r %f ", one->x, two->x);
    CGRect newShape = CGRectMake(one->x, one->y, (two->x - one->x), (two->y - one->y));
    
    NSLog(@"New Shape Width From Subtraction: %f - %f", two->x, one->x);
    NSLog(@"New Shape: %f", newShape.size.height);
    NSLog(@"Old Shape: %f", self.frame.size.height);
    NSLog(@"Ratio: %f", newShape.size.width/self.frame.size.width);
    NSLog(@"Ratio: %f", newShape.size.height/self.frame.size.height);
    
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, newShape.size.width/self.frame.size.width, newShape.size.height/self.frame.size.height);
    //self.transform = CGAffineTransformMakeScale(newShape.size.width/self.frame.size.width, newShape.size.height/self.frame.size.height);
}


@end
