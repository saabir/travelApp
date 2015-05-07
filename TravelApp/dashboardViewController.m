//
//  dashboardViewController.m
//  TravelApp
//
//  Created by Ramon Saccilotto on 20.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import "dashboardViewController.h"
#import "travelAppDelegate.h"
#import "CurrentLocation.h"
#import "Country.h"

// import detail view controller
#import "detailViewController.h"

// import libraries for interactive map view from mbtiles document
#import <CoreLocation/CoreLocation.h>
#import "RMMBTilesTileSource.h"
#import "RMMapContents.h"
#import "RMInteractiveSource.h"
#import "RMMarker.h"
#import "RMMarkerManager.h"

#pragma mark Private properties and methods

@interface DashboardViewController ()

// class to get current location
@property(nonatomic, retain, readwrite) CurrentLocation *localisation;

// cell identifiers for country list
@property(nonatomic, retain, readwrite) NSArray *cellIdentifiers;

// array of countries as fetch result
@property(nonatomic, retain, readwrite) NSArray *countries;
@property(nonatomic, retain, readwrite) NSArray *continents;
@property(nonatomic, retain, readwrite) NSMutableArray *regions;

// array for search attributres
@property(nonatomic,retain,readwrite) NSMutableArray * selectedMonths;
@property(nonatomic,retain,readwrite) NSString *temperatureMaximum;
@property(nonatomic,retain,readwrite) NSString *temperatureMinimum;
@property(nonatomic,retain,readwrite) NSString *precipitationMaximum;

@property(nonatomic,retain,readwrite) Country *selectedCountry;

- (void)registerObservers;
- (void)fetchCountryInfo;
- (void)initView;
- (void)initMapView;

@end

@implementation DashboardViewController

@synthesize searchButtonLabel;
@synthesize monthJanButton;
@synthesize monthFebButton;
@synthesize monthMarButton;
@synthesize monthAprButton;
@synthesize monthMaiButton;
@synthesize monthJunButton;
@synthesize monthJulButton;
@synthesize monthAugButton;
@synthesize monthSepButton;
@synthesize monthOctButton;
@synthesize monthNovButton;
@synthesize monthDecButton;
@synthesize maxTempLabel;
@synthesize minTempLabel;
@synthesize maxRainLabel;

@synthesize logo = logo_;
@synthesize optionView;
@synthesize mainView;
@synthesize mapView = mapView_;
@synthesize searchView;
@synthesize countryListView = countryListView_;
@synthesize cellPrototype = cellPrototype_;
@synthesize cellIdentifiers = cellIdentifiers_;
@synthesize localisation = localisation_;

@synthesize countries = countries_;
@synthesize continents = continents_;
@synthesize regions = regions_;
@synthesize selectedCountry = selectedCountry_;

@synthesize selectedMonths = selectedMonths_;
@synthesize temperatureMaximum = temperatureMaximum_;
@synthesize temperatureMinimum = temperatureMinimum_;
@synthesize precipitationMaximum = precipitationMaximum_;


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
    
    // register observers
    [self registerObservers];
    
    // load the list of countries
    [self fetchCountryInfo];

    // initialize special view properties
    [self initView];
    
    // initialize map view
    [self initMapView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    NSLog(@"DID RECEIVE MEMORY WARNING");
    
}

