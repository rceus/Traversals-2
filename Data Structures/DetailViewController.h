//
//  DetailViewController.h
//  Data Structures
//
//  Created by Rishabh Jain on 6/11/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UILongPressNodeButton <NSObject>

- (void)userLongPressed:(UILongPressGestureRecognizer*)longPress Button:(UIButton*)button;
- (void)deleteNode:(UIButton*)button;

@end


@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *answerTraversal;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) NSMutableDictionary *graphList;

@end

