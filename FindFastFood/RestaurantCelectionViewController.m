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
#import "MapSearchController.h"
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
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:217.0f/255.0f green:151.0f/255.0f blue:55.0f/255.0f alpha:1.0f]];
    [[self.navigationController navigationBar] setTintColor:[UIColor colorWithRed:217.0f/255.0f green:151.0f/255.0f blue:55.0f/255.0f alpha:1.0f]];
    
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurant_collection_bg.png"]];
    restaurantImages = [NSArray arrayWithObjects:@"subway.png", @"mcdonalds.png", @"pizzahut.png", @"kfc.png", @"starbucks.png", @"burgerking.png",
                        @"wendys.png", @"tacobell.png", @"domino.png", @"dunkin.png", @"diaryqueen.png", @"papa.png", @"nandos.png",
                        @"hungryjacks.png", @"redrooster.png", nil];
    
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
    self.navigationItem.title = @"Restaurant";
    
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
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurant_btn_bg_unclicked.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurant_btn_bg_clicked.png"]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GetLocations"]){
        SearchResultController *destViewController = segue.destinationViewController;
        
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        
        int selectedMap = [[NSUserDefaults standardUserDefaults] integerForKey:@"used_map_preference"];
        if (selectedMap == APPLE_MAP) {
            destViewController.searchKeyword = getRestaurantNameApple(indexPath.row);
        }else {
            destViewController.searchKeyword = getRestaurantNameGoogle(indexPath.row);
        }
        
        destViewController.name = getRestaurantRealName(indexPath.row);
        
        NSLog(@"%@", destViewController.searchKeyword);
        
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
    _settingsViewController.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurant_collection_bg.png"]];;
    [self.navigationController pushViewController:_settingsViewController animated:YES];
}

- (IBAction)share:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RATE_LINK]];
//    [shareActionSheet showInView:self.view];
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
//    [actionSheet addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"action_sheet_bg"]]];
    [[actionSheet layer] setBackgroundColor:[[UIColor colorWithRed:217.0f/255.0f green:151.0f/255.0f blue:55.0f/255.0f alpha:1.0f] CGColor]];
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
