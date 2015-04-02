//
//  CoursesTableViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-04-01.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "CoursesTableViewController.h"
#import "ServicesTableViewController.h"
#import "Course.h"
#import "TFHpple.h"
#import "Reachability.h"

@interface CoursesTableViewController ()
{
    NSMutableArray *courseCollection;
}
@end

@implementation CoursesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if (autoLogin!=YES)
        [self notlogin];
    [self genCourses];
    
}

#pragma mark - Course Parsing
-(void) notlogin{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Not Logged In" message:@"Login is required to see your current courses. You can browse all courses without login" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:@"Browse", @"LogIn",nil];
    [Alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1)
        [self performSegueWithIdentifier:@"BrowseCourse" sender:self];
}

-(void) genCourses{
    if ([self checkInternet])
    {
        courseCollection=[[NSMutableArray alloc]init];
        [self parseCanvas];
        [self parseCoursys];
    }
    else{
        UIAlertView *NoIntAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Internet Connection is required. Reconnect and pull down to Refresh" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [NoIntAlert show];
    }
}

-(void) parseCanvas{
    NSURL *url= [NSURL URLWithString:@"https://canvas.sfu.ca/courses"];
    NSURLRequest *requestObj= [NSURLRequest requestWithURL:url];
    [_web loadRequest:requestObj];
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://canvas.sfu.ca/courses"]];
    TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:result];
    Course *temp=[[Course alloc]init];
    NSArray *data = [xpath searchWithXPathQuery:@"//*[@id='my_courses_table']/tr/td/a/span/@title"];
    
    for (int i=0; i<[data count]; i++)
    {
        TFHppleElement *item = data[i];
        NSLog(@"Content %@",item.content);
        temp.name=[temp.name lowercaseString];
        temp.name=[item.content substringFromIndex:[item.content length]-13];
        temp.name=[temp.name stringByReplacingOccurrencesOfString:@" " withString:@""];
        temp.name=@"cmpt376wd100";
        temp.section=[temp.name substringFromIndex:[temp.name length]-4];
        temp.name=[temp.name stringByReplacingOccurrencesOfString:temp.section withString:@""];
        if ([temp.name characterAtIndex:[temp.name length]-1]=='w')
        {
            
        }
        NSLog(@"Temp name:%@, section:%@",temp.name,temp.section);
    }

}
-(void) parseCoursys{
    
}
-(BOOL) checkInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return NO;
    }
    NSLog(@"There IS internet connection");
    return  YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqual:@"BrowseCourse"])
    {
        
    }
    else
    {
        
    }
}


@end
