//
//  MapViewController.m
//  SFUnavapp
//  Team NoMacs
//
//  Created by Arjun Rathee on 2015-03-03.
//  Edited by Arjun Rathee
//              Steven Zhou
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "MapViewController.h"
#import "BuildingObject.h"
#import "OnlineMapViewController.h"
@interface MapViewController ()
{
    bool icons;
    bool text;
}

@end

@implementation MapViewController

NSMutableArray * BuildingObjects;
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
    self.scrollView.maximumZoomScale=0.65;
    
    //[_scrollView setDelegate:self];
    
    //Change name to Campus_Map.png for labels and legend in the image, map-Campus-01.png for no lables and no legend
    _viewImageMap =[[MTImageMapView alloc] initWithImage: [UIImage imageNamed:@"all_campus_map.png"]];
    
    [_viewImageMap setDelegate:self];
    
    [self.scrollView addSubview:_viewImageMap];
    
    //sets scrollview size to be the same as imagemap size to allow scrolling
    _scrollView.contentOffset = CGPointMake(950.0, 990.0);
    self.scrollView.contentSize = _viewImageMap.frame.size;
    self.scrollView.zoomScale=0.1;
    
    //Loads building names and coordintaes into an array from the plist file specified
    //Use services like GIMP to generate coordintaes with appropriate origins
    self.BuildingNames = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Buildings_name" ofType:@"plist"]];
    
    NSArray *arrBuildings =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Buildings_coord"ofType:@"plist"]];
    NSLog(@"arr size %lu",(unsigned long)[arrBuildings count]);
    [_viewImageMap setMapping:arrBuildings doneBlock:^(MTImageMapView *imageMapView) {NSLog(@"Areas are all mapped"); }];
    
    icons = YES;
    text = YES;
    
    [self loadBuildingObjects];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title=@"Map";
}

-(void) changeImage: (NSString *) newIm {
    [self.scrollView setZoomScale:0.65];
    [self.viewImageMap setImage:[UIImage imageNamed:newIm]];
    //[self.viewImageMap setFrame:rect];
    [self.scrollView setContentSize:[self.viewImageMap frame].size];
    CGFloat minZoomScale = [self.scrollView frame].size.width / [self.viewImageMap frame].size.width;
    if (minZoomScale < [self.scrollView frame].size.height / [self.viewImageMap frame].size.height) {
        minZoomScale = [self.scrollView frame].size.height / [self.viewImageMap frame].size.height;
    }
    [self.scrollView setMinimumZoomScale:.2];
    [self.scrollView setZoomScale:[self.scrollView minimumZoomScale]];
    
    //Loads building names and coordintaes into an array from the plist file specified
    //Use services like GIMP to generate coordintaes with appropriate origins
    self.BuildingNames = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Buildings_name" ofType:@"plist"]];
    
    NSArray *arrBuildings =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Buildings_coord"ofType:@"plist"]];
    NSLog(@"arr size %lu",(unsigned long)[arrBuildings count]);
    [_viewImageMap setMapping:arrBuildings doneBlock:^(MTImageMapView *imageMapView) {NSLog(@"Areas are all mapped"); }];
}

/*- (void) loadMTI: (NSString *) imageName {
    //Change name to Campus_Map.png for labels and legend in the image, map-Campus-01.png for no lables and no legend
    _viewImageMap =[[MTImageMapView alloc] initWithImage: [UIImage imageNamed:imageName]];
    
    [_viewImageMap setDelegate:self];
    
    [self.scrollView addSubview:_viewImageMap];
    
    //sets scrollview size to be the same as imagemap size to allow scrolling
    _scrollView.contentOffset = CGPointMake(950.0, 990.0);
    self.scrollView.contentSize = _viewImageMap.frame.size;
    self.scrollView.zoomScale=0.1;
    
    //Loads building names and coordintaes into an array from the plist file specified
    //Use services like GIMP to generate coordintaes with appropriate origins
    self.BuildingNames = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Buildings_name" ofType:@"plist"]];
    
    NSArray *arrBuildings =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Buildings_coord"ofType:@"plist"]];
    NSLog(@"arr size %lu",(unsigned long)[arrBuildings count]);
    [_viewImageMap setMapping:arrBuildings doneBlock:^(MTImageMapView *imageMapView) {NSLog(@"Areas are all mapped"); }];
}*/

