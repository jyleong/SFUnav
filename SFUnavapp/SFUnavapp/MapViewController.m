//
//  MapViewController.m
//  SFUnavapp
//  Team NoMacs
//
//  Created by Arjun Rathee on 2015-03-03.
//  Edited by Arjun Rathee
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
    UIColor * bgrnd = [UIColor colorWithRed:182/255.0f green:189/255.0f blue:147/255.0f alpha:1.0f];
    _scrollView.backgroundColor=bgrnd;
    
    self.scrollView.minimumZoomScale=0.2;
    self.scrollView.maximumZoomScale=.65;
    [_scrollView setDelegate:self];
    
    
    //Change name to Campus_Map.png for labels and legend in the image, map-Campus-01.png for no lables and no legend
    _viewImageMap =[[MTImageMapView alloc] initWithImage: [UIImage imageNamed:@"Campus_Map(half res).png"]];
    
    [_viewImageMap setDelegate:self];
    
    [self.scrollView addSubview:_viewImageMap];
    //sets scrollview size to be the same as imagemap size to allow scrolling
    self.scrollView.contentSize = _viewImageMap.frame.size;
    
    
    
    self.BuildingNames = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Buildings_name" ofType:@"plist"]];
    
    NSArray *arrBuildings =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Buildings_coord"ofType:@"plist"]];
    NSLog(@"arr size %lu",(unsigned long)[arrBuildings count]);
    [_viewImageMap setMapping:arrBuildings doneBlock:^(MTImageMapView *imageMapView) {NSLog(@"Areas are all mapped"); }];

}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.title=@"Map";
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *) scrollView
{
    return self.viewImageMap;
}

-(void)imageMapView:(MTImageMapView *)inImageMapView
   didSelectMapArea:(NSUInteger)inIndexSelected
{
    [[[UIAlertView alloc] initWithTitle:@"*** Building Name ***" message:[_BuildingNames objectAtIndex:inIndexSelected] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
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
