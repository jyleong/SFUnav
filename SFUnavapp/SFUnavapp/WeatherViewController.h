//
//  WeatherViewController.h
//  SFUnavapp
//
//  Created by James Leong on 2015-02-12.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webcam.h"
#import "WebcamWebViewController.h"

@interface WeatherViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Webcam* currentURL;
@property (weak, nonatomic) IBOutlet UITableView *webcamTable;

@end
