//
//  WeatherTableViewController.m
//  SFUnavapp
//  Team NoMacs
//  Created by Arjun Rathee on 2015-03-05.
//
//	Edited by James Leong
//  Edited by Arjun Rathee
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "WeatherTableViewController.h"
#import "Reachability.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green: ((float)((rgbValue & 0xFF00) >> 8))/255.0 blue: ((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "RoadReportTableCell.h"

@interface WeatherTableViewController ()

{
    NSMutableArray * links;
    NSMutableArray * collection;
    //NSArray *rowsToReload;
    NSString * extraPara;
    BOOL parsingResult;
}
@end

@implementation WeatherTableViewController

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
    //parsingResult=YES;
    //rowsToReload=@[@0,@1,@2];
    [self genData];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = UIColorFromRGB(0xB5111B);
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBarHidden=NO;
    [self webcamGen];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"Weather";
}

- (void)reload
{
    // Reload table data
    [self genData];
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

-(void) webcamGen
{
    links= [[NSMutableArray alloc] init];
    Webcam *url = [[Webcam alloc]init];
    url.filename=@"AQNorth";
    url.location=@"AQ North";
    [links addObject:url];
    
    url=[[Webcam alloc]init];
    url.filename=@"AQSouthWest";
    url.location=@"AQ South West";
    [links addObject:url];
    
    url=[[Webcam alloc]init];
    url.filename=@"ConvocationMall";
    url.location=@"Convocation Mall";
    [links addObject:url];
    
    url=[[Webcam alloc]init];
    url.filename=@"Gaglardi";
    url.location=@"Gaglardi Intersection";
    [links addObject:url];
    
    url=[[Webcam alloc]init];
    url.filename=@"UniversityDriveNorth";
    url.location=@"University Drive North";
    [links addObject:url];
}

//parsing json happens here
-(void) genData
{
    parsingResult=[self checkInternet];
    if (parsingResult)
    {

        NSData *roadData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:@"http://www.sfu.ca/security/sfuroadconditions/api/2/current"]];
        NSDictionary *json = nil;
        if (roadData) {
            json = [NSJSONSerialization JSONObjectWithData:roadData options:kNilOptions error:nil];
        }
        [self CampusInfoGen: json];
        [self BurnabyParaGen];
    }
    return;
}


//Arjun's previous method
/*-(void) genData
{
    parsingResult=[self checkInternet];
    //NSLog(@"\n\nIn gendata\n\n");
    if (parsingResult)
    {
        [self CampusInfoGen];
        [self BurnabyParaGen];
    }
    return;
}*/

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

// test json feed
/*- (void) updateWithDict: (NSDictionary*) json
{
    @try {
        NSString *jsonfeed = [NSString stringWithFormat:@"Burnaby Campus: campus status %@ \n classes and exams %@ \n buses %@ \n roads %@ \n",
                              json[@"conditions"][@"burnaby"][@"campus"][@"status"],
                              json[@"conditions"][@"burnaby"][@"classes_exams"][@"status"],
                              json[@"conditions"][@"burnaby"][@"transit"][@"status"],
                              json[@"conditions"][@"burnaby"][@"roads"][@"status"], nil];
        NSLog(@"%@", jsonfeed);
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Coud not parse json" delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil] show];
        NSLog(@"exception : %@", exception);
    }
}*/


//this method sets te objects for each campus from the json dictionary
- (void) CampusInfoGen: (NSDictionary*) json
{
    
    if (parsingResult==NO)
    {    return;
        
    }
    collection=[[NSMutableArray alloc]init];
    Campus *info = [[Campus alloc] init];
    
    //burnaby
    info.name=@"Burnaby Campus";
    info.status= json[@"conditions"][@"burnaby"][@"campus"][@"status"];
    
    info.ClassExam=json[@"conditions"][@"burnaby"][@"classes_exams"][@"status"];
    //write bus status
    info.translink=json[@"conditions"][@"burnaby"][@"transit"][@"status"];
    info.road=json[@"conditions"][@"burnaby"][@"roads"][@"status"];
    [collection addObject:info];
    
    //Surrey Campus
    info = [[Campus alloc] init];
    info.name= @"Surrey Campus";
    info.status=json[@"conditions"][@"surrey"][@"campus"][@"status"];
    
    info.ClassExam= json[@"conditions"][@"surrey"][@"classes_exams"][@"status"];
    info.translink= @"NODATA";
    info.road=@"NODATA";
    //NSLog(@"Class Exma sur%@",info.name);
    [collection addObject:info];
    
    //Vancouver Campus
    info = [[Campus alloc] init];
    info.name=@"Vancouver Campus";
    
    info.status=json[@"conditions"][@"vancouver"][@"campus"][@"status"];
    
    info.ClassExam= json[@"conditions"][@"vancouver"][@"classes_exams"][@"status"];
    //NSLog(@"Class Exma van%@",info.ClassExam);
    info.translink= @"NODATA";
    info.road=@"NODATA";
    
    [collection addObject:info];
    
    
}

