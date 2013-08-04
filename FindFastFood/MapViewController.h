//
//  MapViewController.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-6-11.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Restaurant.h"

#define INCLUDING_MARKERS_NUMBER 5

@protocol MapTypeDelegate <NSObject>

- (void)mapTypeDidSelectedAt:(int)index;

@end

@interface MapViewController : UIViewController

@property (nonatomic) int travelType;
@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic, strong) Restaurant *selectedRestaurant;
@property (nonatomic, strong) NSMutableArray *restaurantArray;

@property (weak) id<MapTypeDelegate> delegate;

@property (nonatomic) BOOL zoomToMarker;

@end
