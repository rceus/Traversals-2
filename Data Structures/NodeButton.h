//
//  NodeButton.h
//  Data Structures
//
//  Created by Rishabh Jain on 6/11/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdgeButton.h"

@interface NodeButton : UIButton

@property (nonatomic) int identifier;
@property NodeButton *leftChild;
@property NodeButton *rightChild;
@property (nonatomic) NSString *currentState;
@property (nonatomic) NSArray *edgesAttached;
@property (nonatomic) int numberOfNodes;
//@property (nonatomic) NodeButtonon *parentEdge;
@property (nonatomic) UIButton *parentEdge;
@property (nonatomic) NodeButton *parent;

- (void)currentNode;
- (void)previousNode;
- (void)selectedNode;
- (void)normalNode;
- (void)doubleNode;

@end
