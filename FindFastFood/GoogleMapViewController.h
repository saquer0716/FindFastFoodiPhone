//
//  MyLocationViewController.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-31.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>     
#import <GoogleMaps/GoogleMaps.h>
#import "Restaurant.h"
#import "MapViewController.h"

@interface GoogleMapViewController : MapViewController <GMSMapViewDelegate, MapTypeDelegate>

@end
