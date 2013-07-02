//
//  NetRequest.h
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-31.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void(^RequestCompletionHander) (NSData *, NSError *);

@interface NetRequest : NSObject

+ (void)requestToURl:(NSString *)url onCompletion:(RequestCompletionHander)complete;
@end
