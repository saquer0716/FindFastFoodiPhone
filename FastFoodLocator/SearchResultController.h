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
@class SearchResultHeaderView;

@interface SearchResultController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (nonatomic, copy) NSString *selectedRestaurant;
@property (nonatomic, strong) RestaurantDataController *restaurantDataController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *travelTypeSegmentControl;
@property (strong, nonatomic) IBOutlet SearchResultHeaderView *resultTableViewHeader;

- (IBAction)changeTravelType:(id)sender;
@end
