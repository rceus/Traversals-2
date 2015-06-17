//
//  DetailViewController.m
//  Data Structures
//
//  Created by Rishabh Jain on 6/11/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//

#import "DetailViewController.h"
#import "NodeButton.h"
#import "GraphButton.h"
#import "EdgeButton.h"

@interface DetailViewController ()

@end

@implementation DetailViewController{
    int currentCount;
    NSMutableArray *nodeList;
    NodeButton * root;
    NodeButton* selectedNodeOne;
    GraphButton* selectedGraphNode;
    NSMutableArray *inOrder, *preOrder, *postOrder, *BFS;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (void)configureView {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FlurryAdBanner *adBanner = [[FlurryAdBanner alloc] initWithSpace:@"Rishabh Jain"];
    adBanner.adDelegate = self;
    [adBanner fetchAndDisplayAdInView:self.view viewControllerForPresentation:self];

    [self configureView];
    currentCount = 0;
    nodeList = [[NSMutableArray alloc] init];
    inOrder = [[NSMutableArray alloc]init];
    preOrder = [[NSMutableArray alloc]init];
    postOrder = [[NSMutableArray alloc]init];
    BFS = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor blackColor];
    self.answerTraversal.textColor = [UIColor whiteColor];
    self.labelAnswer.textColor = [UIColor whiteColor];
    self.labelAnswer.text = @"";
    if ([_detailItem  isEqual: @"Breadth First Search"] || [_detailItem  isEqual: @"Depth First Search"]) {
        self.answerTraversal.text = @"Long Press on Node to Traverse!";
        return;
    }
    self.answerTraversal.text = @"Click Traverse when done making Graph!";
}


- (IBAction)createNode:(UIButton *)sender {
    if ([_detailItem  isEqual: @"Breadth First Search"] || [_detailItem  isEqual: @"Depth First Search"]) {
        [self createGraphNodeButton];
        return;
    }
    [self createNodeButton];
}

- (void)createGraphNodeButton{
    NSString *string = [NSString stringWithFormat:@"%d", currentCount];
    GraphButton *touchButton = [GraphButton buttonWithType:UIButtonTypeCustom];
    [touchButton setTitle:string forState:UIControlStateNormal];
    [touchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [touchButton sizeToFit];
    touchButton.center = CGPointMake(self.view.frame.size.width/2, 150);
    
    //Add Long Press For Starting BFS
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] init];
    [gr addTarget:self action:@selector(userLongPressedGraph:)];
    [touchButton addGestureRecognizer:gr];

    //Handle the case for Edges
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [touchButton addGestureRecognizer:tapGesture];
    
    [self.view addSubview:touchButton];
    touchButton.tag = currentCount;
    touchButton.identifier = (int) currentCount;
    [nodeList addObject:touchButton];
    currentCount++;
}

- (void)createNodeButton{
    NSString *string = [NSString stringWithFormat:@"%d", currentCount];
    NodeButton *touchButton = [NodeButton buttonWithType:UIButtonTypeCustom];
    //NodeButton *touchButton = [[NodeButton alloc] init];
    [touchButton setTitle:string forState:UIControlStateNormal];
    [touchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    [touchButton sizeToFit];
    touchButton.center = CGPointMake(self.view.frame.size.width/2, 150);
    
    //Add Long Press for Delete
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] init];
    [gr addTarget:self action:@selector(userLongPressed:)];
    [touchButton addGestureRecognizer:gr];
    
    //Add Double Tap for Edge Creation
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [touchButton addGestureRecognizer:tapGesture];

    [self.view addSubview:touchButton];
    
    if (currentCount == 0) {
        root = touchButton;
    }
    
    //This will be an identifier for the Tree Class
    touchButton.tag = currentCount;
    touchButton.identifier = (int) currentCount;
    currentCount++;
    //Update Dictionaries
    [nodeList addObject:touchButton];
}

