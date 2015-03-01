//
//  CampusContactsViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-01.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "CampusContactsViewController.h"


@interface CampusContactsViewController ()

@end

@implementation CampusContactsViewController
@synthesize burnabyView, surreyView, vancouverView;

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

- (IBAction)segmentedValueChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex)
    {
        case 0: //selected burnaby
            self.burnabyView.hidden = NO;
            self.surreyView.hidden = YES;
            self.vancouverView.hidden = YES;
            break;
            
        case 1: //selected surrey
            self.burnabyView.hidden = YES;
            self.surreyView.hidden = NO;
            self.vancouverView.hidden = YES;
            break;
            
        case 2: // selected vancouver
            self.burnabyView.hidden = YES;
            self.surreyView.hidden = YES;
            self.vancouverView.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (IBAction)makeCall:(id)sender {
    
    NSString *phoneNumber = [sender currentTitle];
    NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    NSLog(@"Called %@",phoneNumber);
}


@end