//unnecessary
/*- (void) BurnabyParaGen: (NSDictionary*) json
{
    @try {
        NSArray *jsonfeed = [json objectForKey:@"announcements"];
        NSLog(@"%@", jsonfeed[0]);
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Coud not parse json" delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil] show];
        NSLog(@"exception : %@", exception);
    }
}*/
- (void) BurnabyParaGen
{
//    if (parsingResult==NO)
//        return;
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.sfu.ca/security/sfuroadconditions/"]];
    TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:result];
    //use xpath to search element
    
    //Burnaby Campus Extra Details
    NSArray *data = [xpath searchWithXPathQuery:@"//section[@class='announcements']/div"];
    if ([data count]==0)
    {
        //parsingResult=NO;
        extraPara=@"";
    }
    //item to convert object type and write content
    else
    {
        
        TFHppleElement *item = data[0];
        //write announcement string
        NSString *temp=item.content;
        extraPara=[temp substringFromIndex:0];
    }
    
}

/*- (void) CampusInfoGen
{
    
    if (parsingResult==NO)
    {    return;
        
    }
    collection=[[NSMutableArray alloc]init];
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.sfu.ca/security/sfuroadconditions/"]];
    TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:result];
    //use xpath to search element
    Campus* info = [[Campus alloc]init];
    
    //Burnaby Campus
    NSArray *data = [xpath searchWithXPathQuery:@"//div[@class='main-campus-status half first']/div/div/h3"];
    if([data count]==0)
    {
        parsingResult=NO;
        return;
    }
    //item to convert object type and write content
    //write campus name
    TFHppleElement *item = data[0];
    info.name=item.text;
    
    data = [xpath searchWithXPathQuery:@"//div[@class='main-campus-status half first']/div/h1"];
    //write campus status
    item = data[0];
    info.status=[item.text capitalizedString];
    
    data = [xpath searchWithXPathQuery:@"//div[@class='extra-weather-conditions last']/ul/li/span"];
    //write class and exam status
    item = data[1];
    info.ClassExam=[item.text capitalizedString];
    //write bus status
    item = data[2];
    info.translink=[item.text capitalizedString];
    
    
    data = [xpath searchWithXPathQuery:@"//div[@class='main-campus-info half last']/div/div/div/h3/span"];
    //write road condition
    item = data[0];
    info.road=[item.text capitalizedString];
    [collection addObject:info];
    
    //Surrey Campus
    info = [[Campus alloc] init];
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half first']/a/div/div/h4"];
    //write name
    item = data[0];
    info.name=item.text;
    
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half first']/a/div/h3"];
    //write campus status
    item = data[0];
    info.status=[item.text capitalizedString];
    
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half first']/p/span/strong"];
    //write class and exam status
    item = data[0];
    info.ClassExam= [item.text capitalizedString];
    info.translink= @"NODATA";
    info.road=@"NODATA";
    //NSLog(@"Class Exma sur%@",info.ClassExam);
    [collection addObject:info];
    
    //Vancouver Campus
    info = [[Campus alloc] init];
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half last']/a/div/div/h4"];
    item = data[0];
    //write name
    info.name=item.text;
    
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half last']/a/div/h3"];
    item = data[0];
    //write campus status
    info.status=[item.text capitalizedString];
    
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half last']/p/span/strong"];
    //write class and exam status
    item = data[0];
    info.ClassExam= [item.text capitalizedString];
    //NSLog(@"Class Exma van%@",info.ClassExam);
    info.translink= @"NODATA";
    info.road=@"NODATA";
    
    [collection addObject:info];
    
}*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// table height depending on section
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    // in the roadreport section
    if (indexPath.section == 0){
        
        height = 110;
        
    }
    
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if(section==0)
        return 3;
    return links.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
        return @"Campus Status ---Pull to refresh---";
    return @"SFU Webcams";
}


//shows the status INSIDE the cell rather than alertview
//Configure cells for each section
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        RoadReportTableCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"RoadReportTableCell" forIndexPath:indexPath];
        //[rowsToReload addObject:indexPath.row];
        
        //cell.detailTextLabel.text=@"YES";
        if (parsingResult==NO)
        {
            //cell.backgroundColor=close;
            cell.titleLabel.text=@"Internet Connection Is Required";
            cell.detailsLabel.text = @"";

            cell.openstatusLabel.hidden = YES;
            return cell;
        }
        // Configure the cell...
        Campus* current= [collection objectAtIndex:indexPath.row];
        cell.openstatusLabel.hidden = NO;
        if ([current.status isEqual:@"open"] && [current.ClassExam isEqual:@"on schedule"] )
        {
            if ([current.translink isEqual:@"NODATA"] || [current.translink isEqual:@"on schedule"]) {
                //cell.detailsLabel.text=@"Open";
                cell.openstatusLabel.text = @"Open";
                cell.openstatusLabel.backgroundColor = [UIColor greenColor];
            
            }
            // NSLog(@"adjusting cell label\n");
        }
        else {
            cell.openstatusLabel.text =@"Close";
            cell.openstatusLabel.backgroundColor = [UIColor redColor];
            //cell.detailsLabel.text= @"Close";
        }
        cell.titleLabel.text= [current name];
        if ([current.name isEqual: @"Burnaby Campus"])
        {
            NSString * detailText= [NSString stringWithFormat:@"Campus Status: %@ \nClass and Exams: %@ \nBuses: %@ \nRoads: %@",[current status],[current ClassExam], [current translink], [current road]];
            cell.detailsLabel.text =detailText;
            
        }
        else
        {
            NSString* detailText= [NSString stringWithFormat:@"Campus Status: %@ \nClass and Exams: %@",[current status],[current ClassExam]];
            cell.detailsLabel.text = detailText;
            
        }
        return cell;
        
    }
    else
    {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.detailTextLabel.text=@"";
        Webcam* current= [links objectAtIndex:indexPath.row];
        // cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
        cell.textLabel.text= [current location];
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}
/*//Configure cells for each section
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        //[rowsToReload addObject:indexPath.row];
        
        //cell.detailTextLabel.text=@"YES";
        if (parsingResult==NO)
        {
            //cell.backgroundColor=close;
            cell.textLabel.text=@"Internet Connection Is Required";
            cell.detailTextLabel.text=@"Internet Connection Is Required";
            //cell.textLabel.textColor= [UIColor whiteColor];
            //cell.detailTextLabel.textColor= [UIColor whiteColor];
            return cell;
        }
        // Configure the cell...
        Campus* current= [collection objectAtIndex:indexPath.row];
        //NSLog(@"curent name %@, current status %@, curr sche %@", current.name, current.status, current.ClassExam);
        if ([current.status isEqual:@"open"] && [current.ClassExam isEqual:@"on schedule"] )
        {
            if ([current.translink isEqual:@"NODATA"] || [current.translink isEqual:@"on schedule"])
                cell.detailTextLabel.text=@"Open";
           // NSLog(@"adjusting cell label\n");
        }
        else
            cell.detailTextLabel.text= @"Close";
        cell.textLabel.text= [current name];
        
        //cell.textLabel.textColor= [UIColor whiteColor];
        //cell.detailTextLabel.textColor= [UIColor grayColor];
        //if (cell.backgroundColor==open)
        //    cell.detailTextLabel.text= @"Everything is fine! Click for more details";
        //else
        //{
        //   cell.detailTextLabel.text= @"Looks like something is wrong! Click Here!!";
        //    cell.detailTextLabel.textColor = [UIColor whiteColor];
        //}
       if ([cell.textLabel.text isEqualToString: @"Burnaby Campus"])
        {
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            
        }
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.detailTextLabel.text=@"";
        Webcam* current= [links objectAtIndex:indexPath.row];
        // cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
        cell.textLabel.text= [current location];
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}*/