- (void)handleTapGestureForGraph:(UITapGestureRecognizer*)sender{
    EdgeButton *edgeButton = [EdgeButton buttonWithType:UIButtonTypeSystem];
    [edgeButton sizeToFit];
    
    CGPoint centerPointOne = [selectedGraphNode center];
    CGPoint centerPointTwo = [(GraphButton*)sender.view center];
    
    double centerX = (centerPointOne.x + centerPointTwo.x)/2;
    double centerY = (centerPointOne.y + centerPointTwo.y)/2;

    edgeButton.center = CGPointMake(centerX, centerY);
    [edgeButton translateEdgeForPoint:&centerPointOne AndPoint:&centerPointTwo];

    [self.view addSubview:edgeButton];
    [selectedGraphNode normalNode];
    [selectedGraphNode.friends addObject:(GraphButton*)sender.view];
    [((GraphButton*)sender.view).friends addObject:selectedGraphNode];
    //[self addLeftRightChild:(NodeButton*)sender.view ForNode:selectedNodeOne];
    selectedGraphNode = nil;
}

- (void)handleTapGesture:(UITapGestureRecognizer*)sender{
    
    NSLog(@"Double Tapped: %@", sender.view);
    
    if ([_detailItem  isEqual: @"Breadth First Search"] || [_detailItem isEqual: @"Depth First Search"]) {
        if (selectedGraphNode == nil) {
            [(GraphButton*)sender.view selectedNode];
            selectedGraphNode = (GraphButton*)sender.view;
            return;
        }
        [self handleTapGestureForGraph:sender];
        return;
    }

    if (selectedNodeOne == nil) {
        [(NodeButton*)sender.view selectedNode];
        selectedNodeOne = (NodeButton*)sender.view;
        return;
    }

    if (selectedNodeOne.numberOfNodes == 2) {
        [selectedNodeOne normalNode];
        selectedNodeOne = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"There exists two children already."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (selectedNodeOne == (NodeButton*)sender.view) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"Cannot connect to itself."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [selectedNodeOne normalNode];
        selectedNodeOne = nil;
        return;
    }
    
    if ((NodeButton*)sender.view == selectedNodeOne.leftChild) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"Left and right child cannot be the same."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [selectedNodeOne normalNode];
        selectedNodeOne = nil;
        return;
    }
    
    //Root Node Parent Not Working
    if (((NodeButton*)sender.view) == root) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"Cannot become a parent of root."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [selectedNodeOne normalNode];
        selectedNodeOne = nil;
        return;
    }
    
    if (((NodeButton*)sender.view).parent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"Node already has a parent."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [selectedNodeOne normalNode];
        selectedNodeOne = nil;
        return;
    }
    
    EdgeButton *edgeButton = [EdgeButton buttonWithType:UIButtonTypeSystem];
    [edgeButton sizeToFit];
    
    CGPoint centerPointOne = [selectedNodeOne center];
    CGPoint centerPointTwo = [(NodeButton*)sender.view center];
    
    double centerX = (centerPointOne.x + centerPointTwo.x)/2;
    double centerY = (centerPointOne.y + centerPointTwo.y)/2;
    
    NSLog(@"EdgeStart: %f, %f", centerX, centerY);
    edgeButton.center = CGPointMake(centerX, centerY);
    [edgeButton translateEdgeForPoint:&centerPointOne AndPoint:&centerPointTwo];
    
    //We could have a problem here because of the edgebutton
    ((NodeButton*)sender.view).parentEdge = edgeButton;
    [self.view addSubview:edgeButton];
    [selectedNodeOne normalNode];
    
    [self addLeftRightChild:(NodeButton*)sender.view ForNode:selectedNodeOne];
    selectedNodeOne = nil;
}

- (void)addLeftRightChild:(NodeButton*)toNode ForNode:(NodeButton*)fromNode{
    if (fromNode.leftChild == Nil) {
        fromNode.leftChild = toNode;
    } else if (fromNode.rightChild == nil){
        fromNode.rightChild = toNode;
    }
    fromNode.numberOfNodes++;
    toNode.parent = fromNode;
}

- (void)userLongPressed:(UILongPressGestureRecognizer*)longPress{
    
    NSLog(@"Long Pressed");
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
        if ([root isEqual:longPress.view]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Delete root in the very end!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Node"
                                                        message:@"The node and all its connections will now be deleted!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        //[self performInorder];
        [self deleteNode:longPress];
    }
}

