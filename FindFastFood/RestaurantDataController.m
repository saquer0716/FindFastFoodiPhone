//
//  RestaurantDataController.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-29.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "RestaurantDataController.h"
#import "RestaurantData.h"
#import "MapSearchController.h"

@interface RestaurantDataController ()
- (void) initDefaultDataList;

@end

@implementation RestaurantDataController
- (void)initDefaultDataList
{
    _restaurantData = [[RestaurantData alloc] init];
}

- (id)init{
    if(self = [super init]){
        [self initDefaultDataList];
        return self;
    }
    return nil;
}

-(void)setNameOfRestaurant:(NSString *)name
{
    _restaurantData.name = name;
    
    
}

- (NSUInteger)countOfRestaurantLocations
{
    return [_restaurantData countOfList];
}

- (Restaurant *)restaurantInRestaurantListAtIndex:(NSUInteger)index
{
    return [_restaurantData objectInListAtIndex:index];
}

-(void)addRestaurantLocation:(Restaurant *)restaurant
{
    [_restaurantData addRestaurant:restaurant];
}
-(void)sortRestaurantListInType:(int)travelType
{
    [_restaurantData.restaurantArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (travelType == DRIVING) {
            NSNumber *first = [(Restaurant *)obj1 distanceValueDriving];
            NSNumber *second = [(Restaurant *)obj2 distanceValueDriving];
            
            return [first compare:second];
        }else {
            NSNumber *first = [(Restaurant *)obj1 distanceValueWalking];
            NSNumber *second = [(Restaurant *)obj2 distanceValueWalking];
            
            return [first compare:second];
        }
    }];
}
@end
