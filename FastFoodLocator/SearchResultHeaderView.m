//
//  LocationsTableHeaderView.m
//  FastFoodLocator
//
//  Created by Ning Gu on 13-5-31.
//  Copyright (c) 2013年 Ning Gu. All rights reserved.
//

#import "SearchResultHeaderView.h"

@interface SearchResultHeaderView ()
{
    UILabel *locationLabel;
    UIImageView *indicatorImage;
}

@end

@implementation SearchResultHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f blue:0.0f alpha:0.5f];
    self.opaque = NO;
    
    UIImage *tableHeaderImage = [UIImage imageNamed:@"glow-marker.png"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:tableHeaderImage];
    NSLog(@"%f", self.bounds.size.height);
    headerImageView.frame = CGRectMake(10,(self.frame.size.height - 44) / 2,31,44);
    
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, self.frame.origin.y, 200, self.frame.size.height)];
    locationLabel.opaque = NO;
    locationLabel.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0];
    locationLabel.textAlignment = NSTextAlignmentLeft;
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    locationLabel.text = @"Searching your location...";
    locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    locationLabel.numberOfLines = 0;
    
    indicatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator.png"]];
    indicatorImage.frame = CGRectMake(self.frame.origin.x + self.bounds.size.width - 25 - 10,(self.frame.size.height - 40) / 2,25,40);
    
    [self addSubview:headerImageView];
    [self addSubview:locationLabel];
    [self addSubview:indicatorImage];

}


- (void) initializeWithFrame:(CGRect)frame{
    self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f blue:0.0f alpha:0.5f];
    self.opaque = NO;
    
    UIImage *tableHeaderImage = [UIImage imageNamed:@"glow-marker.png"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:tableHeaderImage];
    headerImageView.frame = CGRectMake(10,(frame.size.height - 44) / 2,31,44);
    
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, frame.origin.y, 200, frame.size.height)];
    locationLabel.opaque = NO;
    locationLabel.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0];
    locationLabel.textAlignment = NSTextAlignmentLeft;
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    locationLabel.text = @"Searching your location...";
    locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    locationLabel.numberOfLines = 0;
    
    indicatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator.png"]];
    indicatorImage.frame = CGRectMake(frame.origin.x + frame.size.width - 25 - 10,(frame.size.height - 40) / 2,25,40);
    
    [self addSubview:headerImageView];
    [self addSubview:locationLabel];
    [self addSubview:indicatorImage];
    
}


-(void)layoutSubviews
{
    CGRect locationLabelFrame = locationLabel.frame;
    CGRect indicatorFrame = indicatorImage.frame;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
        locationLabelFrame.size.width = 380;
        
    }else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        locationLabelFrame.size.width = 200;
    }
    
    indicatorFrame.origin.x = self.frame.origin.x + self.bounds.size.width - indicatorFrame.size.width - 10;
    
    locationLabel.frame = locationLabelFrame;
    indicatorImage.frame = indicatorFrame;
}

- (void)changeLocationVicinity:(NSString *)location
{
    locationLabel.text = location;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f blue:0.0f alpha:0.5f]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f blue:0.0f alpha:0.5f]];
}

@end
