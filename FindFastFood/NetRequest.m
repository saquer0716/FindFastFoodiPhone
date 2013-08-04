//
//  NetRequest.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-31.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "NetRequest.h"

@implementation NetRequest

+(void)requestToURl:(NSString *)url onCompletion:(RequestCompletionHander)complete
{
    //[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] for special character encoding
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                            cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                              timeoutInterval:10];
    
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse * response, NSData *data, NSError *error){                               
                               if (complete) {
                                   complete(data, error);
                               }
                           }];
}
@end
