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
@property (strong, nonatomic) NSArray* arrBuildings;

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

- (void)viewWillAppear:(BOOL)animated
{

    // Do any additional setup after loading the view.
    UIColor * bgrnd = [UIColor colorWithRed:182/255.0f green:189/255.0f blue:147/255.0f alpha:1.0f];
    _scrollView.backgroundColor=bgrnd;
    
    self.scrollView.minimumZoomScale=0.2;
    self.scrollView.maximumZoomScale=0.65;
    
    //[_scrollView setDelegate:self];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString* imgPath = [bundle pathForResource:@"all_campus_map" ofType:@"png"];
    UIImage*img= [[UIImage alloc] initWithContentsOfFile:imgPath];
    if (img==nil)
        NSLog(@"img was nil");
    //Change name to Campus_Map.png for labels and legend in the image, map-Campus-01.png for no lables and no legend
    _viewImageMap =[[MTImageMapView alloc] initWithImage: img];
    
    [_viewImageMap setDelegate:self];
    
    [self.scrollView addSubview:_viewImageMap];
    
    //sets scrollview size to be the same as imagemap size to allow scrolling
    self.scrollView.contentSize = _viewImageMap.frame.size;
    self.scrollView.zoomScale=0.27;
    
    //Loads building names and coordintaes into an array from the plist file specified
    //Use services like GIMP to generate coordintaes with appropriate origins
    self.BuildingNames = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Buildings_name" ofType:@"plist"]];
    
    _arrBuildings =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Buildings_coord"ofType:@"plist"]];
    NSLog(@"arr size %lu",(unsigned long)[_arrBuildings count]);
    [_viewImageMap setMapping:_arrBuildings doneBlock:^(MTImageMapView *imageMapView) {NSLog(@"Areas are all mapped"); }];
    
    icons = YES;
    text = YES;
    
    [self loadBuildingObjects];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentOffset = CGPointMake(491, -23);
    self.navigationItem.title=@"Map";
}

-(void) changeImage: (NSString *) newIm {
    [self.scrollView setZoomScale:0.65];
    //Create file bundle with content of image file
    NSBundle *bundle = [NSBundle mainBundle];
    NSString* imgPath = [bundle pathForResource:newIm ofType:@"png"];
    //Create UIImage Object with file data and change _viewImageMap's image
    UIImage*img= [[UIImage alloc] initWithContentsOfFile:imgPath];
    [self.viewImageMap setImage:img];

    [self.scrollView setContentSize:[self.viewImageMap frame].size];
    CGFloat minZoomScale = [self.scrollView frame].size.width / [self.viewImageMap frame].size.width;
    if (minZoomScale < [self.scrollView frame].size.height / [self.viewImageMap frame].size.height) {
        minZoomScale = [self.scrollView frame].size.height / [self.viewImageMap frame].size.height;
    }
    [self.scrollView setMinimumZoomScale:.2];
    [self.scrollView setZoomScale:[self.scrollView minimumZoomScale]];
    
}


