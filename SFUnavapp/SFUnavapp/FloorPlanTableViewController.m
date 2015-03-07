//
//  FloorPlanTableViewController.m
//  SFUnavapp
//  Team NoMacs
//
//  Created by James Leong on 2015-03-03.
//  Edited by Arjun Rathee
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "FloorPlanTableViewController.h"
#import "FloorImageViewController.h"

@interface FloorPlanTableViewController () {
}

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
    
    _BuildingObjects = [[NSMutableArray alloc]init];
    
    BuildingObject *Blussonplan = [[BuildingObject alloc] initWithbuildingObj: @"Blusson Hall" coordinate:@"4139,681,4139,857,3928,857,3926,681" floorPlan:[UIImage imageNamed:@"Blusson_floorplan.png"]];
    [_BuildingObjects addObject:Blussonplan];
    
    BuildingObject *Libraryplan = [[BuildingObject alloc] initWithbuildingObj:@"Library" coordinate:@"2764,898,3042,889,3042,977,2764,977" floorPlan:[UIImage imageNamed:@"Library_floorplan.png"]];
    [_BuildingObjects addObject:Libraryplan];
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[_BuildingObjects count]];
    self.navigationController.navigationBar.topItem.title = @""; // line to hide back button text
}

-(void)viewDidAppear:(BOOL)animated {
    self.navigationItem.title=@"Building Search";
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResult count];
    }
    else {
        return _BuildingObjects.count;
    }
}

// loads the tablecells, case of regulat table and filtered table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"buildName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BuildingObject *current;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        current = [_searchResult objectAtIndex:indexPath.row];
        cell.textLabel.text = current.buildingName;
    }
    else
    {
        current= [_BuildingObjects objectAtIndex:indexPath.row];
        cell.textLabel.text= current.buildingName;
    }
    
    // Configure the cell...
    
    return cell;
}

//function that filters and adds to searchResult
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.buildingName contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [_BuildingObjects filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
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

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to candy detail
    [self performSegueWithIdentifier:@"FloorImageDetail" sender:tableView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"FloorImageDetail"]) {
        FloorImageViewController *fivc = [segue destinationViewController];
        
        if (sender == self.searchDisplayController.searchResultsTableView) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            BuildingObject *send = [_searchResult objectAtIndex:[indexPath row]];
            fivc.hidesBottomBarWhenPushed = YES;
            [fivc setCurrentBuilding:send];
        }
        else {
            NSIndexPath *path =[self.tableView indexPathForSelectedRow];
            BuildingObject *send = _BuildingObjects[path.row]; //should map key to custom object
            fivc.hidesBottomBarWhenPushed = YES;
            [fivc setCurrentBuilding:send];
        }
    }
}


@end
