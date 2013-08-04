//
//  LocationsTableViewController.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-29.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantDataController.h"
#import <CoreLocation/CoreLocation.h>
#import "GADBannerView.h"

@class SearchResultHeaderView;

@interface SearchResultController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (nonatomic, copy) NSString *searchKeyword;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) RestaurantDataController *restaurantDataController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *travelTypeSegmentControl;
@property (strong, nonatomic) IBOutlet SearchResultHeaderView *resultTableViewHeader;

- (IBAction)changeTravelType:(id)sender;
@end