- (void)loadBuildingObjects
{
    BuildingObjects = [[NSMutableArray alloc]init];
    
    BuildingObject *ASBplan = [[BuildingObject alloc] initWithbuildingObj: @"Applied Science Building" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:ASBplan];
    
    BuildingObject *Blussonplan = [[BuildingObject alloc] initWithbuildingObj: @"Blusson Hall" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:Blussonplan];
    
    BuildingObject *AQplan = [[BuildingObject alloc] initWithbuildingObj: @"Academic Quadrangle" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:AQplan];
    
    BuildingObject *Libraryplan = [[BuildingObject alloc] initWithbuildingObj:@"Bennett Library" floorPlan:[UIImage imageNamed:@"Library_floorplan.png"]];
    [BuildingObjects addObject:Libraryplan];
	
	BuildingObject *Shellplan = [[BuildingObject alloc] initWithbuildingObj: @"Shell House" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:Shellplan];
	
	BuildingObject *Louisplan = [[BuildingObject alloc] initWithbuildingObj: @"Louis Riel House" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:Louisplan];
	
	BuildingObject *Hamiltonplan = [[BuildingObject alloc] initWithbuildingObj: @"Hamilton Hall" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:Hamiltonplan];
	
	BuildingObject *Paulineplan = [[BuildingObject alloc] initWithbuildingObj: @"Pauline Jewett House" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:Paulineplan];
	
	BuildingObject *Barbaraplan = [[BuildingObject alloc] initWithbuildingObj: @"Barbara Rae House" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:Barbaraplan];
	
	BuildingObject *Shadboltplan = [[BuildingObject alloc] initWithbuildingObj: @"Shadbolt House" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:Shadboltplan];
	
	BuildingObject *McTaggartplan = [[BuildingObject alloc] initWithbuildingObj: @"McTaggart-Cowan House" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [BuildingObjects addObject:McTaggartplan];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *) scrollView
{
    return self.viewImageMap;
}
// UIAlertView actions performed when building is clicked
-(void)imageMapView:(MTImageMapView *)inImageMapView
   didSelectMapArea:(NSUInteger)inIndexSelected
{
    _currentIndex=inIndexSelected;
    UIAlertView * libraryAlert = [[UIAlertView alloc] initWithTitle:[_BuildingNames objectAtIndex:inIndexSelected] message:@"View Floorplans?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    [libraryAlert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1)
        [self performSegueWithIdentifier:@"ShowPlans" sender:self];
}

- (IBAction)toggleIcon:(id)sender {
    if (icons && text) {
        [self changeImage:@"text_campus_map.png"];
        icons = NO;
        text =  YES;
    }
    else if (!icons && text) {
        [self changeImage:@"all_campus_map.png"];
        icons = YES;
        text =  YES;
    }
    else if (icons && !text) {
        [self changeImage:@"none_campus_map.png"];
        icons = NO;
        text =  NO;
    }
    else if (!icons && !text) {
        [self changeImage:@"icons_campus_map.png"];
        icons = YES;
        text =  NO;
    }
}

- (IBAction)toggleText:(id)sender {
    if (icons && text) {
        [self changeImage:@"icons_campus_map.png"];
        icons = YES;
        text =  NO;
    }
    else if (!icons && text) {
        [self changeImage:@"none_campus_map.png"];
        icons = NO;
        text =  NO;
    }
    else if (icons && !text) {
        [self changeImage:@"all_campus_map.png"];
        icons = YES;
        text =  YES;
    }
    else if (!icons && !text) {
        [self changeImage:@"text_campus_map.png"];
        icons = NO;
        text =  YES;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowPlans"]) {
            FloorImageViewController *fivc = [segue destinationViewController];
            //NSIndexPath *path =[self.tableView indexPathForSelectedRow];
            BuildingObject *send = BuildingObjects[_currentIndex]; //should map key to custom object
            fivc.hidesBottomBarWhenPushed = YES;
            [fivc setCurrentBuilding:send];
    }

}


@end
