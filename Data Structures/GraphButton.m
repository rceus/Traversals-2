//
//  GraphButton.m
//  Data Structures
//
//  Created by Rishabh Jain on 6/16/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//

#import "GraphButton.h"

@implementation GraphButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blueColor].CGColor;
    [self addTarget:self action:@selector(wasDragged:withEvent:)
    forControlEvents:UIControlEventTouchDragInside];
    //self.numberOfNodes = 0;
    self.visited = NO;
    self.friends = [[NSMutableArray alloc] init];
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
    self.layer.borderColor = [UIColor greenColor].CGColor;
    [self setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
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
