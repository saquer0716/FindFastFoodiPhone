//
//  CustomeGMSMarker.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-6-5.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "Restaurant.h"

@interface CustomeGMSMarker : GMSMarker
@property (nonatomic,strong) Restaurant* restaurant;

-(id)initWithRestaurant:(Restaurant *)restaurant by:(int)travelType;
@end
