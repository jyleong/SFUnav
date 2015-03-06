//
//  AboutUsViewController.m
//  SFUnavapp
//
//  Created by James Leong on 2015-03-06.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ServicesURL.h"
#import "ServicesWebViewController.h" // code to add bus pass ups segue

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *emailusButton;

@end

@implementation AboutUsViewController

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
    self.navigationItem.title = @"About Us";
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openWebsite:(id)sender {
    [self performSegueWithIdentifier:@"linktoWeb" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"linktoWeb"]) {
        ServicesWebViewController *webcont = [segue destinationViewController];
        
        ServicesURL *send = [[ServicesURL alloc] init];
        send.serviceName=@"About Us";
        send.serviceURL=@"https://cmpt275g13.wordpress.com/";
        webcont.hidesBottomBarWhenPushed = YES;
        [webcont setCurrentURL:send];
    }
}


@end
