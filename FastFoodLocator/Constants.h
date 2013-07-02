//
//  Constants.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-30.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

enum {
    KFC_INDEX = 0,
    MC_INDEX,
    BK_INDEX,
    SW_INDEX,
    HK_INDEX,
};

extern NSString *const RESTAURANT_KFC;
extern NSString *const RESTAURANT_MC;
extern NSString *const RESTAURANT_BK;
extern NSString *const RESTAURANT_SW;
extern NSString *const RESTAURANT_HJ;

extern NSString *getRestaurantName(NSInteger index);

@end
