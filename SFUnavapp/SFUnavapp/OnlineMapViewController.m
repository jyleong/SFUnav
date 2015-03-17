//
//  OnlineMapViewController.m
//  SFUnavapp
//
//  Created by James Leong on 2015-03-15.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "OnlineMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface OnlineMapViewController ()


@end

@implementation OnlineMapViewController {
}

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
    // Do any additional setup after loading the view.
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate at SFU at zoom level 10.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.278094
                                                            longitude:-122.919883
                                                                 zoom:15];
    _sfumapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _sfumapView.myLocationEnabled = YES;
    self.view = _sfumapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(49.278094, -122.919883);
    marker.title = @"SFU";
    marker.snippet = @"Burnaby";
    marker.map = _sfumapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
