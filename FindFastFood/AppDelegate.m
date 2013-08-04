//
//  AppDelegate.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-29.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ApiKey.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:GOOGLE_MAP_SDK_IOS_KEY];
    
    NSMutableDictionary *settingsDefaults = [[NSMutableDictionary alloc] init];
    
    [settingsDefaults setObject:[NSNumber numberWithInteger:1] forKey:@"used_map_preference"];
    [settingsDefaults setObject:@"YES" forKey:@"zoom_route_preference"];
    
    [settingsDefaults setObject:[NSNumber numberWithInteger:1] forKey:@"search_range_preference"];
    [settingsDefaults setObject:[NSNumber numberWithInteger:0] forKey:@"distance_uit_preference"];

    [[NSUserDefaults standardUserDefaults] registerDefaults:settingsDefaults];
//
//    NSUserDefaults *standarUserDefaults = [NSUserDefaults standardUserDefaults];
//    
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"InAppSettings" ofType:@"bundle"];
//    NSString *plistFile = [bundlePath stringByAppendingPathComponent:@"Root.plist"];
//    
//    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
//    NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
//    
//    NSDictionary *drivingDistanceDictionary = [preferencesArray objectAtIndex:4];
//    NSArray *drivingDistanceOptions = [drivingDistanceDictionary objectForKey:@"Titles"];
//    
//    NSDictionary *walkingDistanceDictionary = [preferencesArray objectAtIndex:5];
//    NSArray *walkingDistanceOptions = [walkingDistanceDictionary objectForKey:@"Titles"];
//
//    [standarUserDefaults synchronize];
    
    return YES;
}
				
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
