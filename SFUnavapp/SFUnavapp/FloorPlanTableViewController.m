//
//  FloorPlanTableViewController.m
//  SFUnavapp
//  Team NoMacs
//
//  Created by James Leong on 2015-03-03.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "FloorPlanTableViewController.h"
#import "FloorImageViewController.h"

@interface FloorPlanTableViewController ()

@end

@implementation FloorPlanTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"FloorPlan Search";
    
    _BuildingObjects = [[NSMutableArray alloc]init];
    BuildingObject *Blussonplan = [[BuildingObject alloc] initWithbuildingObj: @"Blusson Hall" coordinate:@"4139,681,4139,857,3928,857,3926,681" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [_BuildingObjects addObject:Blussonplan];
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
    return _BuildingObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buildName" forIndexPath:indexPath];
    
    // Configure the cell...
    BuildingObject * current= [_BuildingObjects objectAtIndex:indexPath.row];
    cell.textLabel.text= current.buildingName;
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    FloorImageViewController *fivc = [segue destinationViewController];
    NSIndexPath *path =[self.tableView indexPathForSelectedRow];
    BuildingObject *send = _BuildingObjects[path.row];
    fivc.hidesBottomBarWhenPushed = YES;
    [fivc setCurrentBuilding:send];
}


@end
