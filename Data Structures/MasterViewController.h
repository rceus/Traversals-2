//
//  MasterViewController.h
//  Data Structures
//
//  Created by Rishabh Jain on 6/11/15.
//  Copyright (c) 2015 Rishabh Jain. All rights reserved.
//
#import "flurry.h"
#import "FlurryAdInterstitial.h"
#import "FlurryAdInterstitialDelegate.h"
#import "FlurryAdBanner.h"
#import "FlurryAdBannerDelegate.h"
#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController <FlurryAdBannerDelegate, FlurryAdInterstitialDelegate>


@end