- (void)viewDidUnload
{
    [self setLogo:nil];
    [self setLocalisation:nil];
    [self setCellIdentifiers:nil];
    [self setCountries:nil];
    [self setContinents:nil];
    [self setRegions:nil];

    // remove observers from this view controller
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    [theCenter removeObserver:self];
    
    [self setMainView:nil];
    [self setOptionView:nil];
    [self setCountryListView:nil];
    [self setCellPrototype:nil];
    [self setMaxTempLabel:nil];
    [self setMinTempLabel:nil];
    [self setMaxRainLabel:nil];
    [self setSearchView:nil];
    [self setPrecipitationMaximum:nil];
    [self setTemperatureMaximum:nil];
    [self setTemperatureMinimum:nil];
    [self setMonthJanButton:nil];
    [self setMonthFebButton:nil];
    [self setMonthMarButton:nil];
    [self setMonthAprButton:nil];
    [self setMonthMaiButton:nil];
    [self setMonthJunButton:nil];
    [self setMonthJulButton:nil];
    [self setMonthAugButton:nil];
    [self setMonthSepButton:nil];
    [self setMonthOctButton:nil];
    [self setMonthNovButton:nil];
    [self setMonthDecButton:nil];
    [self setSearchButtonLabel:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    [self setMapView:nil];
    
}

// should only use allowed interface orientations (currently only landscape)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark Controller setup

// set main label and icons
- (void)initView
{
    // set main label with custom font cubano (for italic font use Cubano-Italic)
    [self.logo setFont:[UIFont fontWithName:@"Cubano" size:25.0f]];
    
    // initialize table view
    self.countryListView.delegate = self;
    
    // initialize months in search view
    [self resetMonthButtons];
    
    // show map in full screen -> remove later and adapt storyboard
    /*CGRect theFrame = self.mainView.frame;
    theFrame.size.width = 1024.0f;
    theFrame.origin.x = 0.0f;
    [UIView animateWithDuration:0.05 animations:^{
        self.mainView.frame = theFrame;
    }];*/
    
}

- (void)registerObservers
{
    // get the default notification center
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    // add observer for click on continent button
    [theCenter addObserver:self
                  selector:@selector(showInfoForLocationServiceNotAvailable)
                      name:@"locationServicesNotAvailable"
                    object:nil];
    
    [theCenter addObserver:self
                  selector:@selector(focusMapOnLocation:)
                      name:@"currentLocationAcquired"
                    object:nil];
    
    [theCenter addObserver:self
                  selector:@selector(focusMapOnLocation:)
                      name:@"showCountryWithLocation"
                    object:nil];
    
}


#pragma mark Help


- (IBAction)helpButtonPressed:(UIButton *)sender {
    
    NSURL *movieUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"screencast" ofType:@"mp4"]];
    
    // load a movie view
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]initWithContentURL:movieUrl];
    
    [player setModalPresentationStyle:UIModalPresentationPageSheet];
    
    [self presentModalViewController:player animated:true];
    
}

#pragma mark - Current location of the user

// get current position of user and show it in the map
- (IBAction)locationButtonPressed:(UIButton *)sender {
    
    // get a localisation class
    self.localisation = [[CurrentLocation alloc] init];
    
    // start monitoring the localisation
    [self.localisation getCurrentLocation];
    
    // if localisation is not activated a notification of type
    // "locationServicesNotAvailable" will be issued
    
    // if localisation is found a notification of type
    // "currentLocationAcquired" will be issued with the 
    // userInfo "locationInfo" containing a NSDictionary with
    // latitude and longitude
    
}

- (IBAction)updateButtonPressed:(UIButton *)sender {
    
    UIAlertView *uploadAlert = [[UIAlertView alloc] initWithTitle:@"Update" message:@"The app would now check with the server if any updates are available and download them if necessary." delegate:nil cancelButtonTitle:@"OK. Great." otherButtonTitles:nil];
    
    [uploadAlert show];
}

// show info to user if location services are disabled
- (void)showInfoForLocationServiceNotAvailable
{
    UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be re-enabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [servicesDisabledAlert show];
}


#pragma mark - Map view

