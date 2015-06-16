//
//  GraphButton.h
//  Data Structures
//
//  Created by Rishabh Jain on 6/16/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphButton : UIButton

@property (nonatomic) int identifier;
@property (nonatomic) NSString *currentState;
@property (nonatomic) NSArray *edgesAttached;
@property (nonatomic) int numberOfNodes;
@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) UIButton *parentEdge;
@property (nonatomic) BOOL visited;

- (void)currentNode;
- (void)previousNode;
- (void)selectedNode;
- (void)normalNode;
- (void)doubleNode;

@end
