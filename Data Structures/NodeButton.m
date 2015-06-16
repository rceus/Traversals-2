//
//  NodeButton.m
//  Data Structures
//
//  Created by Rishabh Jain on 6/11/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//

#import "NodeButton.h"
#import "QuartzCore/QuartzCore.h"

@implementation NodeButton

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blueColor].CGColor;
    [self addTarget:self action:@selector(wasDragged:withEvent:)
       forControlEvents:UIControlEventTouchDragInside];
    self.numberOfNodes = 0;
    self.leftChild = nil;
    self.rightChild = nil;
    
    //[self addTarget:self action:@selector(currentNode) forControlEvents:UIControlEventTouchUpInside];
    //Add a selector using a delegate on Detail View Controller - Where the animations are present
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

- (void)currentNode{
    self.layer.borderColor = [UIColor redColor].CGColor;
    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (void)previousNode{
    self.layer.borderColor = [UIColor purpleColor].CGColor;
    [self setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
}

- (void)selectedNode{
    self.layer.borderColor = [UIColor colorWithRed:3/255.0f green:88/255.0f blue:66/255.0f alpha:1.0f].CGColor;
    [self setTitleColor:[UIColor colorWithRed:3/255.0f green:88/255.0f blue:66/255.0f alpha:1.0f] forState:UIControlStateNormal];

}

- (void)normalNode{
    self.layer.borderColor = [UIColor blueColor].CGColor;
    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

}

- (void)doubleNode{
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
}

@end
