//
//  LibraryTableViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-26.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "LibraryTableViewController.h"
#import "LibraryHoursTableViewCell.h"
#import "ServicesURL.h"                 //from Arjun
#import "ServicesWebViewController.h"   //from Arjun
#import "Reachability.h"                //from Arjun

#define FBOX(x) [NSNumber numberWithFloat:x]
#define IBOX(x) [NSNumber numberWithInteger:x]


@interface LibraryTableViewController ()
{
    NSMutableArray *hourResults;
    NSMutableDictionary *equipResults;
    NSMutableArray *links;
    NSDictionary *linkInfo;
    BOOL hasInternet;
}
@end


@implementation LibraryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //navigation name
    self.navigationItem.title=@"Library";
    
    //check for internet connection - from Arjun
    hasInternet =[self checkInternet];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0 green:83/255.0 blue:155/255.0 alpha:1.0];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    
    
    //get library equipment summary api information
    if (hasInternet) {
        //get library hours api information
        NSString *str = @"http://api.lib.sfu.ca/hours/summary?date=";
        NSURL *url = [NSURL URLWithString:str];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        hourResults = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:NSJSONReadingMutableContainers
                       error:&error];
        
        //NSLog(@"Your JSON Object: %@ Or Error is: %@", hourResults, error);
        str = @"http://api.lib.sfu.ca/equipment/computers/free_summary";
        url = [NSURL URLWithString:str];
        data = [NSData dataWithContentsOfURL:url];
        error = nil;
        equipResults = [NSJSONSerialization
                        JSONObjectWithData:data
                        options:NSJSONReadingMutableContainers
                        error:&error];
        
        equipResults = [equipResults objectForKey:@"locations"];
        
        //NSLog(@"Your JSON Object: %@ Or Error is: %@", equipResults, error);
    }
   
    //holds links
    links = [[NSMutableArray alloc] init];
    
    ServicesURL *linkURL = [[ServicesURL alloc] init];
    linkURL.serviceName= @"SFU Library Search";
    linkURL.serviceURL = @"http://fastsearch.lib.sfu.ca";
    [links addObject:linkURL];
    
    linkURL = [[ServicesURL alloc]init];
    linkURL.serviceName = @"My SFU Library Account";
    linkURL.serviceURL = @"https://troy.lib.sfu.ca/patroninfo";
    [links addObject:linkURL];
    
    linkURL = [[ServicesURL alloc]init];
    linkURL.serviceName = @"Book a Group Study Room";
    linkURL.serviceURL = @"http://roombookings.lib.sfu.ca/studyrooms/day.php?area=1";
    [links addObject:linkURL];
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

