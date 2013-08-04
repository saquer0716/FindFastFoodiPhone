//
//  Constants.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-30.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "Constants.h"

NSString *const RESTAURANT_SW = @"subway";
NSString *const RESTAURANT_MC = @"mcdonald";
NSString *const RESTAURANT_PH = @"%22pizza%2Bhut%22";

NSString *const RESTAURANT_KFC = @"kfc";

NSString *const RESTAURANT_BK = @"%94burger+king%94";

NSString *const RESTAURANT_HJ = @"%94hungry+jack%94";

NSString *const RESTAURANT_NAME[] = {@"Subway", @"MacDonald's", @"Pizza Hut", @"KFC", @"Starbucks",
    @"Burger King", @"Wendy's", @"Taco Bell", @"Domino's Pizza", @"Dunkin Donuts",
    @"Diary Queen", @"Papa John's", @"Nando's", @"Hungry Jacks", @"Red Rooster"};

NSString *const RESTAURANT_SEARCH_KEYWORD_APPLE[] = {@"subway", @"mcdonalds", @"pizza hut", @"kfc", @"starbucks",
    @"burger king", @"wendys", @"taco bell", @"dominos pizza", @"dunkin donuts",
    @"diary queen", @"papa johns", @"nandos", @"hungry jacks", @"red rooster"};


NSString *const RESTAURANT_SEARCH_KEYWORD_GOOGLE[] = {@"subway", @"mcdonalds", @"%22pizza%2Bhut%22", @"kfc", @"starbucks",
                                                @"%22burger%20king%22", @"wendys", @"%22taco%2Bbell%22", @"%22dominos%2Bpizza%22", @"%22dunkin%2Bdonuts%22",
                                                @"%22diary%2Bqueen%22", @"%22papa%2Bjohns%27s%22", @"nandos", @"%22hungry%2Bjacks%27s%22", @"%22red%2Brooster%22"};


NSString *const RATE_LINK = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=368754825&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8";

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

NSString *getRestaurantRealName(NSInteger index)
{
    return RESTAURANT_NAME[index];
}

NSString *getRestaurantNameApple(NSInteger index)
{
    return RESTAURANT_SEARCH_KEYWORD_APPLE[index];
}


NSString *getRestaurantNameGoogle(NSInteger index)
{
    return RESTAURANT_SEARCH_KEYWORD_GOOGLE[index];
}

@implementation Constants

@end
