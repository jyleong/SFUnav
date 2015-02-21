//
//  ServicesWebViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-02-14.
//  Copyright (c) 2015 Arjun Rathee. All rights reserved.
//

#import "ServicesWebViewController.h"

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
    
    NSURL *url= [NSURL URLWithString:_currentURL.serviceURL];
    NSURLRequest *requestObj= [NSURLRequest requestWithURL:url];
    [_currentlink loadRequest:requestObj];
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
}
*/

@end
