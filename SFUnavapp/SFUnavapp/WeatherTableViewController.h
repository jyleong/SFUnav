//
//  WeatherTableViewController.h
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-05.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
    Tableview controller class to handle two sections for campus status (HTML Parsing) and webcam selection
 */
#import <UIKit/UIKit.h>
#import "Webcam.h"
#import "Campus.h"
#import "WebcamWebViewController.h"
#import "TFHpple.h"

@interface WeatherTableViewController : UITableViewController

@property (nonatomic) Webcam* currentURL;
@property (nonatomic) Campus* currentCampus;

@end
