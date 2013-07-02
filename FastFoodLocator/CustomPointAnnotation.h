//
//  CustomPointAnnotation.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-6-14.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Restaurant.h"

@interface CustomPointAnnotation : MKPointAnnotation

@property (nonatomic,strong) Restaurant* restaurant;

-(id)initWithRestaurant:(Restaurant *)restaurant by:(int)travelType;
@end