// load a map from an offline source file
- (void)initMapView
{
    /*
    self.mapView = [[RMMapView alloc] initWithFrame:self.mapView.bounds];
    
    self.mapView.delegate = self;
    
    //[self.view addSubview:self.mapView];
    
    NSURL *tileSetURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"geography-class-mini" ofType:@"mbtiles"]];
    
    RMMBTilesTileSource *source = [[RMMBTilesTileSource alloc] initWithTileSetURL:tileSetURL];
    
    self.mapView.contents.mapCenter  = CLLocationCoordinate2DMake(40.0, 0.0);
    self.mapView.contents.zoom       = 2.5;
    self.mapView.contents.minZoom    = self.mapView.contents.zoom;
    self.mapView.contents.maxZoom    = source.maxZoom;
    self.mapView.contents.tileSource = source;
     */

    /*
     // initialize the map view
     RMMapView *newMapView = [[RMMapView alloc] initWithFrame:self.mapView.bounds];
     
     // set background color to black
     newMapView.backgroundColor = [UIColor blackColor];
     
     // set delegate for mapView
     newMapView.delegate = self;
     
     // set mapView as new mapview
     self.mapView = newMapView;
     
    */
    
    // get url of mbtiles file
    //NSURL *tileSetURL = [[NSBundle mainBundle] URLForResource:@"travelapp" withExtension:@"mbtiles"];
    
    //NSURL *tileSetURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"travelapp" ofType:@"mbtiles"]];
    
    NSURL *tileSetURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"geography-class-mini" ofType:@"mbtiles"]];
    
    // set source of tile view
    RMMBTilesTileSource *source = [[RMMBTilesTileSource alloc] initWithTileSetURL:tileSetURL];
    
    [[RMMapContents alloc] initWithView:self.mapView 
                             tilesource:source
                           centerLatLon:CLLocationCoordinate2DMake(45.0f, -9.0f)
                              zoomLevel:2.5f
                           maxZoomLevel:source.maxZoom 
                           minZoomLevel:2.5f
                        backgroundImage:nil];
    
    /*
     // set map properties
     self.mapView.contents.mapCenter  = CLLocationCoordinate2DMake(45.0, 10.0);
     self.mapView.contents.zoom       = 1.0f;
     self.mapView.contents.minZoom    = self.mapView.contents.zoom;
     self.mapView.contents.maxZoom    = source.maxZoom;
     self.mapView.contents.tileSource = source;
     
     */
    
    // set background color of map view
    self.mapView.backgroundColor = [UIColor blackColor];
    
    // set delegate for actions
    self.mapView.delegate = self;
    
    // reset the zoom level
    self.mapView.contents.zoom = 2.5f;
    
    // do not respond to rotation or deceleration
    self.mapView.enableRotate = NO;
    self.mapView.deceleration = NO;
    
}

// go back to the overview of all continents
- (void)showMapOverview
{
    // set map back to overview
    self.mapView.contents.mapCenter = CLLocationCoordinate2DMake(45.0f, -9.0f);
    self.mapView.contents.zoom = 2.5f;
}

// set the focus of the map view to a certain continent
- (void)focusMapOnLocation:(NSNotification *)inNotification
{
    // get markerManager of mapView
    RMMarkerManager *markerManager = [self.mapView markerManager];
    
    // remove all markers
    [markerManager removeMarkers];
	    
    // notification is carrying a continent
    NSDictionary *location = [[inNotification userInfo] objectForKey:@"locationInfo"];
    
    NSNumber *latitude = [location objectForKey:@"latitude"];
    NSNumber *longitude = [location objectForKey:@"longitude"];
    
    tap=NO;
    
	CLLocationCoordinate2D mylocation;
	mylocation.latitude = [latitude floatValue];
	mylocation.longitude = [longitude floatValue];
    
    RMMarker *marker;
	
    if([[location objectForKey:@"type"] isEqualToString:@"currentLocation"])
    {
        // current location marker will be displayed in red
        marker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-red.png"]
                                                anchorPoint:CGPointMake(0.5, 1.0)];
    }
    else {
        // all other markers are blue
        marker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-blue.png"]
                                                anchorPoint:CGPointMake(0.5, 1.0)];
    }
    
    
    // no focus on the marker
    self.mapView.contents.mapCenter = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    
    [markerManager addMarker:marker AtLatLong:mylocation];
        
}


// respond to single tap action on map view
- (void)singleTapOnMap:(RMMapView *)currentMapView At:(CGPoint)point
{
    
    // get tile source of the map
    id source = currentMapView.contents.tileSource;
    
    NSLog(@"Tap on Map");
    
    // TODO GET INFORMATION FROM CLICKING ON TILES
    // SOMEHOW THE TILE DOES NOT IMPLEMENT THE RMINTERACTIVESOURCE PROTOCOL
    
    //return;
    
    BOOL tmp = [source conformsToProtocol:@protocol(RMInteractiveSource)];
    
    NSLog(@"%@",tmp);
    
    if ([source conformsToProtocol:@protocol(RMInteractiveSource)] && [(id <RMInteractiveSource>)source supportsInteractivity])
    {
        source = (id <RMInteractiveSource>)source;
        
        NSString *formattedOutput = [source formattedOutputOfType:RMInteractiveSourceOutputTypeFull 
                                                         forPoint:point 
                                                        inMapView:self.mapView];
        
        if ( ! formattedOutput || ! [formattedOutput length])
            formattedOutput = [source formattedOutputOfType:RMInteractiveSourceOutputTypeTeaser 
                                                   forPoint:point 
                                                  inMapView:self.mapView];
        
        if (formattedOutput && [formattedOutput length])
        {
            NSLog(@"%@", formattedOutput);
        }
    }
    
}

