//
//  MapSearchController.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-6-11.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "MapSearchController.h"
#import <MapKit/MapKit.h>
#import "NetRequest.h"
#import "Restaurant.h"
#import "ApiKey.h"

@interface MapSearchController ()
{
    int selectedMap;
//    int selectedTravelType;
    
    NSString *searchRestaurant;
    CLLocationCoordinate2D currentLocation;
    
    NSMutableArray *restaurantArray;
}

@end

@implementation MapSearchController

- (id)initWithMapType:(int)mapType dataSrc:(NSMutableArray *)list
{
    if (self = [super init]) {
        selectedMap = mapType;
        restaurantArray = list;
        return self;
    }
    
    return nil;
}

-(void)searchFor:(NSString *)resaurant fromLocation:(CLLocationCoordinate2D)myLocation travelBy:(int)type onComplete:(SearchMapCompletionHandler)complete
{
    currentLocation = myLocation;
    searchRestaurant = resaurant;
//    selectedTravelType = type;
    
    NSString *url = [self makePlacesSearchUrl];
    
    [self searchRestaurantInformation:url writeTo:restaurantArray onCompletion:complete];
}

-(void)searchFor:(NSString *)resaurant fromLocation:(CLLocationCoordinate2D)myLocation onComplete:(SearchMapCompletionHandler)complete
{
    currentLocation = myLocation;
    searchRestaurant = resaurant;
    
    NSString *url = [self makePlacesSearchUrl];
    
    [self searchRestaurantInformation:url writeTo:restaurantArray onCompletion:complete];
}

- (NSString *)makePlacesSearchUrl
{
    if (selectedMap == APPLE_MAP) {
        return @"";//[self makePlacesSearchUrlForApple];
    } else if (selectedMap == GOOGLE_MAP){
        return [self makePlacesSearchUrlForGoogle];
    }
    
    return nil;
}

- (void)searchRestaurantInformation:(NSString *)searchUrl writeTo:(NSMutableArray *)searchResult onCompletion:(SearchMapCompletionHandler)complete
{
    if (selectedMap == APPLE_MAP) {
        [self searchPlacesInAppleApiAround:currentLocation writeTo:searchResult onCompletion:complete];
    } else if (selectedMap == GOOGLE_MAP){
        [self searchPlacesInGoogleApiAround:searchUrl writeTo:searchResult onCompletion:complete];
    }
}


//////////////////////////////////////////////////
//search method for apple//
/////////////////////////////////////////////////
- (NSString *)makeDirectionSearchUrlForApple:(int)travelType
{
    NSString *key = [NSString stringWithFormat:@"%@%@", @"key=", MAPQUEST_API_KEY];
    
    NSString *from = [NSString stringWithFormat:@"from=%.6f,%.6f", currentLocation.latitude, currentLocation.longitude];
    
//    NSMutableString *to = [NSMutableString stringWithString:@"to="];
//    
//    for (Restaurant *restaurant in result) {
//        [to appendString:[NSString stringWithFormat:@"%.8f,%.8f|", restaurant.location.coordinate.latitude, restaurant.location.coordinate.longitude]];
//    }
//    if (to.length > 0) {
//        [to deleteCharactersInRange:NSMakeRange(to.length - 1, 1)];
//    }
    NSMutableString *to = [NSMutableString stringWithString:@""];
    for (Restaurant *restaurant in restaurantArray) {
        [to appendString:[NSString stringWithFormat:@"to=%.6f,%.6f&", restaurant.location.coordinate.latitude, restaurant.location.coordinate.longitude]];
        [to appendString:[NSString stringWithFormat:@"to=%.6f,%.6f&", currentLocation.latitude, currentLocation.longitude]];
    }
    if (to.length > 0) {
        [to deleteCharactersInRange:NSMakeRange(to.length - 1, 1)];
    }
    
    NSString *routeType;
    if (travelType == DRIVING) {
        routeType = @"routeType=shortest";
    } else {
        routeType = @"routeType=pedestrian";
    }
    
    NSString *doReverseGeocode = @"doReverseGeocode=false";
    
    NSString *allToall = @"allToall=false";
    
    NSString *searchUrl = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@&%@", MAPQUEST_DIRECTION_URL, key, from, to, routeType, allToall, doReverseGeocode];

    return searchUrl;
}

- (void)searchPlacesInAppleApiAround:(CLLocationCoordinate2D)coordinate writeTo:(NSMutableArray *)searchResult onCompletion:(SearchMapCompletionHandler)complete
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = [NSString stringWithFormat:@"%@ %@", searchRestaurant, @"restaurant"];
    request.region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000);
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        int resultCode;
        if (error) {
            resultCode = NOT_CARE;
        } else {
            [searchResult removeAllObjects];
            for (MKMapItem *item in response.mapItems) {
                Restaurant *foundRestaurant = [[Restaurant alloc] init];
                foundRestaurant.vicinity = [self buildVicinityFromPlaceMark:item.placemark];
                foundRestaurant.name = item.name;
                
                foundRestaurant.location = item.placemark.location;
                
                [searchResult addObject:foundRestaurant];
            }
            
            if (searchResult.count > 0) {
                resultCode = OK;
                
                [self searchDirectionsInAppleTo:restaurantArray travelBy:DRIVING onCompletion:complete];
                return;
            } else {
                resultCode = ZERO_RESULT;
            }
        }
     
        complete(error, resultCode);
    }];
}

