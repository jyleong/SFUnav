//
//  CampusContactsViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-01.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "CampusContactsViewController.h"


@interface CampusContactsViewController ()
{
    NSArray *campusContacts;
    NSArray *burnabyNumbers;
    NSArray *surreyNumbers;
    NSArray *vancouverNumbers;
}
@property (strong, nonatomic) IBOutlet UITableView *burnabyTable;
@property (strong, nonatomic) IBOutlet UITableView *surreyTable;
@property (strong, nonatomic) IBOutlet UITableView *vancouverTable;

@end

@implementation CampusContactsViewController
@synthesize burnabyView, surreyView, vancouverView;
@synthesize burnabyTable, surreyTable, vancouverTable;

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
    campusContacts = [[NSArray alloc] initWithObjects:@"Switchboard", @"Student Services", @"Security Services", nil];
    burnabyNumbers = [[NSArray alloc] initWithObjects:@"778-782-3111", @"778-782-6930", @"778-782-3100", nil];
    surreyNumbers = [[NSArray alloc] initWithObjects:@"778-782-7400", @"778-782-6930", @"778-782-7070", nil];
    vancouverNumbers = [[NSArray alloc] initWithObjects:@"778-782-5000", @"778-782-6930", @"778-782-5029", nil];
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
            self.burnabyTable.hidden = NO;
            self.surreyTable.hidden = YES;
            self.vancouverTable.hidden = YES;
            
            break;
            
        case 1: //selected surrey
            self.burnabyView.hidden = NO;
            self.surreyView.hidden = NO;
            self.vancouverView.hidden = YES;
            self.burnabyTable.hidden = YES;
            self.surreyTable.hidden = NO;
            self.vancouverTable.hidden = YES;
            break;
            
        case 2: // selected vancouver
            self.burnabyView.hidden = YES;
            self.surreyView.hidden = YES;
            self.vancouverView.hidden = NO;
            self.burnabyTable.hidden = YES;
            self.surreyTable.hidden = YES;
            self.vancouverTable.hidden = NO;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return campusContacts.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"campusContactCell" forIndexPath:indexPath];
 
 // Configure the cell...
     cell.textLabel.text=campusContacts[indexPath.row];
     if(tableView == burnabyTable)
     {  cell.detailTextLabel.text=burnabyNumbers[indexPath.row];    }
     if(tableView == surreyTable)
     {  cell.detailTextLabel.text=surreyNumbers[indexPath.row]; }
     if(tableView == vancouverTable)
     {  cell.detailTextLabel.text=vancouverNumbers[indexPath.row]; }
     cell.backgroundColor = [UIColor clearColor];
 
 return cell;
 }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"[name]" message:@"[number]" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
    
    // Display Alert Message
    [messageAlert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1)
       //make a phone call
        NSLog(@"pressed call");
        ;
        
}
@end
