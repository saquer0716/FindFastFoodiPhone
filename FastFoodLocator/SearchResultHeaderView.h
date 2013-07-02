//
//  LocationsTableHeaderView.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-31.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultHeaderView : UIView

- (void) initializeWithFrame:(CGRect)frame;
- (void) changeLocationVicinity:(NSString *)location;
@end
