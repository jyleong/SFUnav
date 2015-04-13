//
//  CourseCartTableViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-04-03.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "CourseCartTableViewController.h"

@interface CourseCartTableViewController ()
{
    NSInteger indexNumber;
    NSInteger sectionNumber;
}
@end

@implementation CourseCartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    // Return the number of rows in the section.
    if (section==1)
        return [currentCourses count];
    //section=0
    return [registrationCourses count];
}

//Create section cells with course names and sections
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius=10;
    
    // Configure the cell...
    if (indexPath.section==1)
    {
        CourseCartObject *current=[currentCourses objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@", current.courseDept, current.courseNumber];
        cell.detailTextLabel.text=current.courseSection;
    }
    else
    {
        CourseCartObject *current=[registrationCourses objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@", current.courseDept, current.courseNumber];
        cell.detailTextLabel.text=current.courseSection;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==1)
        return @"Current Term";
    return @"Next/Registration Term";//section=0
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
//Allow editing for delete and reorder
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath.section==1)
            [currentCourses removeObjectAtIndex:indexPath.row];
        else
            [registrationCourses removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



// Override to support rearranging the table view.
//Modifies the arrays to reflect current order
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    CourseCartObject *courseToMove;
    if (fromIndexPath.section==1)
    {
        courseToMove= [currentCourses objectAtIndex:fromIndexPath.row];
        [currentCourses removeObjectAtIndex:fromIndexPath.row];
        [currentCourses insertObject:courseToMove atIndex:toIndexPath.row];
    }
    else
    {
        courseToMove= [registrationCourses objectAtIndex:fromIndexPath.row];
        [registrationCourses removeObjectAtIndex:fromIndexPath.row];
        [registrationCourses insertObject:courseToMove atIndex:toIndexPath.row];

    }
}

//Reorder cells within the sections
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexNumber=indexPath.row;
    sectionNumber=indexPath.section;
    [self performSegueWithIdentifier:@"displayDetails" sender:self];

}
#pragma mark - NSUserDefaults Handlers
//Save current courses to userdeafults under the keys
- (void)saveCustomObject:(NSMutableArray *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}


//Calls to user defaults saver
-(void) viewWillDisappear:(BOOL)animated
{
    [self saveCustomObject:currentCourses key:@"currentCourses"];
    [self saveCustomObject:registrationCourses key:@"registrationCourses"];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier]isEqualToString:@"displayDetails"])
    {
        CourseDetailViewController *fivc=[segue destinationViewController];
        CourseCartObject *temp;
        if (sectionNumber==1)
            temp=[currentCourses objectAtIndex:indexNumber];
        else
            temp=[registrationCourses objectAtIndex:indexNumber];
        fivc.courseTerm=temp.courseTerm;
        fivc.courseDept=temp.courseDept;
        fivc.courseNumber=temp.courseNumber;
        fivc.courseSection=temp.courseSection;
        fivc.hidesBottomBarWhenPushed=YES;
    }
}


@end
