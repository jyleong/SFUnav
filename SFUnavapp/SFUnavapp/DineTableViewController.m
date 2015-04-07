//
//  DineTableViewController.m
//  SFUnavapp
//  Team NoMacs
//
//  Created by Steven Zhou on 2015-04-01.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "DineTableViewController.h"
#import "ServicesURL.h"
#import "ServicesWebViewController.h" // code to add menu segue

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - initialization methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        send.serviceURL=@"http://cdn.agilitycms.com/dine-on-campus/SimonFraser/Images/CampusDiningMapwSbux-Large.jpg";
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
