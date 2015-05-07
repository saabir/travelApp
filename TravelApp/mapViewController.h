//
//  mapViewController.h
//  TravelApp
//
//  Created by Ramon Saccilotto on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// import MapBox MapView library for interactive offline maps
#import "RMMapView.h"

@interface mapViewController : UIViewController


@property (strong, nonatomic) IBOutlet RMMapView *mapView;

@end