//Accessory action for Burnaby campus cell to display extra announcements from the website
/*- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    //Create alert when accessory button is clicked
   
    if (parsingResult==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Internet Connection Required" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcements" message: extraPara delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}*/

/*
//Create AlertViews to show parsing result on cell click for campus rows
//or perform segue to UIWebView when a webcam name is selected
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (parsingResult==NO)
        {
            //NSLog(@"Parsing result was no\n");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Internet Connection Required" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        Campus* current= [collection objectAtIndex:indexPath.row];
        
        if ([current.name isEqual: @"Burnaby Campus"])
        {
            NSString * detailText= [NSString stringWithFormat:@"Campus Status: %@ \nClass and Exams: %@ \nBuses: %@ \nRoads: %@",[current status],[current ClassExam], [current translink], [current road]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [current name] message: detailText delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            //cell.detailTextLabel.text = detailText;
        }
        else
        {
            NSString* detailText= [NSString stringWithFormat:@"Campus Status: %@ \nClass and Exams: %@",[current status],[current ClassExam]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [current name] message: detailText delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        return;
    }
    if (indexPath.section==1)
    {
        [self performSegueWithIdentifier:@"webcamDisplay" sender:self];
        return;
    }
}*/

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
    if (path.section == 0)
    {
        Campus* current= [collection objectAtIndex:path.row];
        if ([current.name isEqual: @"Burnaby Campus"]) {
            return path;
        }
        //return path;
    }
    else if (path.section == 1)
    {
        return path;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //only have the burnaby campus selectable for alertview
    if (indexPath.section==0)
    {
        if (parsingResult==NO)
        {
            //NSLog(@"Parsing result was no\n");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Internet Connection Required" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        Campus* current= [collection objectAtIndex:indexPath.row];
        
        if ([current.name isEqual: @"Burnaby Campus"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [current name] message: extraPara delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        return;
    }
    // webcame section transitions to webview
    if (indexPath.section==1)
    {
        [self performSegueWithIdentifier:@"webcamDisplay" sender:self];
        return;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    WebcamWebViewController *webcont = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Webcam *send = links[path.row];
    webcont.hidesBottomBarWhenPushed = YES;
    [webcont setCurrentURL:send];
}

@end
