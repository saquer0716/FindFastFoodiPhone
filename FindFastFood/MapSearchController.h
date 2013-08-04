//
//  MapSearchController.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-6-11.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SearchMapCompletionHandler) (NSError *error, int resultCode);

enum {
    APPLE_MAP = 0,
    GOOGLE_MAP = 1
};

enum {
    DRIVING = 0,
    WALKING = 1
};

enum {
    NORMAL = 0,
    HYBRID = 1,
    SATELLITE = 2,
    Terrain = 3
};

enum {
    NOT_CARE = -1,
    OK = 0,
    ZERO_RESULT = 1,
    EXCEED_LIMIT = 2,
    NOT_KNOWN = 3
};

@interface MapSearchController : NSObject

- (id)initWithMapType:(int)mapType dataSrc:(NSMutableArray *)list;
- (void)searchFor:(NSString *)resaurant fromLocation:(CLLocationCoordinate2D)myLocation travelBy:(int)type onComplete:(SearchMapCompletionHandler)complete;

- (void)searchFor:(NSString *)resaurant fromLocation:(CLLocationCoordinate2D)myLocation onComplete:(SearchMapCompletionHandler)complete;

@end