- (void)searchDirectionsInAppleTo:(NSMutableArray *)searchResult travelBy:(int)travelType onCompletion:(SearchMapCompletionHandler)complete
{
    [NetRequest requestToURl:[self makeDirectionSearchUrlForApple:travelType] onCompletion:^(NSData *data, NSError *error){
        int resultCode;
        
        if (travelType == DRIVING) {
            NSLog(@"directions search finished, map: Apple, type:driving");
        } else {
            NSLog(@"directions search finished, map: Apple, type:walking");
        }
        
        if (!error) {
            NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *info = [dicData objectForKey:@"info"];
            NSNumber *statuscode = [info objectForKey:@"statuscode"];
            resultCode = [statuscode integerValue];
            
            if (resultCode == 0) {
                NSDictionary *route = [dicData objectForKey:@"route"];
                NSArray *legs = [route objectForKey:@"legs"];
                if (legs.count > 0) {
                    for (int i = 0; i < legs.count; i++) {
                        if (i % 2 != 0) {
                            continue;
                        }
                        
                        int index = i / 2;
                        Restaurant *restaurant = [searchResult objectAtIndex:index];
                        NSMutableArray *step;
                        
                        NSDictionary *leg = [legs objectAtIndex:i];
                        NSNumber *distance = [leg objectForKey:@"distance"];
                        
                        if (travelType == DRIVING) {
                            restaurant.distanceTextDriving = [NSString stringWithFormat:@"%.2f%@", [distance floatValue], @" km"];
                            restaurant.distanceValueDriving = distance;
                            step = restaurant.stepsOfDriving;
                        } else {
                            restaurant.distanceTextWalking = [NSString stringWithFormat:@"%.2f%@", [distance floatValue], @" km"] ;
                            restaurant.distanceValueWalking = distance;
                            step = restaurant.stepsOfWalking;
                        }
                        //clear all the steps
                        [step removeAllObjects];
                        
                        NSArray *maneuvers = [leg objectForKey:@"maneuvers"];
                        for (NSDictionary *maneuver in maneuvers) {
                            NSDictionary *startPoint = [maneuver objectForKey:@"startPoint"];
                            NSNumber *latitude = [startPoint objectForKey:@"lat"];
                            NSNumber *longitude = [startPoint objectForKey:@"lng"];
                            
                            CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
                            [step addObject:location];
                        }
                    }
                }
                                
                if (travelType == DRIVING) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self searchDirectionsInAppleTo:restaurantArray travelBy:WALKING onCompletion:complete];
                    });
                    
                    return;
                }
            }else {
                NSLog(@"directions search result by MapQuest not ok, result code: %d", [statuscode integerValue]);
                NSArray *messages = [info objectForKey:@"messages"];
                NSString *message = [messages objectAtIndex:0];
                NSLog(@"%@", message);
//                if ([result isEqual:@"OVER_QUERY_LIMIT"]) {
//                    resultCode = EXCEED_LIMIT;
//                } else {
//                    resultCode = NOT_KNOWN;
//                }
            }
        }else {
            resultCode = NOT_CARE;
            NSLog(@"directions search by MapQuest error: %@", error.description);
        }
        complete(error, resultCode);
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
    
    return vicinity;
}



//////////////////////////////////////////////////
//search method for google//
/////////////////////////////////////////////////
- (NSString *)makePlacesSearchUrlForGoogle
{
    NSString *key = [NSString stringWithFormat:@"%@%@", @"key=", GOOGLE_PLACES_SEARCH_KEY];
    NSString *name = [NSString stringWithFormat:@"%@%@", @"name=", searchRestaurant];
    NSString *location = [NSString stringWithFormat:@"location=%.8f,%.8f", currentLocation.latitude, currentLocation.longitude];
    
    //get radius from settings bundle;
    NSString *radius = @"radius=5000";
    NSString *types = @"types=restaurant%7Cfood";//ecode "|" to "%7C"
    NSString *sensor = @"sensor=false";
    NSString *searchUrl = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@&%@", GOOGLE_PLACES_SEARCH_URL, key, name, location, radius, types, sensor];
    NSLog(@"%@", searchUrl);
    return searchUrl;
}

- (NSString *)makeDistanceSearchUrlForGoogle:(NSMutableArray *)result travelBy:(int)travelType
{
    NSMutableString *destinations = [NSMutableString stringWithString:@"destinations="];
    NSString *origins = [NSString stringWithFormat:@"origins=%.8f,%.8f", currentLocation.latitude, currentLocation.longitude];
    
    for (Restaurant *restaurant in result) {
        [destinations appendString:[NSString stringWithFormat:@"%.8f,%.8f%%7C", restaurant.location.coordinate.latitude, restaurant.location.coordinate.longitude]];
    }
    if (destinations.length > 0) {
        [destinations deleteCharactersInRange:NSMakeRange(destinations.length - 4, 4)];
    }
    
    NSString *mode;
    if (travelType == DRIVING) {
        mode = @"mode=driving";
    } else {
        mode = @"mode=walking";
    }
    
    NSString *sensor = @"sensor=false";
    NSString *searchUrl = [NSString stringWithFormat:@"%@&%@&%@&%@&%@", GOOGLE_DISTANCE_CAL_URL, origins, destinations, sensor, mode];
    
    return searchUrl;
}

