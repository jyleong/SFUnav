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
#import <MessageUI/MessageUI.h>

@interface AboutUsViewController () <MFMailComposeViewControllerDelegate>
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
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"About Us";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openWebsite:(id)sender {
    [self performSegueWithIdentifier:@"linktoWeb" sender:self];
}

// sending email code taken from
//http://www.codingexplorer.com/mfmailcomposeviewcontroller-send-email-in-your-apps/
// as an example
- (IBAction)openemail:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"RE: SFUnav Feedback"];
        [mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];
        [mail setToRecipients:@[@"cmpt275g13@gmail.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
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
