//
//  RestaurantCelectionViewController.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-29.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "RestaurantCelectionViewController.h"
#import "RestaurantCollectionViewCell.h"
#import "SearchResultController.h"
#import "Constants.h"


@interface RestaurantCelectionViewController ()
{
    NSArray *restaurantImages;
}
@end

@implementation RestaurantCelectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    _settingsViewController = [[IASKAppSettingsViewController alloc] init];
//    _settingsViewController.delegate = self;
    
    restaurantImages = [NSArray arrayWithObjects:@"kfc.png", @"mcdonalds.png", @"burgerking.png", @"subway.png", @"hungryjacks.png", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return restaurantImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RestaurantCell";
    
    RestaurantCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.restaurantImage setImage:[UIImage imageNamed:[restaurantImages objectAtIndex:indexPath.item]]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GetLocations"]){
        SearchResultController *destViewController = segue.destinationViewController;
        
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        
        destViewController.selectedRestaurant = getRestaurantName(indexPath.row);
        NSLog(@"%@", destViewController.selectedRestaurant);
        
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settings:(id)sender {
    _settingsViewController.showDoneButton = NO;
    _settingsViewController.showCreditsFooter = YES;
    [self.navigationController pushViewController:_settingsViewController animated:YES];
}
@end
