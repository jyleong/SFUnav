//
//  ServicesTableViewController.m
//  SFUnavapp
//
//  Created by James Leong on 2015-02-12.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

#import "ServicesTableViewController.h"

@interface ServicesTableViewController ()
{
    NSMutableArray *links;
}
@end

@implementation ServicesTableViewController

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
    // this is how to change titles in navbars - James
    self.navigationItem.title = @"Services";
    
    links = [[NSMutableArray alloc] init];
    ServicesURL *url = [[ServicesURL alloc] init];
    url.serviceName=@"SFU Search";
    url.serviceURL = @"http://www.sfu.ca/search.html";
    [links addObject:url];
    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"SFU Library Search";
    url.serviceURL = @"http://search.lib.sfu.ca";
    [links addObject:url];
    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"Canvas";
    url.serviceURL = @"http://canvas.sfu.ca";
    [links addObject:url];
    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"CourSys";
    url.serviceURL = @"http://courses.cs.sfu.ca";
    [links addObject:url];

    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"Connect";
    url.serviceURL = @"http://connect.sfu.ca";
    [links addObject:url];
    
    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"SFU Library Search";
    url.serviceURL = @"http://search.lib.sfu.ca";
    [links addObject:url];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return links.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    ServicesURL* current= [links objectAtIndex:indexPath.row];
    cell.textLabel.text= [current serviceName];
    return cell;
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
