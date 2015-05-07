//
//  DashboardView.m
//  TravelApp
//
//  Created by Ramon Saccilotto on 12.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//
//  DESCRIPTION:
//  Custom view to display a mapview and scrollview for the list
//  of countries as it's subviews. 
//  The view is derived from UIScrollView and allows only vertical scrolling.
//  If the users scrolls down or pulls up the lower UIScrollView,
//  the map is hidden and the list of countries is expanded to a full view.
//
//  Currently, only the landscape mode is implemented

#import "travelAppDashboardView.h"

@implementation travelAppDashboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// resize subviews depending on the device orientation
// this can be enabled as soon as we implement a different
// device orientation
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // get the frame of the dashboard view
    CGRect theFrame = self.frame;
    
    // check if width smaller than height -> portrait mode
    if (CGRectGetWidth(theFrame) < CGRectGetHeight(theFrame))
    {
        NSLog(@"%@", @"Portrait mode");
    }
    // landscape mode
    else
    {
        NSLog(@"%@", @"Landscape mode");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
