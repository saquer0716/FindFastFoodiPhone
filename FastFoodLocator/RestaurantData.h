//
//  Restaurant.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-29.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface RestaurantData : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic) BOOL distanceAvailable;
@property (nonatomic, strong) NSMutableArray *restaurantArray;

-(NSUInteger)countOfList;
-(Restaurant *)objectInListAtIndex:(NSUInteger)index;
-(void)addRestaurant:(Restaurant *)restaurant;


@end
