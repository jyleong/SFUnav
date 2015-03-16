//
//  OnlineMapViewController.m
//  SFUnavapp
//
//  Created by James Leong on 2015-03-15.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "OnlineMapViewController.h"
#import "MVSFU.h"
#import "MVSFUMapOverlay.h"
#import "MVSFUMapOverlayView.h"

@interface OnlineMapViewController ()
@property (nonatomic,strong) MVSFU *sfum;

@end

@implementation OnlineMapViewController

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
    
    self.sfum = [[MVSFU alloc] initWithFilename:@"SFUlatlongCoor"];
    
    
    CLLocationDegrees latDelta = self.sfum.overlayTopLeftCoordinate.latitude - self.sfum.overlayBottomRightCoordinate.latitude;
    
    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabsf(latDelta), 0.01);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(self.sfum.midCoordinate, span);
    
    [self.sfumapView setRegion:region];
    [self addOverlay];
    
    [self.sfumapView setShowsUserLocation:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addOverlay {
    MVSFUMapOverlay *overlay = [[MVSFUMapOverlay alloc] initWithSFU:self.sfum];
    [self.sfumapView addOverlay:overlay];
    NSLog(@"addoverlay called?");
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:MVSFUMapOverlay.class]) {
        UIImage *sfuImage = [UIImage imageNamed:@"all_campus_map_rotated.png"];
        MVSFUMapOverlayView *overlayView = [[MVSFUMapOverlayView alloc] initWithOverlay:overlay overlayImage:sfuImage];
        return overlayView;
    }
    
    return nil;
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
