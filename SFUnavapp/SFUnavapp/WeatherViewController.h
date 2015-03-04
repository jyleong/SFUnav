//
//  WeatherViewController.h
//  SFUnavapp
//  Team NoMacs
//  Created by Arjun Rathee on 2015-02-12.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webcam.h"
#import "WebcamWebViewController.h"
#import "Campus.h"
#import "TFHpple.h"
#import <QuartzCore/QuartzCore.h>


@interface WeatherViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Webcam* currentURL;
@property (weak, nonatomic) IBOutlet UITableView *webcamTable;
@property (nonatomic) Campus* currentCampus;
@property (weak, nonatomic) IBOutlet UITableView *campusTable;

@end
