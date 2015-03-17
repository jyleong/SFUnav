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
@property (weak, nonatomic) IBOutlet UIButton *clrBtn;


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
    
    self.navigationController.navigationBar.topItem.title = @"";
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate at SFU at zoom level 10.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.278094
                                                            longitude:-122.919883
                                                                 zoom:15];
    _sfumapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [self.view insertSubview:_sfumapView atIndex:0];
    _sfumapView.myLocationEnabled = YES;
    self.view = _sfumapView;
    _sfumapView.delegate = self;
    [self.view addSubview:_clrBtn];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(49.278094, -122.919883);
    marker.title = @"SFU";
    marker.snippet = @"Burnaby";
    marker.map = _sfumapView;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title=@"Google Maps";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    GMSMarker *usertapMarker = [[GMSMarker alloc] init];
    usertapMarker.appearAnimation = kGMSMarkerAnimationPop;
    usertapMarker.position = coordinate;
    usertapMarker.title = [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
    usertapMarker.map = _sfumapView;
}
- (IBAction)clearMark:(id)sender {
    [_sfumapView clear];
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
