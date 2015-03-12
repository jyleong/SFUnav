//
//  ContactsTableViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-12.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactsTableViewCell.h"
@interface ContactsTableViewController ()

@property (strong,nonatomic)NSArray *registrarArray;
@property (strong,nonatomic)NSArray *financialArray;
@property (strong,nonatomic)NSDictionary *contact;

@end

@implementation ContactsTableViewController
@synthesize registrarArray, financialArray, contact;

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
    
    NSString *regPath = [[NSBundle mainBundle]pathForResource:@"Registrar" ofType:@"plist"];
    registrarArray = [NSArray arrayWithContentsOfFile:regPath];
    
    NSString *finPath = [[NSBundle mainBundle]pathForResource:@"Financial" ofType:@"plist"];
    financialArray = [NSArray arrayWithContentsOfFile:finPath];
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
    if (section == 0) {
        return registrarArray.count;
    }
    if (section == 1) {
        return financialArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactsTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsTableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        contact = registrarArray[indexPath.row];
        
        /* unload array */
        NSString *contactDetail = contact[@"contactDetail"];
        NSString *contactInfo = contact[@"contactInfo"];
        NSString *contactIcon = contact[@"contactIcon"];
        
        UIImage *icon = [UIImage imageNamed:contactIcon];
        
        cell.contactInfo.text = contactInfo;
        cell.contactDetails.text = contactDetail;
        cell.contactIcon.image = icon;
    }
    if (indexPath.section == 1) {
        contact = financialArray[indexPath.row];
        
        /* unload array */
        NSString *contactDetail = contact[@"contactDetail"];
        NSString *contactInfo = contact[@"contactInfo"];
        NSString *contactIcon = contact[@"contactIcon"];
        
        UIImage *icon = [UIImage imageNamed:contactIcon];
        
        cell.contactInfo.text = contactInfo;
        cell.contactDetails.text = contactDetail;
        cell.contactIcon.image = icon;
    }
   
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Registrar & Information Services";
    }
    if (section == 1) {
        return @"Financial Advising";
    }
    return 0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
