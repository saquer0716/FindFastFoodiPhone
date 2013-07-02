//
//  AppleMapViewController.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-6-10.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "AppleMapViewController.h"
#import "MapSearchController.h"
#import "CustomPointAnnotation.h"

@interface AppleMapViewController ()
{
    MKMapView *appleMapView;
    MKPolyline *routeLine;
    MKPolylineView *routeLineView;    
}

@end

@implementation AppleMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appleMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    appleMapView.autoresizingMask = self.view.autoresizingMask; // UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    appleMapView.showsUserLocation = YES;
    
    [self.view addSubview:appleMapView];
    appleMapView.delegate = self;
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
//                                          initWithTarget:self
//                                          action:@selector(handleTapGesture:)];
//    [appleMapView addGestureRecognizer:self];
    
    MKMapRect zoomRect = MKMapRectNull;
    MKMapPoint annotationPointMyLocation = MKMapPointForCoordinate(self.myLocation);
    MKMapRect rectMyLocation = MKMapRectMake(annotationPointMyLocation.x, annotationPointMyLocation.y, 0.1, 0.1);
    
    zoomRect = MKMapRectUnion(zoomRect, rectMyLocation);
    
    if (self.selectedRestaurant) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(self.selectedRestaurant.location.coordinate);
        MKMapRect rectSelectedRestaurant = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        
        zoomRect = MKMapRectUnion(zoomRect, rectSelectedRestaurant);
    } else {
        int maxIndex = 0;
        if (self.restaurantArray.count > 0) {
            maxIndex = self.restaurantArray.count < INCLUDING_MARKERS_NUMBER ? self.restaurantArray.count : INCLUDING_MARKERS_NUMBER;
        }
        
        for (int i = 0; i < maxIndex; i++) {
            Restaurant *restaurant = [self.restaurantArray objectAtIndex:i];
            
            MKMapPoint annotationPoint = MKMapPointForCoordinate(restaurant.location.coordinate);
            MKMapRect rectPoint = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            
            zoomRect = MKMapRectUnion(zoomRect, rectPoint);
        }
    }
    
    UIEdgeInsets mapInsect = UIEdgeInsetsMake(10.0, 10.0, 50, 10.0);
    [appleMapView setVisibleMapRect:zoomRect edgePadding:mapInsect animated:YES];
    
    [self addAnnotations];
    
    if (self.selectedRestaurant) {
        if (self.travelType == DRIVING) {
            [self drawPolyLine:self.selectedRestaurant.stepsOfDriving];
        } else {
            [self drawPolyLine:self.selectedRestaurant.stepsOfWalking];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
}

-(IBAction)handleTapGesture:(UIPanGestureRecognizer *)gesture
{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAnnotations {
    for (int i = 0; i < self.restaurantArray.count; i++) {
        Restaurant *restaurant = [self.restaurantArray objectAtIndex:i];
        
        CustomPointAnnotation *point = [[CustomPointAnnotation alloc] initWithRestaurant:restaurant by:self.travelType];
        
        [appleMapView addAnnotation:point];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
//        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        pinView.rightCalloutAccessoryView = rightButton;
    }else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

//for select the accessory control
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"selcted");
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([[view annotation] isKindOfClass:[MKUserLocation class]]) {
        return;
    }
    CustomPointAnnotation *customPoint = (CustomPointAnnotation *)(view.annotation);
    self.selectedRestaurant = customPoint.restaurant;
    
    if (self.travelType == DRIVING) {
        [self drawPolyLine:self.selectedRestaurant.stepsOfDriving];
    } else {
        [self drawPolyLine:self.selectedRestaurant.stepsOfWalking];
    }
}

- (void)drawPolyLine:(NSArray *)polylineArray
{
    [appleMapView removeOverlay:routeLine];
    
    CLLocationCoordinate2D coordinateArray[polylineArray.count];
    for (int i = 0 ; i < polylineArray.count; i++) {
        coordinateArray[i] = ((CLLocation *)[polylineArray objectAtIndex:i]).coordinate;
    }
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:polylineArray.count];
    
    [appleMapView addOverlay:routeLine];
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.fillColor = [UIColor blueColor];
        polylineView.lineWidth = 4.0f;
        
        return polylineView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
