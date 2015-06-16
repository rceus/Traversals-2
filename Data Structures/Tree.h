//
//  Tree.h
//  Data Structures
//
//  Created by Rishabh Jain on 6/11/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeButton.h"
#import "EdgeButton.h"

@interface Tree : NSObject
- (void)createTreeWith:(NSMutableArray*)nodeArray andRoot:(NodeButton*)rootButton;
@end
