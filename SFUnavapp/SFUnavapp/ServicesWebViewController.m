//
//  ServicesWebViewController.m
//  SFUnavapp
//  Team NoMacs
//  Created by Arjun Rathee on 2015-02-14.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "ServicesWebViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green: ((float)((rgbValue & 0xF00) >> 8))/255.0 blue: ((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ServicesWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *currentlink;

@end

@implementation ServicesWebViewController

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
    self.title=_currentURL.serviceName;
    
    //Loads the url provided in custom object and assigns the title to the navigation bar
    NSURL *url= [NSURL URLWithString:_currentURL.serviceURL];
    NSURLRequest *requestObj= [NSURLRequest requestWithURL:url];
    [_currentlink loadRequest:requestObj];
    self.navigationController.navigationBar.topItem.title = @""; // line to hide back button text
    [[UIToolbar appearance] setBarTintColor:UIColorFromRGB(0xB5111B)];
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
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