//Function to load names of current building objects. Floorplans images are only loaded during segue preparation
//Note your building name assigned here must match your image file name
//Order should be the same as that of the 'Buildings_name.plist'
- (void)loadBuildingObjects
{
    BuildingObjects = [[NSMutableArray alloc]init];
    
    BuildingObject *ASBplan = [[BuildingObject alloc] initWithbuildingObj: @"Applied Science Building" floorPlan:nil];
    [BuildingObjects addObject:ASBplan];
    
    BuildingObject *Blussonplan = [[BuildingObject alloc] initWithbuildingObj: @"Blusson Hall" floorPlan:nil];
    [BuildingObjects addObject:Blussonplan];
    
    BuildingObject *AQplan = [[BuildingObject alloc] initWithbuildingObj: @"Academic Quadrangle" floorPlan:nil];
    [BuildingObjects addObject:AQplan];
    
    BuildingObject *Libraryplan = [[BuildingObject alloc] initWithbuildingObj:@"Bennett Library" floorPlan:nil];
    [BuildingObjects addObject:Libraryplan];
	
	BuildingObject *Shellplan = [[BuildingObject alloc] initWithbuildingObj: @"Shell House" floorPlan:nil];
    [BuildingObjects addObject:Shellplan];
	
	BuildingObject *Louisplan = [[BuildingObject alloc] initWithbuildingObj: @"Louis Riel House" floorPlan:nil];
    [BuildingObjects addObject:Louisplan];
	
	BuildingObject *Hamiltonplan = [[BuildingObject alloc] initWithbuildingObj: @"Hamilton Hall" floorPlan:nil];
    [BuildingObjects addObject:Hamiltonplan];
	
	BuildingObject *Paulineplan = [[BuildingObject alloc] initWithbuildingObj: @"Pauline Jewett House" floorPlan:nil];
    [BuildingObjects addObject:Paulineplan];
	
	BuildingObject *Barbaraplan = [[BuildingObject alloc] initWithbuildingObj: @"Barbara Rae House" floorPlan:nil];
    [BuildingObjects addObject:Barbaraplan];
	
	BuildingObject *Shadboltplan = [[BuildingObject alloc] initWithbuildingObj: @"Shadbolt House" floorPlan:nil];
    [BuildingObjects addObject:Shadboltplan];
	
	BuildingObject *McTaggartplan = [[BuildingObject alloc] initWithbuildingObj: @"McTaggart-Cowan House" floorPlan:nil];
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
//UIAlert segue call for showing plans
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1)
        [self performSegueWithIdentifier:@"ShowPlans" sender:self];
}

//IBAction to toggle icon display on map
- (IBAction)toggleIcon:(id)sender {
    if (icons && text) {
        [self changeImage:@"text_campus_map"];
        icons = NO;
        text =  YES;
    }
    else if (!icons && text) {
        [self changeImage:@"all_campus_map"];
        icons = YES;
        text =  YES;
    }
    else if (icons && !text) {
        [self changeImage:@"none_campus_map"];
        icons = NO;
        text =  NO;
    }
    else if (!icons && !text) {
        [self changeImage:@"icons_campus_map"];
        icons = YES;
        text =  NO;
    }
}

//IBAction to toggle text display on map
- (IBAction)toggleText:(id)sender {
    
    if (icons && text) {
        [self changeImage:@"icons_campus_map"];
        icons = YES;
        text =  NO;
    }
    else if (!icons && text) {
        [self changeImage:@"none_campus_map"];
        icons = NO;
        text =  NO;
    }
    else if (icons && !text) {
        [self changeImage:@"all_campus_map"];
        icons = YES;
        text =  YES;
    }
    else if (!icons && !text) {
        [self changeImage:@"text_campus_map"];
        icons = NO;
        text =  YES;
    }
}

//Call deallocator and prepare to leave viewcontroller
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self deallocer];
}
//Custom deallocater called by ARC. Forcing image deallocations and setting arrays to nil
-(void) deallocer
{
    _viewImageMap.image=nil;
    _viewImageMap=nil;
    _BuildingNames=nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowPlans"]) {
        FloorImageViewController *fivc = [segue destinationViewController];
        NSBundle *bundle = [NSBundle mainBundle];
        BuildingObject *send = BuildingObjects[_currentIndex]; //should map key to custom object
        //Load image file with path name specified, if condition to check for placeholder requirements
        NSString* imgPath = [bundle pathForResource:[send buildingName] ofType:@"png"];
        if (imgPath==nil)
        {
            imgPath = [bundle pathForResource:@"UnderConstruction_floorplan" ofType:@"png"];
        }
        //create UIImage object with specified file contents and assign it to current object
        UIImage*floorPlan= [[UIImage alloc] initWithContentsOfFile:imgPath];
        send.floorPlanImage=floorPlan;
        fivc.hidesBottomBarWhenPushed = YES;
        [fivc setCurrentBuilding:send];
    }

}


@end
