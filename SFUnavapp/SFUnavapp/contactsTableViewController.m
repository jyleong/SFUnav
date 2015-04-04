//
//  contactsTableViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-04-03.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "contactsTableViewController.h"
#import "studContactTableViewController.h"

@interface contactsTableViewController ()

@property (strong,nonatomic)NSArray *services;
@property (strong,nonatomic)NSArray *links;

@end


@implementation contactsTableViewController
@synthesize services, links;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigation name
    self.navigationItem.title=@"Contacts";
    
    services = [[NSArray alloc]initWithObjects:@"Student Services", @"Safety & Risk Services", nil];
    
    //background image
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFUcrest"]]];
    self.tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    //clear table background colour
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return services.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //semitransparent cell backgroung colour
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    //cell content
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Campuses";
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = services[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *segueIdentifier;
    if (indexPath.section == 0) {
        segueIdentifier = @"openCampuses";
        id sender = self;
        [self performSegueWithIdentifier:segueIdentifier sender:sender];
    }
    if (indexPath.section == 1) {
        segueIdentifier = @"openService";
        id sender = self;
        [self performSegueWithIdentifier:segueIdentifier sender:sender];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"openService"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        studContactTableViewController *destViewController = segue.destinationViewController;
        destViewController.service = [services objectAtIndex:indexPath.row];
        
        //NSLog(@"Sent: %@", [services objectAtIndex:indexPath.row]);
    }
}

@end