- (void)reload
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
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
    // Return the number of rows in the section.
    if (section == 2){
        return links.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LibraryHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"libraryCell" forIndexPath:indexPath];
    
    if (hasInternet) {
        // Configure the cell...
        if (indexPath.section == 0) {
            //get info
            NSString *libraryName = [hourResults[indexPath.row] objectForKey:@"location"];
            BOOL inRange = [[hourResults[indexPath.row] objectForKey:@"in_range"]intValue];
            NSString *openTime = [hourResults[indexPath.row] objectForKey:@"open_time"];
            NSString *closeTime = [hourResults[indexPath.row] objectForKey:@"close_time"];
            BOOL openAllDay = [[hourResults[indexPath.row]objectForKey:@"open_all_day"]intValue];
            BOOL closeAllDay = [[hourResults[indexPath.row]objectForKey:@"close_all_day"]intValue];
            
            //NSLog([NSString stringWithFormat:@"%@ is open? %d, is closed? %d", libraryName, (int)openAllDay, (int)closeAllDay ]) ;
            
            //get open & close hours, convert to 24HR to int
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"hh:mma"];
            NSDate *openTimed = [df dateFromString:openTime];
            NSDate *closeTimed = [df dateFromString:closeTime];
            NSDate *timed = [NSDate date];
            [df setDateFormat:@"HH"];
            
            NSString *openTimeHR = [df stringFromDate:openTimed];
            NSString *closeTimeHR = [df stringFromDate:closeTimed];
            NSString *timeHR = [df stringFromDate:timed];
            
            int open = [openTimeHR intValue];
            int close = [closeTimeHR intValue];
            int time = [timeHR intValue];
            
            //is the library open?
            BOOL isOpen;
            if (openAllDay || (inRange && !closeAllDay)) {
                isOpen = YES;
            }
            /*
             if (isOpen) {
             cell.libraryName.textColor = [UIColor colorWithRed:0 green:.5 blue:0 alpha:1 ];
             }
             else {
             cell.libraryName.textColor = [UIColor redColor];
             }
             */
            NSString *status = (isOpen ? @"open" : @"closed");
            
            //text for labels
            cell.libraryName.text = libraryName;
            cell.libraryStatus.text = [NSString stringWithFormat:@"is %@",status];
            cell.openTime.text = openTime;
            cell.closeTime.text = closeTime;
            
            //format cell
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            
            //draw
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(125, 31, 187, 2)];
            line.backgroundColor =  [UIColor grayColor];
            [cell.contentView addSubview:line];
            
            
            //width of box
            UIView *hoursBox;
            if (openAllDay == 1) {
                hoursBox = [[UIView alloc] initWithFrame:CGRectMake(125, 27, 187, 10)];
            }
            else {
                int start = 187/24*open;
                int width = 187/24*close - start;
                hoursBox = [[UIView alloc] initWithFrame:CGRectMake(125+start, 27, width, 10)];
            }
            //colour of box
            if (isOpen) {
                hoursBox.backgroundColor =  [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0 ];
            }
            else{
                hoursBox.backgroundColor =  [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0 ];
            }
            [cell.contentView addSubview:hoursBox];
            
            //current time line
            int now = 187/23*time;
            UIView *nowLine = [[UIView alloc] initWithFrame:CGRectMake(125+now, 25, 3, 14)];
            nowLine.backgroundColor =  [UIColor blackColor];
            [cell.contentView addSubview:nowLine];
            
            
        }
        if (indexPath.section == 1) {
            //hide labels
            cell.libraryName.hidden = YES;
            cell.libraryStatus.hidden = YES;
            cell.openTime.hidden = YES;
            cell.closeTime.hidden = YES;
            //disable selection
            cell.userInteractionEnabled = NO;
            
            int benlaps = [[equipResults objectForKey:@"ben-checkout-laptops"]intValue];
            int ben2pc = [[equipResults objectForKey:@"ben-2-2105-pc"]intValue];
            int ben3Emac = [[equipResults objectForKey:@"ben-3-e-mac"]intValue];
            int ben3Epc = [[equipResults objectForKey:@"ben-3-e-pc"]intValue];
            int ben3Wpc =[[equipResults objectForKey:@"ben-3-w-pc"]intValue];
            int ben4pc =[[equipResults objectForKey:@"ben-4-4009-pc"]intValue];
            int ben5pc = [[equipResults objectForKey:@"ben-5-pc"]intValue];
            int ben6pc =[[equipResults objectForKey:@"ben-6-pc"]intValue];
            
            NSArray *counts = [NSArray arrayWithObjects:
                               IBOX(ben6pc),
                               IBOX(ben5pc),
                               IBOX(ben4pc),
                               IBOX(ben3Wpc),
                               IBOX(ben3Epc),
                               IBOX(ben3Emac),
                               IBOX(ben2pc),
                               IBOX(benlaps),
                               nil];
            
            float sum = 0.0;
            for(int i = 0; i < counts.count; i++){
                sum += (float)[counts[i]floatValue];
            }
            
            NSArray *ratios = [NSArray arrayWithObjects:
                               FBOX(ben6pc/sum),
                               FBOX(ben5pc/sum),
                               FBOX(ben4pc/sum),
                               FBOX(ben3Wpc/sum),
                               FBOX(ben3Epc/sum),
                               FBOX(ben3Emac/sum),
                               FBOX(ben2pc/sum),
                               FBOX(benlaps/sum),
                               nil];
            
            //NSLog(@"%d out of %f is %f", [counts[1]intValue], sum, [ratios[1]floatValue]);
            
            //labels
            NSArray *floors = @[@"6th Floor",@"5th Floor", @"4th Floor", @"3rd Floor, West", @"3rd Floor, East", @"3rd Floor, East", @"2nd Floor", @""];
            NSArray *comps = @[@"PCs",@"PCs", @"PCs", @"PCs", @"PCs", @"Macs", @"PCs", @"laptops"];
            
            int size = 65;
            int H = 0;
            
            UIView *box;
            UILabel *floor; UILabel *cnt;
            for (int i = 0; i < ratios.count; i++){
                
                //box
                float f = [ratios[i]floatValue];
                float height;
                if (i == 7) {
                    height = 5.0;
                }
                else {
                    height = f*size;
                }
                
                box = [[UIView alloc] initWithFrame:CGRectMake(8, 8+H, 304, height+10)];
                box.backgroundColor =  [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:f*4];
                [cell.contentView addSubview:box];
                
                //labels
                floor = [[UILabel alloc] initWithFrame:CGRectMake(8, 8+H, 304, height+10)];
                floor.text = [NSString stringWithFormat:@"%@", floors[i]];
                if (f*4 < 0.3) {
                    floor.textColor = [UIColor grayColor];
                }
                else{
                    floor.textColor = [UIColor whiteColor];
                }
                [floor setFont:[UIFont systemFontOfSize:height+9]];
                [cell.contentView addSubview:floor];
                
                cnt = [[UILabel alloc] initWithFrame:CGRectMake(8, 8+H, 304, height+10)];
                cnt.text = [NSString stringWithFormat:@"%d %@", [counts[i]intValue], comps[i]];
                cnt.textAlignment = NSTextAlignmentRight;
                if (f*4 < 0.3) {
                    cnt.textColor = [UIColor grayColor];
                }
                else{
                    cnt.textColor = [UIColor whiteColor];
                }
                [cnt setFont:[UIFont systemFontOfSize:height+9]];
                [cell.contentView addSubview:cnt];
                
                H += height+13;
            }
        }
    }
    
    //if no internet
    else if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.section == 0) {
            cell.libraryName.text = @"Bennett Library";
        }
        else {
            cell.libraryName.text = @"Internet connection is required.";
            cell.libraryName.textColor = [UIColor grayColor];
        }
        cell.libraryStatus.hidden = YES;
        cell.openTime.hidden = YES;
        cell.closeTime.hidden = YES;
    }
    
    if (indexPath.section == 2) {
        ServicesURL* url= [links objectAtIndex:indexPath.row];
        cell.libraryName.text = [url serviceName];
        cell.libraryStatus.hidden = YES;
        cell.openTime.hidden = YES;
        cell.closeTime.hidden = YES;
        
        //format cell
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.hidden = YES;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0)
    {   return @"Hours Open -- pull down to refresh --"; }
    if (section == 1)
    {   return @"Available Equipment";   }
    if (section == 2)
    {   return @"Quick Links";  }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 && indexPath.row == 0 && hasInternet) {
        return 172;
    }
    // "Else"
    return 44;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"openWebpage"])
    { // Get the new view controller using [segue destinationViewController].
        ServicesWebViewController *webcont = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ServicesURL *send = links[path.row];
        webcont.hidesBottomBarWhenPushed = YES;
        [webcont setCurrentURL:send];
    }
}
 

@end