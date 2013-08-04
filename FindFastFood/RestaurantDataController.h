//
//  RestaurantDataController.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-29.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantData.h"
@class Restaurant;

@interface RestaurantDataController : NSObject

@property (nonatomic, copy) RestaurantData *restaurantData;

-(void)setNameOfRestaurant:(NSString *)name;
-(NSUInteger)countOfRestaurantLocations;
-(Restaurant *)restaurantInRestaurantListAtIndex:(NSUInteger)index;
-(void)addRestaurantLocation:(Restaurant *)retaurant;
-(void)sortRestaurantListInType:(int)travelType;
@end
