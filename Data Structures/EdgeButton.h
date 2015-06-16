//
//  EdgeButton.h
//  Data Structures
//
//  Created by Rishabh Jain on 6/11/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeButton.h"

@interface EdgeButton : UIButton
//@property NodeButton* nodeButtonOne;
//@property NodeButton* nodeButtonTwo;

- (void)translateEdgeForPoint:(CGPoint*)one AndPoint:(CGPoint*)two;

@end
