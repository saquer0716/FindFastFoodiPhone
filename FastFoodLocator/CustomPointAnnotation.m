//
//  CustomPointAnnotation.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-6-14.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "CustomPointAnnotation.h"
#import "MapSearchController.h"

@implementation CustomPointAnnotation
-(id)initWithRestaurant:(Restaurant *)res by:(int)traveType
{
    if (self = [super init]) {
        _restaurant = res;
        
        NSString *distance;
        if (traveType == DRIVING) {
            distance = res.distanceTextDriving;
        }else {
            distance = res.distanceTextWalking;
        }
        self.title = [NSString stringWithFormat:@"%@  %@", res.name, distance];
        self.subtitle = res.vicinity;
        self.coordinate = res.location.coordinate;
        
        return self;
    }
    
    return nil;
}
@end