- (void)deleteNode:(UILongPressGestureRecognizer*)longPress{
    //Delete from the NodeButton Lists Here Clean Up the Edge Lists
    NodeButton *buttonToBeDeleted = (NodeButton*)longPress.view;
    if (buttonToBeDeleted.parent.leftChild == buttonToBeDeleted) {
        buttonToBeDeleted.parent.numberOfNodes--;
        buttonToBeDeleted.parent.leftChild = nil;
    } else if(buttonToBeDeleted.parent.rightChild == buttonToBeDeleted){
        buttonToBeDeleted.parent.numberOfNodes--;
        buttonToBeDeleted.parent.rightChild = nil;
    }
    
    buttonToBeDeleted.parent = nil;
    [buttonToBeDeleted.parentEdge removeFromSuperview];
    buttonToBeDeleted.parentEdge = nil;
    //delete the parent edge here
    
    if (buttonToBeDeleted.leftChild) {
        buttonToBeDeleted.leftChild.parent = nil;
        [buttonToBeDeleted.leftChild.parentEdge removeFromSuperview];
        buttonToBeDeleted.leftChild.parentEdge = nil;
    }
    
    if (buttonToBeDeleted.rightChild) {
        buttonToBeDeleted.rightChild.parent = nil;
        [buttonToBeDeleted.rightChild.parentEdge removeFromSuperview];
        buttonToBeDeleted.rightChild.parentEdge = nil;
    }
    
    [nodeList removeObject:buttonToBeDeleted];
    currentCount--;
    [buttonToBeDeleted removeFromSuperview];
}

- (void)refreshNodes{
    for (int i = 0; i < nodeList.count; i++) {
        [(NodeButton*)nodeList[i] normalNode];
    }
    
    [self.view setNeedsDisplay];
}

