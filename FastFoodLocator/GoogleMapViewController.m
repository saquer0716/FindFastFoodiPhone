//
//  MyLocationViewController.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-31.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Restaurant.h"
#import "ApiKey.h"
#import "NetRequest.h"
#import "MapSearchController.h"

@interface GoogleMapViewController ()
{
    GMSMapView * mapView;
//    GMSMarker *farthestMarkerInMapView;
    GMSPolyline *polyline;
    GMSMutablePath *path;
    
    NSMutableArray *steps;
    
    UIActivityIndicatorView *activtyIndicator;
    BOOL firstLocationUpdate;
}
@end

@implementation GoogleMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad]; 

	GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.myLocation zoom:15];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    
    [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    [self addDefaultMarkers];
    
    mapView.delegate = self;
    self.view = mapView;
    
    self.delegate = self;
    
    polyline = [[GMSPolyline alloc] init];
    path = [GMSMutablePath path];
    
    polyline.strokeWidth = 2.5f;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)addDefaultMarkers {
    for (int i = 0; i < self.restaurantArray.count; i++) {
        Restaurant *restaurant = [self.restaurantArray objectAtIndex:i];
   
//        CustomeGMSMarker *restaurantMarker = [[CustomeGMSMarker alloc] initWithRestaurant:restaurant by:self.travelType];
        
        GMSMarker *restaurantMarker = [[GMSMarker alloc] init];
        NSString *distance;
        if (self.travelType == DRIVING) {
            distance = restaurant.distanceTextDriving;
        }else {
            distance = restaurant.distanceTextWalking;
        }
        
        if (!distance) {
            distance = @"";
        }
        restaurantMarker.title = [NSString stringWithFormat:@"%@  %@", restaurant.name, distance];
        restaurantMarker.snippet = restaurant.vicinity;
        restaurantMarker.icon = [UIImage imageNamed:@"arrow"];
        restaurantMarker.position = restaurant.location.coordinate;
        restaurantMarker.animated = YES;
        restaurantMarker.map = mapView;
        restaurantMarker.userData = restaurant;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [mapView removeObserver:self forKeyPath:@"myLocation" context:NULL];
}

- (void)mapTypeDidSelectedAt:(int)index
{
    switch (index)
	{
        case NORMAL:
        {
            mapView.mapType = kGMSTypeNormal;
            break;
        }
        case HYBRID:
        {
            mapView.mapType = kGMSTypeHybrid;
            break;
        }
        case SATELLITE:
        {
            mapView.mapType = kGMSTypeSatellite;
            break;
        }
        case Terrain:
        {
            mapView.mapType = kGMSTypeTerrain;
            break;
        }
        default:
        break;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate = YES;
        //CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];

        [self fitBounds];
        
        if (self.selectedRestaurant) {
            if (self.travelType == DRIVING) {
                steps = self.selectedRestaurant.stepsOfDriving;
            } else {
                steps = self.selectedRestaurant.stepsOfWalking;
            }
            
            if ([steps count] > 0) {
                [self drawPolyLine:steps];
            }else {
                [self retrieveDirectionTo:self.selectedRestaurant.location.coordinate forRestaurant:self.selectedRestaurant];
            }
        }
    }
}

- (BOOL)mapView:(GMSMapView *)theMapView didTapMarker:(GMSMarker *)marker {
    self.selectedRestaurant = marker.userData;
    
    if (self.zoomToMarker) {
        [self fitBounds];
    }
    
    if (self.travelType == DRIVING) {
        steps = self.selectedRestaurant.stepsOfDriving;
    } else {
        steps = self.selectedRestaurant.stepsOfWalking;
    }
    
    if ([steps count] > 0) {
        [self drawPolyLine:steps];
    }else {
//        activtyIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:activtyIndicator];
//        [[self navigationItem] setRightBarButtonItem:barItem];
//        activtyIndicator.hidden = NO;
//        [activtyIndicator startAnimating];
        [self retrieveDirectionTo:marker.position forRestaurant:self.selectedRestaurant];
    }
    
    theMapView.selectedMarker = marker;
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
//    [UIView beginAnimations:@"View Flip" context:nil];
//    [UIView setAnimationDuration:0.80];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
//                           forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
//    
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)retrieveDirectionTo:(CLLocationCoordinate2D)destLocation forRestaurant:(Restaurant *)restaurant
{
    NSString *origin = [NSString stringWithFormat:@"origin=%.8f,%.8f", self.myLocation.latitude, self.myLocation.longitude];
    NSString *destination = [NSString stringWithFormat:@"destination=%.8f,%.8f", destLocation.latitude, destLocation.longitude];
    
    NSString *sensor = @"sensor=false";
    
    NSString *mode;
    if (self.travelType == DRIVING) {
        mode = @"mode=driving";
    } else {
        mode = @"mode=walking";
    }

    NSString *searchString = [NSString stringWithFormat:@"%@&%@&%@&%@&%@", GOOGLE_DIRECTION_URL, origin, destination, sensor, mode];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NetRequest requestToURl:searchString onCompletion:^(NSData *data, NSError *error){
//        [self.navigationItem setRightBarButtonItem:nil];
//        [activtyIndicator stopAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!error) {
            NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *status = [dicData objectForKey:@"status"];
            
            if ([status isEqual:@"OK"]) {
                NSArray *routes = [dicData objectForKey:@"routes"];
                if (routes.count > 0) {
                    NSDictionary *route = [routes objectAtIndex:0];
                    NSDictionary *overview_polyline = [route objectForKey:@"overview_polyline"];
                    NSString *points = [overview_polyline objectForKey:@"points"];
                    
                    [self decodePolyLine:points saveTo:steps];
                }
            }else {
                NSLog(@"can't get direction");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (steps && (steps.count > 0)) {
                    [self drawPolyLine:steps];
                }
            });
        }else {
            NSLog(@"%@", error.description);
        }
    }];

}

-(void)decodePolyLine:(NSString *)encodedStr saveTo:(NSMutableArray *)array{
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
//    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
}

- (void)drawPolyLine:(NSMutableArray *)polylineArray
{
    [path removeAllCoordinates];
    
    for (CLLocation *location in polylineArray) {
        [path addCoordinate:location.coordinate];
    }
    polyline.path = path;
    polyline.map = mapView;
}

- (void)fitBounds {
    GMSCoordinateBounds *bounds;
    if (bounds == nil) {
        bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:self.myLocation
                                                      coordinate:self.myLocation];
    }
    
    if (self.selectedRestaurant) {
        bounds = [bounds includingCoordinate:self.selectedRestaurant.location.coordinate];
    } else {
        int maxIndex = 0;
        if (self.restaurantArray.count > 0) {
            maxIndex = self.restaurantArray.count < INCLUDING_MARKERS_NUMBER ? self.restaurantArray.count : INCLUDING_MARKERS_NUMBER;
        }
        
        for (int i = 0; i < maxIndex; i++) {
            Restaurant *restaurant = [self.restaurantArray objectAtIndex:i];
            bounds = [bounds includingCoordinate:restaurant.location.coordinate];
        }
    }
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds
                                             withPadding:50.0f];
    [mapView moveCamera:update];
}
@end
