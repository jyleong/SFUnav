//
//  studContactTableViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-14.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "studContactTableViewController.h"
#import "ContactsTableViewCell.h"
#import "ServicesWebViewController.h"

@interface studContactTableViewController ()

@property (strong,nonatomic)NSDictionary *contact;

@property (strong,nonatomic)NSArray *serviceArray;


@end

@implementation studContactTableViewController
@synthesize serviceArray, contact, service;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = service;
    self.navigationController.navigationBar.topItem.title = @"";
    
    NSURL *url;
    if ([service isEqualToString: @"Student Services"]) {
        url = [[NSBundle mainBundle] URLForResource:@"StudentServices" withExtension:@"plist"];
    }
    else if ([service isEqualToString: @"Safety & Risk Services"]){
        url = [[NSBundle mainBundle] URLForResource:@"Safety&Risk" withExtension:@"plist"];
    }
    else if ([service isEqualToString: @"Technical Services"]){
        url = [[NSBundle mainBundle] URLForResource:@"Technical" withExtension:@"plist"];
    }
    
    serviceArray = [NSArray arrayWithContentsOfURL:url];
    
    
    //NSLog(@"%@",serviceArray);
    
    
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
    return serviceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[serviceArray objectAtIndex:section]count];
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactsTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsTableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    contact = serviceArray[indexPath.section][indexPath.row];
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([cell.contactType.text isEqualToString:@"Online"]) {
        cell.contactDetails.hidden = YES;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *studServices = [[NSArray alloc] initWithObjects:@"Registrar & Information Services", @"Career Services", @"Financial Advising", @"Health & Counselling Services (HCS)", nil];
    NSArray *srServices = [[NSArray alloc] initWithObjects:@"Campus Security", @"Access Control (keys & cards)", nil];
    NSArray *techServices = [[NSArray alloc] initWithObjects:@"Audio Visual Services", @"Videoconferencing", @"Computer Labs", nil];

    if ([service isEqualToString: @"Student Services"]) {
        return studServices[section];
    }
    else if ([service isEqualToString:@"Safety & Risk Services"]){
        return srServices[section];
    }
    else if ([service isEqualToString:@"Technical Services"]){
        return techServices[section];
    }

    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactsTableViewCell *cell = (ContactsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString *type = cell.contactType.text;
    NSString *info = cell.contactInfo.text;
    
    if ([type  isEqualToString: @"Phone"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:cell.contactInfo.text
                              message:@""
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Call", nil];
        
        // Display Alert Message
        [alert show];
    }
    else if ([type isEqualToString:@"Email"]) {
        [self showEmail:info];
    }
    else if ([type isEqualToString:@"Text"]) {
        [self showSMS:info];
    }
    else if ([type isEqualToString:@"Online"]) {
        NSString *segueIdentifier = @"openWebpage";
        id sender = self;
        [self performSegueWithIdentifier:segueIdentifier sender:sender];
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{
        [self makeCall:alertView.title];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    ContactsTableViewCell *cell = (ContactsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    if ([cell.contactType.text isEqualToString:@"In Person"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Hours of Operation"
                              message:cell.contactDetails.text
                              delegate:nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil, nil];
        
        // Display Alert Message
        [alert show];
    }
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
 - (BOOL)shouldPerformSegueWithIdentifier:(NSString *)text {
 if ([text isEqualToString: @"Weblink"] || [text isEqualToString:@"Online"]) {
 return YES;
 }
 
 return NO;
 }
 */
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if([[segue identifier] isEqual:@"openWebpage"])
     { // Get the new view controller using [segue destinationViewController].
         ServicesWebViewController *webcont = [segue destinationViewController];

         //get URL details
         NSIndexPath *path = [self.tableView indexPathForSelectedRow];
         NSDictionary *linkInfo = serviceArray[path.section][path.row];
        
         //store it as a SerivesURL
         ServicesURL *linkURL = [[ServicesURL alloc] init];
         linkURL.serviceName = [linkInfo valueForKey:@"contactInfo"];
         linkURL.serviceURL = [linkInfo valueForKey:@"contactDetail"];
         NSLog(@"%@",linkURL);
         
         //segue
         webcont.hidesBottomBarWhenPushed = YES;
         [webcont setCurrentURL:linkURL];
     }
 
 }
 

@end
