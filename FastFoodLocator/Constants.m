//
//  Constants.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-30.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "Constants.h"

NSString *const RESTAURANT_KFC = @"kfc";
NSString *const RESTAURANT_MC = @"mcdonald";
NSString *const RESTAURANT_BK = @"%94burger+king%94";
NSString *const RESTAURANT_SW = @"subway";
NSString *const RESTAURANT_HJ = @"%94hungry+jack%94";

NSString *getRestaurantName(NSInteger index)
{
    NSString *name;
    switch (index) {
        case KFC_INDEX:
            name = RESTAURANT_KFC;
            break;
        case MC_INDEX:
            name = RESTAURANT_MC;
            break;
        case BK_INDEX:
            name = RESTAURANT_BK;
            break;
        case SW_INDEX:
            name = RESTAURANT_SW;
            break;
        case HK_INDEX:
            name = RESTAURANT_HJ;
            break;
        default:
            break;
    };
    
    return name;
}

@implementation Constants

@end
