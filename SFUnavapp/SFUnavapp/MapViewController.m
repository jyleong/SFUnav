//
//  MapViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-03.
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
    
    
    //Change name to Campus_Map.png for labels and legend in the image, map-Campus-01.png for no lables and no legend
    MTImageMapView *viewImageMap =[[MTImageMapView alloc] initWithImage: [UIImage imageNamed:@"map-Campus-01.png"]];
    
    [viewImageMap setDelegate:self];
    
    [self.scrollView addSubview:viewImageMap];
    //sets scrollview size to be the same as imagemap size to allow scrolling
    self.scrollView.contentSize = viewImageMap.frame.size;
    
    
    
    self.BuildingNames = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Buildings_name" ofType:@"plist"]];
    
    NSArray *arrBuildings =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Buildings_coord"ofType:@"plist"]];
    NSLog(@"arr size %lu",(unsigned long)[arrBuildings count]);
    [viewImageMap setMapping:arrBuildings doneBlock:^(MTImageMapView *imageMapView) {NSLog(@"Areas are all mapped"); }];
    
    
    

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
