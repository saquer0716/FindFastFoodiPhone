//
//  Location.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-31.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Restaurant : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) CLLocation *location;
@property (nonatomic, copy) NSString *vicinity;

@property (nonatomic, copy) NSString *distanceTextDriving;
@property (nonatomic, copy) NSNumber *distanceValueDriving;
@property (nonatomic, strong) NSMutableArray *stepsOfDriving;

@property (nonatomic, copy) NSString *distanceTextWalking;
@property (nonatomic, copy) NSNumber *distanceValueWalking;
@property (nonatomic, strong) NSMutableArray *stepsOfWalking;

@end
