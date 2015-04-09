//
//  contactsTableViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-04-03.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "contactsTableViewController.h"
#import "studContactTableViewController.h"
#import "ServicesURL.h"                 //from Arjun
#import "ServicesWebViewController.h"   //from Arjun

@interface contactsTableViewController ()

@property (strong,nonatomic)NSArray *services;
@property (strong,nonatomic)NSMutableArray *links;

@end


@implementation contactsTableViewController
@synthesize services, links;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigation name
    self.navigationItem.title=@"Contacts";
    
    services = [[NSArray alloc]initWithObjects:@"Student Services", @"Safety & Risk Services", @"Technical Services", @"Meeting, Events, and Conferencing Services", nil];
    
    //background image
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mosaicBG"]]];
    self.tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    //clear table background colour
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    
    //holds links
    links = [[NSMutableArray alloc] init];
    
    ServicesURL *linkURL = [[ServicesURL alloc] init];
    linkURL.serviceName= @"SFU Directory";
    linkURL.serviceURL = @"https://amaint.sfu.ca/cgi-bin/WebObjects/Directory.woa/9?casredirect=yes";
    [links addObject:linkURL];
    
    linkURL = [[ServicesURL alloc]init];
    linkURL.serviceName = @"Academic Advisors";
    linkURL.serviceURL = @"https://www.sfu.ca/students/academicadvising/contact_us/sfu_advisors.html";
    [links addObject:linkURL];
    
    linkURL = [[ServicesURL alloc]init];
    linkURL.serviceName = @"Maintenance Request";
    linkURL.serviceURL = @"https://fmrequests.sfu.ca/ServiceRequest.aspx";
    [links addObject:linkURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return services.count;
    }
    else if (section == 2){
        return links.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    // round the table cells
    cell.layer.cornerRadius = 10;
    [cell.layer setMasksToBounds:YES];
    
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
    else if (indexPath.section == 2) {
        ServicesURL* url= [links objectAtIndex:indexPath.row];
        cell.textLabel.text = [url serviceName];
        
        //format cell
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.hidden = YES;
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
    else if (indexPath.section == 1 && indexPath.row != 3) {
        segueIdentifier = @"openService";
        id sender = self;
        [self performSegueWithIdentifier:segueIdentifier sender:sender];
    }
    else if (indexPath.section == 2 || (indexPath.section == 1 && indexPath.row == 3)) {
        segueIdentifier = @"openWebpage";
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
    else if([[segue identifier] isEqual:@"openWebpage"])
    { // Get the new view controller using [segue destinationViewController].
        ServicesWebViewController *webcont = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        if (path.section == 1) {
            ServicesURL *send = [[ServicesURL alloc] init];
            send.serviceName= @"SFU Meeting, Event and Conference Services";
            send.serviceURL = @"http://www.sfu.ca/mecs.html";
            webcont.hidesBottomBarWhenPushed = YES;
            [webcont setCurrentURL:send];
        }
        else{
            ServicesURL *send = links[path.row];
            webcont.hidesBottomBarWhenPushed = YES;
            [webcont setCurrentURL:send];
        }
    }
}

@end

