//
//  LocationsTableViewController.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-29.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "SearchResultController.h"
#import <CoreLocation/CoreLocation.h>
#import "GoogleMapViewController.h"
#import "AppleMapViewController.h"
#import "MapViewController.h"
#import "SearchResultHeaderView.h"
#import "Restaurant.h"
#import "MapSearchController.h"
#import "SearchResultHeaderView.h"
#import "SVProgressHUD.h"
#import "ApiKey.h"

@interface SearchResultController ()
{
    int selectedMap; 
    int travelType;
    
//    UIAlertView *loadingDialog;
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    
    CLLocation *currentLocation;
    
    MapSearchController *mapSearchController;
}


@end

@implementation SearchResultController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedMap = [[NSUserDefaults standardUserDefaults] integerForKey:@"used_map_preference"];
    
    _resultTableView.autoresizingMask =
    UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    //config table header view
    CGRect viewRect = CGRectMake(0, 0, 320, 44);
//    _resultTableViewHeader = [[SearchResultHeaderView alloc] initWithFrame:viewRect];
    [_resultTableViewHeader initializeWithFrame:viewRect];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderTap:)];

    [_resultTableViewHeader addGestureRecognizer:tapGesture];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshResultList)];
    //[self configureToolBar];
    
    _restaurantDataController = [[RestaurantDataController alloc] init];
    [_restaurantDataController setNameOfRestaurant:_selectedRestaurant];

    
    mapSearchController = [[MapSearchController alloc] initWithMapType:selectedMap dataSrc:_restaurantDataController.restaurantData.restaurantArray];
    
    locationManager = [[CLLocationManager alloc] init];
    
    //check [CLLocationManager locationServicesEnabled];
    
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([self checkLocationService]) {
        [locationManager startUpdatingLocation];
    }
}

- (BOOL)checkLocationService
{
    if (![CLLocationManager locationServicesEnabled]) {
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Location service not enabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    }
    
    [SVProgressHUD showWithStatus:@"Getting current location..." maskType:SVProgressHUDMaskTypeBlack];
    return YES;
}

//- (void)configAlertDialog
//{
//    loadingDialog = [[UIAlertView alloc] initWithTitle:@"Getting current location..." message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    [loadingDialog show];
//    
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    
//    spinner.center = CGPointMake(loadingDialog.bounds.size.width / 2, loadingDialog.bounds.size.height - 50);
//    
//    [loadingDialog addSubview:spinner];
//    [spinner startAnimating];
//    loadingDialog.opaque = NO;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [super viewWillAppear:animated];
}

- (IBAction)refreshResultList
{
    if ([self checkLocationService]) {
        currentLocation = nil;
        [SVProgressHUD showWithStatus:@"Getting current location..." maskType:SVProgressHUDMaskTypeBlack];
        [locationManager startUpdatingLocation];
    }
}

- (void)searchForNearbyRestaurant
{
    [SVProgressHUD showWithStatus:@"Searching nearby resaurant..." maskType:SVProgressHUDMaskTypeBlack];
    
    [mapSearchController searchFor:_selectedRestaurant fromLocation:currentLocation.coordinate travelBy:travelType onComplete:^(NSError *error, int resultCode) {
        if (error) {
            NSLog(@"%@", error.description);
        } else {
            if (resultCode == OK) {
                
            } else if (resultCode == ZERO_RESULT){
                
            } else if (resultCode == EXCEED_LIMIT){
                
            } else {
                //unknown
            }
            
            [_restaurantDataController sortRestaurantListInType:travelType];
            
            _restaurantDataController.restaurantData.distanceAvailable = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //dismiss with result == 0 situation
            [SVProgressHUD dismiss];
            [_resultTableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_restaurantDataController countOfRestaurantLocations];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Restaurant *restaurant = [_restaurantDataController restaurantInRestaurantListAtIndex:indexPath.row];
    
    if (travelType == DRIVING) {
        if (restaurant.distanceTextDriving) {
            cell.textLabel.text = restaurant.distanceTextDriving;
        }else{
            cell.textLabel.text = @"distance not available";
        }
        
    }else if (travelType == WALKING) {
        if (restaurant.distanceTextWalking) {
            cell.textLabel.text = restaurant.distanceTextWalking;
        }else{
            cell.textLabel.text = @"distance not available";
        }
    }
    cell.detailTextLabel.text = restaurant.vicinity;
    
    return cell;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    CGRect frame = _resultTableView.frame;
//    
//    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
//        frame.size.width = screenHeight;
//    }else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
//        frame.size.width = screenWidth;
//    }
//    
//    [_resultTableView setNeedsLayout];
//    
//    _resultTableView.frame = frame;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configueResultMapControllerForIndexPath:indexPath];
    
    [_resultTableView deselectRowAtIndexPath:indexPath animated:YES];
}

//when global location service is disabled and this app location service is enabled, this didFailWithError is not returned.
//so do check location service when refreshing.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    [_resultTableViewHeader changeLocationVicinity:@"Location unavailable"];
    
    NSString *dialogMsg;
    if (error.code == kCLErrorDenied) {
        dialogMsg = @"App location service disabled";
    }else {
        dialogMsg = @"Failed to get your location";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:dialogMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    
    if (currentLocation) {
        return;
    }
    
    currentLocation = locations.lastObject;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.lastObject;
            
            NSString *vicinity = [self buildVicinityFromPlaceMark:placemark];
            [_resultTableViewHeader changeLocationVicinity:vicinity];
            
            [self searchForNearbyRestaurant];
            
        }else {
            NSLog(@"%@", error.debugDescription);
            [SVProgressHUD dismiss];
            [_resultTableViewHeader changeLocationVicinity:@"Location unavailable"];
        }
    }];
}

