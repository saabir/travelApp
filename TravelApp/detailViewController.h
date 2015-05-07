//
//  detailViewController.h
//  TravelApp
//
//  Created by Ramon Saccilotto on 26.03.12.
//  Copyright (c) 2012 retrocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController

@property (strong, nonatomic, readwrite) IBOutlet UIWebView *webView;
- (IBAction)closeButtonPressed:(UIButton *)sender;

@end