- (IBAction)startTraversal:(UIBarButtonItem *)sender {
    
    [self refreshNodes];
    
    [inOrder removeAllObjects];
    [preOrder removeAllObjects];
    [postOrder removeAllObjects];
    
    if (nodeList.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                        message:@"Nothing to traverse."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if ([_detailItem  isEqual: @"In-Order Traversal"]) {
        [self performInorder];
    } else if ([_detailItem isEqual:@"Pre-Order Traversal"]){
        [self performPreorder];
    } else if ([_detailItem isEqual:@"Post-Order Traversal"]){
        [self performPostorder];
    } else if ([_detailItem isEqual:@"Comparison of Tree Traversals"]){
        [self allThreeAtOnce];
    }
}


- (void)colorInOrder:(NSTimer*)timer{
    NSLog(@"");
    int index = [timer.userInfo intValue];
    if (index > 0) {
        [(NodeButton*)inOrder[index-1] previousNode];
    }
        [(NodeButton*)inOrder[index] currentNode];
        [self.view setNeedsDisplay];
}

- (void)colorPreOrder:(NSTimer*)timer{
    NSLog(@"");
    int index = [timer.userInfo intValue];
    if (index > 0) {
        [(NodeButton*)preOrder[index-1] previousNode];
    }
    [(NodeButton*)preOrder[index] currentNode];
    [self.view setNeedsDisplay];
}

- (void)colorPostOrder:(NSTimer*)timer{
    int index = [timer.userInfo intValue];
    if (index > 0) {
        [(NodeButton*)postOrder[index-1] previousNode];
    }
    [(NodeButton*)postOrder[index] currentNode];
    [self.view setNeedsDisplay];
}

- (void) performInorder{
    [self inOrderTraversalFrom:root For:inOrder];
    for (int i = 0; i < inOrder.count; i++) {
        [NSTimer    scheduledTimerWithTimeInterval:i*3
                                            target:self
                                          selector:@selector(colorInOrder:)
                                          userInfo:@(i)
                                           repeats:NO];
    }
    
    NSString *answer = [[NSString alloc] init];
    for (int i = 0; i < inOrder.count; i++) {
        answer = [answer stringByAppendingString:[NSString stringWithFormat:@" %d ", ((NodeButton*)inOrder[i]).identifier]];
    }
    self.labelAnswer.text = answer;

}

- (void) performPreorder{
    [self preOrderTraversalFrom:root For:preOrder];
    for (int i = 0; i < preOrder.count; i++) {
        [NSTimer    scheduledTimerWithTimeInterval:i*3
                                            target:self
                                          selector:@selector(colorPreOrder:)
                                          userInfo:@(i)
                                           repeats:NO];
    }
    
    NSString *answer = [[NSString alloc] init];
    for (int i = 0; i < preOrder.count; i++) {
        answer = [answer stringByAppendingString:[NSString stringWithFormat:@" %d ", ((NodeButton*)preOrder[i]).identifier]];
    }
    self.labelAnswer.text = answer;

}

- (void) performPostorder{
    [self postOrderTraversalFrom:root For:postOrder];
    for (int i = 0; i < postOrder.count; i++) {
        [NSTimer    scheduledTimerWithTimeInterval:i*3
                                            target:self
                                          selector:@selector(colorPostOrder:)
                                          userInfo:@(i)
                                           repeats:NO];
    }
    
    NSString *answer = [[NSString alloc] init];
    for (int i = 0; i < postOrder.count; i++) {
        answer = [answer stringByAppendingString:[NSString stringWithFormat:@" %d ", ((NodeButton*)postOrder[i]).identifier]];
    }
    self.labelAnswer.text = answer;


}


- (void)colorAll:(NSTimer*)timer{
    int index = [timer.userInfo intValue];
    
    [self refreshNodes];
    
    [(NodeButton*)postOrder[index] currentNode];
    [(NodeButton*)inOrder[index] previousNode];
    [(NodeButton*)preOrder[index] selectedNode];
    
    if ((NodeButton*)postOrder[index] == (NodeButton*)preOrder[index]) {
        [(NodeButton*)postOrder[index] doubleNode];
    }
    
    if ((NodeButton*)postOrder[index] == (NodeButton*)inOrder[index]) {
        [(NodeButton*)postOrder[index] doubleNode];
    }
    
    if ((NodeButton*)inOrder[index] == (NodeButton*)preOrder[index]) {
        [(NodeButton*)inOrder[index] doubleNode];
    }
    
    [self.view setNeedsDisplay];
}

- (void)allThreeAtOnce{
    self.answerTraversal.text = @"Green: Pre, Purple: In, Red: Post, Orange: Common";
    [self postOrderTraversalFrom:root For:postOrder];
    [self preOrderTraversalFrom:root For:preOrder];
    [self inOrderTraversalFrom:root For:inOrder];
    for (int i = 0; i < postOrder.count; i++) {
        [NSTimer    scheduledTimerWithTimeInterval:i*3
                                            target:self
                                          selector:@selector(colorAll:)
                                          userInfo:@(i)
                                           repeats:NO];
    }
    
    NSString *answer = [[NSString alloc] init];
    answer = [answer stringByAppendingString:@"Post:"];
    for (int i = 0; i < postOrder.count; i++) {
        answer = [answer stringByAppendingString:[NSString stringWithFormat:@" %d ", ((NodeButton*)postOrder[i]).identifier]];
    }
    answer = [answer stringByAppendingString:@"\rIn:"];
    for (int i = 0; i < inOrder.count; i++) {
        answer = [answer stringByAppendingString:[NSString stringWithFormat:@" %d ", ((NodeButton*)inOrder[i]).identifier]];
    }
    answer = [answer stringByAppendingString:@"\rPre:"];
    for (int i = 0; i < preOrder.count; i++) {
        answer = [answer stringByAppendingString:[NSString stringWithFormat:@" %d ", ((NodeButton*)preOrder[i]).identifier]];
    }
    self.labelAnswer.text = answer;

}

- (void)inOrderTraversalFrom:(NodeButton*)nodeButton For:(NSMutableArray*)inOrderArray{
    if (nodeButton) {
        if (nodeButton.leftChild) {
            [self inOrderTraversalFrom:nodeButton.leftChild For:inOrderArray];
        }
        
        NSLog(@"%d", nodeButton.identifier);
        //[nodeButton currentNode];
        [inOrderArray addObject:nodeButton];
        //[self.view setNeedsDisplay];
        
        if (nodeButton.rightChild) {
            [self inOrderTraversalFrom:nodeButton.rightChild For:inOrderArray];
        }
    }
}

- (void)preOrderTraversalFrom:(NodeButton*)nodeButton For:(NSMutableArray*)preOrderArray{
    if (nodeButton) {
        [preOrderArray addObject:nodeButton];
        NSLog(@"%d", nodeButton.identifier);
        
        if (nodeButton.leftChild) {
            [self inOrderTraversalFrom:nodeButton.leftChild For:preOrderArray];
        }
        
        if (nodeButton.rightChild) {
            [self inOrderTraversalFrom:nodeButton.rightChild For:preOrderArray];
        }
    }
}

- (void)postOrderTraversalFrom:(NodeButton*)nodeButton For:(NSMutableArray*)postOrderArray{
    if (nodeButton) {
        if (nodeButton.leftChild) {
            [self inOrderTraversalFrom:nodeButton.leftChild For:postOrderArray];
        }
        
        if (nodeButton.rightChild) {
            [self inOrderTraversalFrom:nodeButton.rightChild For:postOrderArray];
        }
        
        [postOrderArray addObject:nodeButton];
        NSLog(@"%d", nodeButton.identifier);
    }
}

/////////////////////////////////// BFS ////////////////////////////////////////

- (void)colorGraph:(NSTimer*)timer{
    NSLog(@"");
    int index = [timer.userInfo intValue];
    if (index > 0) {
        [(GraphButton*)BFS[index-1] previousNode];
    }
    [(GraphButton*)BFS[index] currentNode];
    [self.view setNeedsDisplay];
}

- (void)userLongPressedGraph:(UILongPressGestureRecognizer*)longPress{
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"Performing Graph Algorithm."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self refreshNodes];
    if ([_detailItem  isEqual: @"Breadth First Search"]) {
        [self breadthFirstSearchOnNode:(GraphButton*)longPress.view andAnswer:BFS];
    } else {
        [self depthFirstSearchOnNode:(GraphButton*)longPress.view andAnswer:BFS];
    }
    for (int i = 0; i < BFS.count; i++) {
        [NSTimer    scheduledTimerWithTimeInterval:i*3
                                            target:self
                                          selector:@selector(colorGraph:)
                                          userInfo:@(i)
                                           repeats:NO];
    }
    NSString *answer = [[NSString alloc] init];
    for (int i = 0; i < BFS.count; i++) {
        answer = [answer stringByAppendingString:[NSString stringWithFormat:@" %d ", ((GraphButton*)BFS[i]).identifier]];
    }
    self.labelAnswer.text = answer;
}

