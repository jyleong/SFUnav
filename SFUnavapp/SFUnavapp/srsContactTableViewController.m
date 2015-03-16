//
//  srsContactTableViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-14.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "srsContactTableViewController.h"
#import "ContactsTableViewCell.h"

@interface srsContactTableViewController ()

@property (strong,nonatomic)NSArray *securityArray;
@property (strong,nonatomic)NSArray *accessArray;
@property (strong,nonatomic)NSDictionary *contact;

@end

@implementation srsContactTableViewController
@synthesize securityArray, accessArray, contact;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Security" ofType:@"plist"];
    securityArray = [NSArray arrayWithContentsOfFile:path];
    
    path = [[NSBundle mainBundle]pathForResource:@"access" ofType:@"plist"];
    accessArray = [NSArray arrayWithContentsOfFile:path];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {   return securityArray.count;    }
    if (section == 1)
    {   return accessArray.count;    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactsTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsTableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0)
    {   contact = securityArray[indexPath.row];    }
    if (indexPath.section == 1)
    {   contact = accessArray[indexPath.row];    }

    
    /* unload array */
    NSString *contactDetail = contact[@"contactDetail"];
    NSString *contactInfo = contact[@"contactInfo"];
    NSString *contactType = contact[@"contactType"];
    
    cell.contactInfo.text = contactInfo;
    cell.contactDetails.text = contactDetail;
    cell.contactType.text = contactType;
    
    /* sizing */
    cell.contactInfo.numberOfLines = 1;
    [cell.contactInfo sizeToFit];
    
    if ([cell.contactType.text isEqualToString:@"In Person"]) {
        cell.contactDetails.hidden = YES;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0)
    {   return @"Campus Security"; }
    if (section == 1)
    {   return @"Access Control (keys & cards)";   }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactsTableViewCell *cell = (ContactsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString *type = cell.contactType.text;
    NSString *info = cell.contactInfo.text;
    
    if ([type  isEqualToString: @"Phone"]) {
        [self makeCall:info];
    }
    else if ([type isEqualToString:@"Email"]) {
        [self showEmail:info];
    }
    else if ([type isEqualToString:@"Text"]) {
        [self showSMS:info];
    }
    else if ([type isEqualToString:@"In Person"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Hours of Operation"
                              message:cell.contactDetails.text
                              delegate:nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil, nil];
        
        // Display Alert Message
        [alert show];
    }
    //NSLog(cell.contactInfo.text);
    
}

/*  - - - - - - contact functions - - - - - - */

// Phone
- (IBAction)makeCall:(NSString *)phoneNumber{
    
    NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    NSLog(@"Called %@",phoneNumber);
}

// Email
- (IBAction)showEmail:(NSString *)recipient {
    //Subject of Email
    NSString *emailTitle = nil;
    //Message of Email
    NSString *messageBody = nil;
    //Recipient of Email
    NSArray *toRecipients = [NSArray arrayWithObjects:recipient, nil];
    //Creates builtin MFMailComposeViewController (mail interface)
    MFMailComposeViewController *mc =[[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipients];
    
    //display mail interface on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

//called when mail interface closed
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Email cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Email saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Email sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Email sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


// Text Message
- (void)showSMS:(NSString*)recipient {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[recipient];
    NSString *message = [NSString stringWithFormat:@"SFU Burnaby"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

// called when message interface closed
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
