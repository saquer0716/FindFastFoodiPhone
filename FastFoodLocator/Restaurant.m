//
//  Location.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-31.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

-(id)init
{
    if (self = [super init]) {
        _stepsOfDriving = [[NSMutableArray alloc] init];
        _stepsOfWalking = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}
@end