- (void)breadthFirstSearchOnNode:(GraphButton*)startNode andAnswer:(NSMutableArray*)BFSAnswer{
    NSMutableArray * BFSQueue = [[NSMutableArray alloc] init];
    [BFSQueue addObject:startNode];
    while (BFSQueue.count > 0) {
        GraphButton *tempNode = [BFSQueue objectAtIndex:0];
        if (tempNode.visited == NO) {
            [BFSAnswer addObject:tempNode];
        }
        tempNode.visited = YES;
        [BFSQueue removeObjectAtIndex:0];
        NSLog(@"%d", tempNode.identifier);
        NSLog(@"%lu", (unsigned long)tempNode.friends.count);
        for (int i = 0; i < tempNode.friends.count; i++) {
            GraphButton *friendNode = tempNode.friends[i];
            if (friendNode.visited == NO) {
                [BFSQueue addObject:friendNode];
            }
        }
    }
}

- (void)depthFirstSearchOnNode:(GraphButton*)startNode andAnswer:(NSMutableArray*)BFSAnswer{
    NSMutableArray * DFSStack = [[NSMutableArray alloc] init];
    [DFSStack addObject:startNode];
    while (DFSStack.count > 0) {
        GraphButton *tempNode = [DFSStack lastObject];
        if (tempNode.visited == YES) {
            continue;
        }
        tempNode.visited = YES;
        [BFSAnswer addObject:tempNode];
        [DFSStack removeLastObject];
        NSLog(@"%d", tempNode.identifier);
        NSLog(@"%lu", (unsigned long)tempNode.friends.count);
        for (int i = 0; i < tempNode.friends.count; i++) {
            GraphButton *friendNode = tempNode.friends[i];
            if (friendNode.visited == NO) {
                [DFSStack addObject:friendNode];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