- (void)searchPlacesInGoogleApiAround:(NSString *)searchUrl writeTo:(NSMutableArray *)searchResult onCompletion:(SearchMapCompletionHandler)complete
{
    [NetRequest requestToURl:searchUrl onCompletion:^(NSData *data, NSError *error){
        NSLog(@"places search finished, map: Google");
        
        if (!error) {
            NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *result = [dicData objectForKey:@"status"];
            
            if ([result isEqual:@"OK"]) {
                [searchResult removeAllObjects];
                
                NSArray *foundRestaurants = [dicData objectForKey:@"results"];
                
                for (NSDictionary *restaurant in foundRestaurants) {
                    Restaurant *foundRestaurant = [[Restaurant alloc] init];
                    foundRestaurant.vicinity = [restaurant objectForKey:@"vicinity"];
                    foundRestaurant.name = [restaurant objectForKey:@"name"];
                    
                    NSDictionary *coordinate = [[restaurant objectForKey:@"geometry"] objectForKey:@"location"];
                    NSNumber *lat = [coordinate objectForKey:@"lat"];
                    NSNumber *lng = [coordinate objectForKey:@"lng"];
                    foundRestaurant.location = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
                    [searchResult addObject:foundRestaurant];
                }
                
                [self searchDistancesInGoogleApiTo:searchResult travelBy:DRIVING onCompletion:complete];
            }else {
                NSLog(@"place search result by google not ok, result code: %@", result);
                //ZERO_RESULTS
                //OVER_QUERY_LIMIT
                int resultCode;
                if ([result isEqual:@"ZERO_RESULTS"]) {
                    resultCode = ZERO_RESULT;
                } else if ([result isEqual:@"OVER_QUERY_LIMIT"]) {
                    resultCode = EXCEED_LIMIT;
                } else {
                    resultCode = NOT_KNOWN;
                }
        
                complete(error, resultCode);
            }
        }else {
            NSLog(@"place search by google error: %@", error.description);
            complete(error, NOT_CARE);
        }
    }];
    
}

- (void)searchDistancesInGoogleApiTo:(NSMutableArray *)searchResult travelBy:(int)travelType onCompletion:(SearchMapCompletionHandler)complete
{
    [NetRequest requestToURl:[self makeDistanceSearchUrlForGoogle:searchResult travelBy:travelType] onCompletion:^(NSData *data, NSError *error){
        int resultCode;
        
        if (travelType == DRIVING) {
            NSLog(@"directions search finished, map: Google, type:driving");
        } else {
            NSLog(@"directions search finished, map: Google, type:walking");
        }
        
        if (!error) {
            NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *result = [dicData objectForKey:@"status"];
            
            if ([result isEqual:@"OK"]) {
                NSArray *rows = [dicData objectForKey:@"rows"];
                if (rows.count > 0) {
                    NSDictionary *row = [rows objectAtIndex:0];
                    NSArray *elements = [row objectForKey:@"elements"];
                    
                    for (int i = 0; i < elements.count; i++) {
                        NSDictionary *element = [elements objectAtIndex:i];
                        
                        NSString *result = [element objectForKey:@"status"];
                        if ([result isEqual:@"OK"]) {
                            NSDictionary *distance = [element objectForKey:@"distance"];
                            NSString *text = [distance objectForKey:@"text"];
                            NSNumber *value = [distance objectForKey:@"value"];
                            
                            if (travelType == DRIVING) {
                                ((Restaurant *)[searchResult objectAtIndex:i]).distanceTextDriving = text;
                                ((Restaurant *)[searchResult objectAtIndex:i]).distanceValueDriving = value;
                            } else {
                                ((Restaurant *)[searchResult objectAtIndex:i]).distanceTextWalking = text;
                                ((Restaurant *)[searchResult objectAtIndex:i]).distanceValueWalking = value;
                            }
                        }
                    }
                }
                
                resultCode = OK;
                
                if (travelType == DRIVING) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self searchDistancesInGoogleApiTo:searchResult travelBy:WALKING onCompletion:complete];
                    });
                    
                    return;
                }
            }else {
                NSLog(@"distances search result by google not ok, result code: %@", result);
                
                if ([result isEqual:@"OVER_QUERY_LIMIT"]) {
                    resultCode = EXCEED_LIMIT;
                } else {
                    resultCode = NOT_KNOWN;
                }
            }
        }else {
            resultCode = NOT_CARE;
            NSLog(@"distance search by google error: %@", error.description);
        }
        complete(error, resultCode);
    }];
}

@end
