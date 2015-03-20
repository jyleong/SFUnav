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
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic) GMSMapView *sfumapView;

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
    //// this block enables iOS 8 to use location services, will  not buliding in xcode,
    //comment the block out to test proj in xcode 5
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    //////////////////////////////////////////
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.278094
                                                            longitude:-122.919883
                                                                 zoom:15];

    self.sfumapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    [self.view insertSubview:_sfumapView atIndex:0];
    
    _sfumapView.myLocationEnabled = YES;
    //Controls the type of map tiles that should be displayed.
    _sfumapView.mapType = kGMSTypeNormal;
    //Shows the compass button on the map
    _sfumapView.settings.compassButton = YES;
    //Shows the my location button on the map
    _sfumapView.settings.myLocationButton = YES;
    //Sets the view controller to be the GMSMapView delegate
    _sfumapView.delegate = self;
    [self.sfumapView addSubview:_clrBtn];
    //[self.sfumapView addSubview:_searchBar];
    [self.view insertSubview:_searchBar aboveSubview:_sfumapView];

    
    [self.sfumapView addObserver:self forKeyPath:@"myLocation" options:0 context:nil];
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



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    /*self.navigationController.navigationBar.hidden=TRUE;
    CGRect r=self.view.frame;
    r.origin.y=-44;
    r.size.height+=44;
    
    self.view.frame=r;*/
    
    [searchBar setShowsCancelButton:YES animated:YES];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //This'll Hide The cancelButton with Animation
    [searchBar setShowsCancelButton:NO animated:YES];
    //remaining Code'll go here
    [searchBar resignFirstResponder];
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
