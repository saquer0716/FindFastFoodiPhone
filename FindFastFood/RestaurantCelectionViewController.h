//
//  RestaurantCelectionViewController.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-29.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IASKAppSettingsViewController.h"

@interface RestaurantCelectionViewController : UICollectionViewController <UIActionSheetDelegate>

@property (nonatomic, strong) IASKAppSettingsViewController *settingsViewController;
- (IBAction)settings:(id)sender;
- (IBAction)share:(id)sender;

@end
