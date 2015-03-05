//
//  FloorImageViewController.m
//  SFUnavapp
//
//  Created by James Leong on 2015-03-04.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "FloorImageViewController.h"


@interface FloorImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *FloorImage;

@end

@implementation FloorImageViewController

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
    UIImage *image = self.currentBuilding.floorPlanImage;
    [_FloorImage setImage:image];
    self.navigationItem.title = self.currentBuilding.buildingName;
    self.navigationController.navigationBar.topItem.title = @""; // line to hide back button text
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
}*/


@end