- (NSString *)buildVicinityFromPlaceMark:(CLPlacemark *)placemark
{
    NSMutableString *vicinity = [NSMutableString stringWithString:@""];
//    if (placemark.subThoroughfare) {
//        [vicinity appendString:placemark.subThoroughfare];
//        [vicinity appendString:@", "];
//    }
    if (placemark.thoroughfare) {
        [vicinity appendString:placemark.thoroughfare];
        [vicinity appendString:@", "];
    }
    
    if (placemark.locality) {
        [vicinity appendString:placemark.locality];
        [vicinity appendString:@", "];
    }
    
    if (placemark.administrativeArea) {
        [vicinity appendString:placemark.administrativeArea];
        [vicinity appendString:@", "];
    }
//    
//    if (placemark.country) {
//        [vicinity appendString:placemark.country];
//    }
    
    return vicinity;
}

- (void)handleHeaderTap:(UIPanGestureRecognizer *)gesture
{
    [self configueResultMapControllerForIndexPath:nil];
}

- (void)configueResultMapControllerForIndexPath:(NSIndexPath *)indexPath
{
    MapViewController *destController = nil;
    
    if (selectedMap == APPLE_MAP) {
        destController = (MapViewController *)[[AppleMapViewController alloc] init];
    }else if (selectedMap == GOOGLE_MAP){
        destController = (MapViewController *)[[GoogleMapViewController alloc] init];
    }
    
    destController.travelType = travelType;
    destController.myLocation = currentLocation.coordinate;
    destController.restaurantArray = _restaurantDataController.restaurantData.restaurantArray;
    
    if (indexPath) {
        destController.selectedRestaurant = [_restaurantDataController restaurantInRestaurantListAtIndex:indexPath.row];
    }
    
    if (destController) {
        [self.navigationController pushViewController:destController animated:YES];
    }
}

- (IBAction)changeTravelType:(id)sender {
    switch ([sender selectedSegmentIndex])
	{
        case DRIVING:
        {
            travelType = DRIVING;
            break;
        }
        case WALKING:
        {
            travelType = WALKING;
            break;
        }
	}
    
    if (_restaurantDataController.restaurantData.distanceAvailable) {
        _travelTypeSegmentControl.userInteractionEnabled = NO;
        
        if (travelType == DRIVING) {
            
            [UIView transitionWithView:_resultTableView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                ;
                            } completion:^(BOOL finished) {
                                _travelTypeSegmentControl.userInteractionEnabled = YES;
                            }];
        } else {
            [UIView transitionWithView:_resultTableView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                ;
                            } completion:^(BOOL finished) {
                                _travelTypeSegmentControl.userInteractionEnabled = YES;
                            }];
        }
      
        [_restaurantDataController sortRestaurantListInType:travelType];
        [_resultTableView reloadData];
    } else {
        [self searchForNearbyRestaurant];
    }
}

@end
