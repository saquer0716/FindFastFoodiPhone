//
//  MapViewController.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-6-11.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "MapViewController.h"

static NSString const* kNormalType = @"Normal";
static NSString const* kHybridType = @"Hybrid";
static NSString const* kSatelliteType = @"Satellite";
static NSString const* kTerrainType = @"Terrain";

@interface MapViewController ()
{
    
}

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureToolBar];
    
    _zoomToMarker = [[NSUserDefaults standardUserDefaults] boolForKey:@"zoom_route_preference"];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    [super viewWillAppear:animated];
}

- (IBAction)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureToolBar
{
    NSArray *mapTypes = @[kNormalType, kHybridType, kSatelliteType, kTerrainType];
    UISegmentedControl *mapTypeToggle = [[UISegmentedControl alloc] initWithItems:mapTypes];
    mapTypeToggle.frame = CGRectInset(self.navigationController.navigationBar.frame, self.navigationController.navigationBar.frame.size.width / 4, 6);
    mapTypeToggle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    mapTypeToggle.segmentedControlStyle = UISegmentedControlStyleBar;
    mapTypeToggle.selectedSegmentIndex = 0;
    [mapTypeToggle addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventValueChanged];
//    mapTypeToggle.tintColor = [UIColor blueColor];
//    mapTypeToggle.alpha = 0.2;
    
    self.navigationItem.titleView = mapTypeToggle;
}

- (IBAction)changeMapType:(id)sender{
    [[self delegate] mapTypeDidSelectedAt:[sender selectedSegmentIndex]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
