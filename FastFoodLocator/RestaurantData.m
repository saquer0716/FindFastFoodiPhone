//
//  Restaurant.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-29.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "RestaurantData.h"

@implementation RestaurantData

- (id)init
{
    if (self = [super init]) {
        _name = @"";
        _restaurantArray = [[NSMutableArray alloc] init];
        
        return self;
    }
    
    return nil;
}

-(NSUInteger)countOfList
{
    return _restaurantArray.count;
}

-(Restaurant *)objectInListAtIndex:(NSUInteger)index
{
    return [_restaurantArray objectAtIndex:index];
}

-(void)addRestaurant:(Restaurant *)restaurant
{
    [_restaurantArray addObject:restaurant];
}

@end
