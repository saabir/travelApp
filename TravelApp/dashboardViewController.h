//
//  dashboardViewController.h
//  TravelApp
//
//  Created by Ramon Saccilotto on 20.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"
#import "RMMapViewDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DashboardViewController : UIViewController <RMMapViewDelegate, UITableViewDelegate>{
    BOOL tap;
}

@property (weak, nonatomic) IBOutlet UILabel *logo;

@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet RMMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITableView *countryListView;

@property (weak, nonatomic) IBOutlet UITableViewCell *cellPrototype;

- (IBAction)helpButtonPressed:(UIButton *)sender;
- (IBAction)locationButtonPressed:(UIButton *)sender;

- (IBAction)updateButtonPressed:(UIButton *)sender;

- (IBAction)optionButtonPressed:(UIButton *)sender;
- (IBAction)searchButtonPressed:(UIButton *)sender;
- (IBAction)searchViewButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonLabel;

@property (weak, nonatomic) IBOutlet UIButton *monthJanButton;
@property (weak, nonatomic) IBOutlet UIButton *monthFebButton;
@property (weak, nonatomic) IBOutlet UIButton *monthMarButton;
@property (weak, nonatomic) IBOutlet UIButton *monthAprButton;
@property (weak, nonatomic) IBOutlet UIButton *monthMaiButton;
@property (weak, nonatomic) IBOutlet UIButton *monthJunButton;
@property (weak, nonatomic) IBOutlet UIButton *monthJulButton;
@property (weak, nonatomic) IBOutlet UIButton *monthAugButton;
@property (weak, nonatomic) IBOutlet UIButton *monthSepButton;
@property (weak, nonatomic) IBOutlet UIButton *monthOctButton;
@property (weak, nonatomic) IBOutlet UIButton *monthNovButton;
@property (weak, nonatomic) IBOutlet UIButton *monthDecButton;

@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxRainLabel;


@end