- (void) tapOnMarker:(RMMarker*)marker onMap:(RMMapView*)map
{
    
    // get info for the country and display it in a separate view
    if((self.selectedCountry == nil) == false)
    {
        // get appdelegate for searches
        travelAppDelegate *appDelegate = (travelAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // init country info
        NSMutableString *infoText = [[NSMutableString alloc] initWithString:[[NSString alloc] initWithFormat:@"<!DOCTYPE html><html><head></head><body><div><h1>%@</h1>", self.selectedCountry.name]];
        
        // **** NATIONAL LANGUAGES ****
        
        // get detail-info of country (e.g. languages)
        NSArray *infos = [appDelegate.travelAppSearchController fetchValuesForAttribute:@"National language" forCountry: [self.selectedCountry iso_code]]; 
        
        // attributes currently available are "National language", "Time difference with Switzerland", "Voltage", "Credit card", "Travelers Cheques", "Banknotes", "Swiss Embassy / Consulate", "Driving", "Health situation", "Tourism", "Currency", "Other information"
        
        
        // add title
        [infoText appendString:@"<section><h2>Languages</h2><ul>"];
        
        if(infos.count > 0){
            // add further detail info to country info
            for(NSString *value in infos){
                
                // add a list item
                [infoText appendString:[[NSString alloc] initWithFormat:@"<li>%@</li>", value]];
                
            }
        }
        else{
            // add a list item
            [infoText appendString:[[NSString alloc] initWithFormat:@"<li>no information available</li>"]];
        }
        
        // close list
        [infoText appendString:@"</ul></section>"];
        
        // **** HEALTH SITUATION ****
        
        // get detail-info of country (e.g. Health situation)
        infos = [appDelegate.travelAppSearchController fetchValuesForAttribute:@"Health situation" forCountry: [self.selectedCountry iso_code]]; 
        
        // attributes currently available are "National language", "Time difference with Switzerland", "Voltage", "Credit card", "Travelers Cheques", "Banknotes", "Swiss Embassy / Consulate", "Driving", "Health situation", "Tourism", "Currency", "Other information"
        
        
        // add title
        [infoText appendString:@"<section><h2>Health Situation</h2><ul>"];
        
        if(infos.count > 0){
            // add further detail info to country info
            for(NSString *value in infos){
                
                // add a list item
                [infoText appendString:[[NSString alloc] initWithFormat:@"<li>%@</li>", value]];
                
            }
        }
        else{
            // add a list item
            [infoText appendString:[[NSString alloc] initWithFormat:@"<li>no information available</li>"]];
        }
        
        
        // close list
        [infoText appendString:@"</ul></section>"];
        
        
        // **** Currency ****
        
        // get detail-info of country (e.g. Health situation)
        infos = [appDelegate.travelAppSearchController fetchValuesForAttribute:@"Currency" forCountry: [self.selectedCountry iso_code]]; 
        
        // attributes currently available are "National language", "Time difference with Switzerland", "Voltage", "Credit card", "Travelers Cheques", "Banknotes", "Swiss Embassy / Consulate", "Driving", "Health situation", "Tourism", "Currency", "Other information"
        
        
        // add title
        [infoText appendString:@"<section><h2>Currency</h2><ul>"];
        
        if(infos.count > 0){
            // add further detail info to country info
            for(NSString *value in infos){
                
                // add a list item
                [infoText appendString:[[NSString alloc] initWithFormat:@"<li>%@</li>", value]];
                
            }
        }
        else{
            // add a list item
            [infoText appendString:[[NSString alloc] initWithFormat:@"<li>no information available</li>"]];
        }
        
        
        // close list
        [infoText appendString:@"</ul></section>"];
        
    
        // close the main container
        [infoText appendString:@"</div></body></html>"];
        
        
        // instantiate a new controller for the detail view
        detailViewController *webViewController = [[detailViewController alloc] initWithNibName:@"detailViewController" bundle:nil];
        
        // load the view (without making it visible
        [webViewController loadView];
        
        // set the content of the webview
        [webViewController.webView loadHTMLString:infoText baseURL:nil];
        
        [webViewController setModalPresentationStyle:UIModalPresentationFormSheet];
        
        // present the detail view as modal view
        [self presentModalViewController:webViewController animated:YES];
        
                
    }
    else
    {
        /*
        UIAlertView *noInfoAlert = [[UIAlertView alloc] initWithTitle:@"Country Information" message:@"Unfortunately there is no further information available for this country." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noInfoAlert show];
         */
    }
    
	//RMMarkerManager *markerManager = [self.mapView markerManager];
    
	/*if(!tap)
	{
		[marker replaceUIImage:[UIImage imageNamed:@"marker-red.png"]];
		[marker changeLabelUsingText:@"World"];
		tap=YES;
		[markerManager moveMarker:marker AtXY:CGPointMake([marker position].x,[marker position].y + 20.0)];
		[self.mapView setDeceleration:YES];
	}else
	{
        [marker replaceUIImage:[UIImage imageNamed:@"marker-blue.png"]
                   anchorPoint:CGPointMake(0.5, 1.0)];
		[marker changeLabelUsingText:@"Hello"];
		[markerManager moveMarker:marker AtXY:CGPointMake([marker position].x,[marker position].y - 20.0)];
		tap=NO;
		[self.mapView setDeceleration:NO];
	}*/
    
}

// do not allow dragging of markers
- (BOOL)mapView:(RMMapView *)map shouldDragMarker:(RMMarker *)marker withEvent:(UIEvent *)event
{
    //If you do not implement this function, then all drags on markers will be sent to the didDragMarker function.
    //If you always return YES you will get the same result
    //If you always return NO you will never get a call to the didDragMarker function
    return NO;
}

#pragma mark - Option pane

// show hide option pane
- (IBAction)optionButtonPressed:(UIButton *)sender {
    
    // animate show/hide of option view
    if (self.mainView.frame.origin.x > 10)
    {
        CGRect theFrame = self.mainView.frame;
        theFrame.size.width = 1024.0f;
        theFrame.origin.x = 0.0f;
        [UIView animateWithDuration:0.35 animations:^{
            self.mainView.frame = theFrame;
        }];
    }
    else
    {
        CGRect theFrame = self.mainView.frame;
        theFrame.size.width = 725.0f;
        theFrame.origin.x = 299.0f;
        [UIView animateWithDuration:0.35 animations:^{
            self.mainView.frame = theFrame;
        }];
    }
    
}

- (IBAction)searchButtonPressed:(UIButton *)sender {
    
    // perform search
    travelAppDelegate *appDelegate = (travelAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Guard against nil items
    NSArray *selectedCountries = [appDelegate.travelAppSearchController fetchCountryWithViewPredicates:self.selectedMonths withTempretureMax:self.temperatureMaximum withTempMin:self.temperatureMinimum withRain:self.precipitationMaximum];
    
    NSLog(@"Number of countries found %d", [selectedCountries count]);
    
    // create a new dictionary entry
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:@"SEARCH RESULTS", @"continent", nil];
    
    // define it as only continent
    self.continents = [[NSArray alloc] initWithObjects:tmp, nil];
    
    // we have only one region set all countries in this region
    self.regions = [[NSMutableArray alloc]initWithObjects:selectedCountries, nil];
    
    // now we have to refresh the table view
    [self.countryListView reloadData];
    
    // change label of the button to show the search view
    [self.searchButtonLabel setTitle:@"SHOW SEARCH" forState:UIControlStateNormal];
    
    // animate hiding of search pane
    CGRect theFrame = self.searchView.frame;
    theFrame.origin.y = -685.0f;
    [UIView animateWithDuration:0.35 animations:^{
        self.searchView.frame = theFrame;
    }];
    

    
}

- (IBAction)searchViewButtonPressed:(UIButton *)sender {
    
    // animate show/hide of option view
    if (self.searchView.frame.origin.y > 0)
    {
        CGRect theFrame = self.searchView.frame;
        theFrame.origin.y = -685.0f;
        [UIView animateWithDuration:0.35 animations:^{
            self.searchView.frame = theFrame;
        }];
        
        [sender setTitle:@"SHOW SEARCH" forState:UIControlStateNormal];
        
    }
    else
    {
        CGRect theFrame = self.searchView.frame;
        theFrame.origin.y = 43.0f;
        [UIView animateWithDuration:0.35 animations:^{
            self.searchView.frame = theFrame;
        }];
        
        [sender setTitle:@"CANCEL SEARCH" forState:UIControlStateNormal];
    }
}


- (void)resetMonthButtons
{
    // reset the months
    self.selectedMonths = [[NSMutableArray alloc]init];
    
    // set all buttons to not selected
    [self.monthJanButton setSelected:false];
    [self.monthFebButton setSelected:false];
    [self.monthMarButton setSelected:false];
    [self.monthAprButton setSelected:false];
    [self.monthMaiButton setSelected:false];
    [self.monthJunButton setSelected:false];
    [self.monthJulButton setSelected:false];
    [self.monthAugButton setSelected:false];
    [self.monthSepButton setSelected:false];
    [self.monthOctButton setSelected:false];
    [self.monthNovButton setSelected:false];
    [self.monthDecButton setSelected:false];

}

// button for month was pressed
- (IBAction)monthButtonPressed:(UIButton *)sender
{

    if (sender.selected == FALSE)
    {
        [sender setSelected:TRUE];
        switch([sender tag]){
            case 1:
                [self.selectedMonths addObject:@"JAN"];
                break;
            case 2:
                [self.selectedMonths addObject:@"FEB"];
                break;
            case 3:
                [self.selectedMonths addObject:@"MAR"];
                break;
            case 4:
                [self.selectedMonths addObject:@"APR"];
                break;
            case 5:
                [self.selectedMonths addObject:@"MAI"];
                break;
            case 6:
                [self.selectedMonths addObject:@"JUN"];
                break;
            case 7:
                [self.selectedMonths addObject:@"JUL"];
                break;
            case 8:
                [self.selectedMonths addObject:@"AUG"];
                break;
            case 9:
                [self.selectedMonths addObject:@"SEP"];
                break;
            case 10:
                [self.selectedMonths addObject:@"OCT"];
                break;
            case 11:
                [self.selectedMonths addObject:@"NOV"];
                break;
            case 12:
                [self.selectedMonths addObject:@"DEC"];
                break;
        }

    }
    else
    {
        [sender setSelected:FALSE];
        NSString *removeMonth ;
        
        switch([sender tag]){
            case 1:
                removeMonth = @"Jan";
                break;
            case 2:
                removeMonth = @"Feb";
                break;
            case 3:
                removeMonth = @"Mar";
                break;
            case 4:
                removeMonth = @"Apr";
                break;
            case 5:
                removeMonth = @"Mai";
                break;
            case 6:
                removeMonth = @"Jun";
                break;
            case 7:
                removeMonth = @"Jul";
                break;
            case 8:
                removeMonth = @"Aug";
                break;
            case 9:
                removeMonth = @"Sep";
                break;
            case 10:
                removeMonth = @"Oct";
                break;
            case 11:
                removeMonth = @"Nov";
                break;
            case 12:
                removeMonth = @"Dec";
                break;
        }
        
        // this section should be optimized
        for(int i = 0; i < [self.selectedMonths count]; i++)
        {
            NSString *s = [self.selectedMonths objectAtIndex:i];
            
            if([s isEqualToString:removeMonth]){
                [self.selectedMonths removeObjectAtIndex:i];
                
                return;
            }
        }
        
        
    }
    
}


- (IBAction)sliderMoved:(UISlider *)sender {
    
    // get actual slider
    UISlider *slider = (UISlider *)sender;
    
    switch ([sender tag]) {
        case 0:
            self.maxTempLabel.text = [NSString stringWithFormat:@"%0.0f°C", slider.value];
            self.temperatureMaximum = [NSString stringWithFormat:@"0.0f", slider.value];
            //NSLog(@"Slider maximum temperature %@",self.temperatureMaximum);
            break;
            
        case 1:
            self.minTempLabel.text = [NSString stringWithFormat:@"%0.0f°C", slider.value];
            self.temperatureMinimum = [NSString stringWithFormat:@"%0.0f", slider.value];
            //NSLog(@"Slider minimum temperature %@",self.temperatureMinimum);
            break;
            
        case 2:
            self.maxRainLabel.text= [NSString stringWithFormat:@"%0.0fmm", slider.value];
            self.precipitationMaximum=[NSString stringWithFormat:@"%0.0f", slider.value];
            //NSLog(@"Slider maximum rain %@", self.precipitationMaximum);
            break;
            
        default:
            break;
    }
}


#pragma mark - Fetch countries

// get all countries sorted by continent and alphabet
- (void)fetchCountryInfo
{
    // get app delegate
    travelAppDelegate *appDelegate = (travelAppDelegate *)[[UIApplication sharedApplication] delegate];
        
    // fetch continents
    self.continents =  [appDelegate.travelAppSearchController fetchAllContinents];
    
    // initialize array for regions
    self.regions = [[NSMutableArray alloc] initWithCapacity:[self.continents count]];
    
    NSLog(@"Number of continents: %d", [self.continents count]);
    
    for (NSDictionary *continent in self.continents) {
        
        NSLog(@"continent: %@", [continent objectForKey:@"continent"]);
        
        // get continent as string
        NSString * tmp = [[NSString alloc] initWithFormat:@"%@",[continent objectForKey:@"continent"]];
        
        // load all countries for the continent
        [self.regions addObject:[appDelegate.travelAppSearchController fetchCountriesFromContinent:tmp]];
    }
    
    /*
    for (id country in countries) {
        NSLog(@"Country name %@", [country performSelector:@selector(name)]);
        NSLog(@"Country name %@", [country performSelector:@selector(iso_code)]);
    }
    
    // get the number of countries
    NSInteger numberOfCountries = [countries count];
    
    // show number of countries
    NSLog(@"Number of countries: %d", numberOfCountries);
    
     */
}

#pragma mark - Table view data source

// return the number of sections in the table
// this should return the number of continents
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.continents count];
}

