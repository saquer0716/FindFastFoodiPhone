//
//  CustomeGMSMarker.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-6-5.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "CustomeGMSMarker.h"
#import "MapSearchController.h"

@implementation CustomeGMSMarker
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
        self.icon = [UIImage imageNamed:@"arrow"];
        self.animated = YES;
        return self;
    }
    
    return nil;
}

@end
