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
#import "QuartzCore/QuartzCore.h"
#import "Constants.h"
#import "UICustomActionSheet.h"


@interface RestaurantCelectionViewController ()
{
    NSArray *restaurantImages;
    UICustomActionSheet *shareActionSheet;
}
@end

@implementation RestaurantCelectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    _settingsViewController = [[IASKAppSettingsViewController alloc] init];
//    _settingsViewController.delegate = self;
    
    restaurantImages = [NSArray arrayWithObjects:@"kfc.png", @"mcdonalds.png", @"burgerking.png", @"subway.png", @"hungryjacks.png", nil];
    
    shareActionSheet = [[UICustomActionSheet alloc] initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:@"Rate this App", nil];
    shareActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [shareActionSheet setColor:[UIColor colorWithRed:200.0f/255.0f green:0.0f blue:0.0f alpha:1.0f] forButtonAtIndex:0];
    [shareActionSheet setColor:[UIColor colorWithRed:0.0f/255.0f green:220.0f blue:0.0f alpha:1.0f] forButtonAtIndex:1];
    
    [shareActionSheet setPressedColor:[UIColor redColor] forButtonAtIndex:0];
    [shareActionSheet setPressedColor:[UIColor greenColor] forButtonAtIndex:1];
    
    [shareActionSheet setPressedTextColor:[UIColor colorWithRed:250.0f/255.0f green:200.0f blue:200.0f alpha:1.0f] forButtonAtIndex:0];
    [shareActionSheet setPressedTextColor:[UIColor colorWithRed:200.0f/255.0f green:250.0f blue:250.0f alpha:1.0f] forButtonAtIndex:1];
    
    [shareActionSheet setFont:[UIFont fontWithName:@"Helvetica" size:22.0f] forButtonAtIndex:0];
    [shareActionSheet setFont:[UIFont fontWithName:@"Helvetica" size:22.0f] forButtonAtIndex:0];
    
    [shareActionSheet setTextColor:[UIColor whiteColor] forButtonAtIndex:0];
    [shareActionSheet setTextColor:[UIColor whiteColor] forButtonAtIndex:1];
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

- (IBAction)share:(id)sender {
    [shareActionSheet showInView:self.view];
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [[actionSheet layer] setBackgroundColor:[UIColor yellowColor].CGColor];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RATE_LINK]];
            break;
            
        default:
            break;
    }
}


@end