// return the number of rows in each section
// should return the number of countries for the respective continent
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // get the countries of each continent and count them
    return [[self.regions objectAtIndex:section] count];
    
}

// set the title of the section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // get name of continent
    NSString *tmp = [[NSString alloc] initWithFormat:@"%@",[[self.continents objectAtIndex:section] objectForKey:@"continent"]];
    
    if ([tmp isEqualToString:@"AF"])
    {
        return @"Africa";
    }
    else if ([tmp isEqualToString:@"EU"])
    {
        return @"Europe";
    }
    else if ([tmp isEqualToString:@"NA"])
    {
        return @"North America";
    }
    else if ([tmp isEqualToString:@"SA"])
    {
        return @"South America";
    }
    else if ([tmp isEqualToString:@"OC"])
    {
        return @"Oceania";
    }
    else if ([tmp isEqualToString:@"AS"])
    {
        return @"Asia";
    }
    else if ([tmp isEqualToString:@"AN"])
    {
        return @"Antarctica";
    }
	
    return [[NSString alloc] initWithFormat:@"%@ (%d)", tmp, [[self.regions objectAtIndex:section] count]];
    
}

// create the cell at a specific index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"country";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier.
	if (cell == nil) {
		// Use the default cell style.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
	}
	
    NSArray *region = [self.regions objectAtIndex:indexPath.section];
    
    NSLog(@"%d",[region count]);
    
	// Set up the cell with name of country
    @try {
        cell.textLabel.text = [[region objectAtIndex:indexPath.row] performSelector:@selector(name)];
	} 
	@catch (id theException) {
		NSLog(@"ERROR WITH COUNTRY GETNAME");
        cell.textLabel.text = @"--";
	} 

	return cell;

}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the current region
    NSArray *region = [self.regions objectAtIndex:indexPath.section];
    
	// select the respective country
	Country *country = [region objectAtIndex:indexPath.row];
    
    // save country for later
    self.selectedCountry = country;
    
    // send notification to navigate map to respective country
    
    NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys: country.latitude, @"latitude",  country.longitude, @"longitude", @"country", @"type", country, @"item", nil];
    
    // pass the information of the continent on to anyone who is listening
    NSDictionary *locationInfo = [NSDictionary dictionaryWithObjectsAndKeys:location, @"locationInfo", nil];
    
    // get the default notification center
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    // post notification
    [theCenter postNotificationName:@"showCountryWithLocation" object:nil userInfo:locationInfo];
    
}

@end
