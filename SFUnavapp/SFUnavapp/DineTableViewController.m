//
//  DineTableViewController.m
//  SFUnavapp
//
//  Created by Steven Zhou on 2015-04-01.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "DineTableViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h> // handles the appearance of UI elements
#import "ServicesURL.h"
#import "ServicesWebViewController.h" // code to add bus pass ups segue

#define kPickerIndex 2
#define kPickerCellHeight 163
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green: ((float)((rgbValue & 0xF00) >> 8))/255.0 blue: ((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DineTableViewController ()


@end

@implementation DineTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // initialize tapper in viewdidload
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"Transit";
}


#pragma mark - initialization methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES]; // so the keyboard will always resign when you click ANYWHERE
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ServicesWebViewController *webcont = [segue destinationViewController];
    
    ServicesURL *send = [[ServicesURL alloc] init];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"dinemap"]) {
        send.serviceName=@"Dining Map";
        send.serviceURL=@"http://www.dineoncampus.ca/sfu/menus/dining-map";
    }
    if ([[segue identifier] isEqualToString:@"DACmenu"]) {
        send.serviceName=@"DAC Menu";
        send.serviceURL=@"http://www.dineoncampus.ca/sfu/menus/locations/dac-buffet-lunch-menu";
    }
    if ([[segue identifier] isEqualToString:@"DiningHallmenu"]) {
        send.serviceName=@"Dining Hall Menu";
        send.serviceURL=@"http://chartwellsdining.compass-usa.com/SFU/Pages/Home.aspx";
    }
    if ([[segue identifier] isEqualToString:@"Mackenziemenu"]) {
        send.serviceName=@"Mackenzie Cafe Menu";
        send.serviceURL=@"http://chartwellsdining.compass-usa.com/SFU/Pages/Home.aspx?FoodVenue=Mackenzie%20Cafe";
    }

    webcont.hidesBottomBarWhenPushed = YES;
    [webcont setCurrentURL:send];
    
}

@end
