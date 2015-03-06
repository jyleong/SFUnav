//
//  TryTableViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-05.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "TryTableViewController.h"
#import "Reachability.h"
@interface TryTableViewController ()

{
    NSMutableArray * links;
    NSMutableArray * collection;
    NSArray *rowsToReload;
    NSString * extraPara;
    BOOL parsingResult;
}
@end

@implementation TryTableViewController

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
    rowsToReload=@[@0,@1,@2];
    [self genData];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title=@"Weather";
    [self webcamGen];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"in viewWillAppear\n");
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

-(void) genData
{
    parsingResult=[self checkInternet];
    //NSLog(@"\n\nIn gendata\n\n");
    if (parsingResult)
    {
        [self CampusInfoGen];
        [self BurnabyParaGen];
    }
    return;
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

- (void) BurnabyParaGen
{
    if (parsingResult==NO)
        return;
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.sfu.ca/security/sfuroadconditions"]];
    TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:result];
    //use xpath to search element
    
    //Burnaby Campus Extra Details
    NSArray *data = [xpath searchWithXPathQuery:@"//section[@class='main commentary']/section/div/div"];
    if ([data count]==0)
    {
        parsingResult=NO;
        return;
    }
    //item to convert object type and write content
    TFHppleElement *item = data[0];
    
    //write announcement string
    NSString *temp=item.content;
    //remove \n from first character
    extraPara=[temp substringFromIndex:1];
    
}

- (void) CampusInfoGen
{
    
    if (parsingResult==NO)
    {    return;
        
    }
    collection=[[NSMutableArray alloc]init];
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.sfu.ca/security/sfuroadconditions"]];
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
    if(section==0)
        return 3;
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
        return @"Campus Status ---Pull to refresh---";
    return @"SFU Webcams";
}

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
        if ([current.status isEqual:@"Open"] && [current.ClassExam isEqual:@"On Schedule"] )
        {
            if ([current.translink isEqual:@"NODATA"] || [current.translink isEqual:@"On Schedule"])
                cell.detailTextLabel.text=@"Open";
            NSLog(@"adjusting cell label\n");
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
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    //Create alert when accessory button is clicked
    if (parsingResult==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Internet Connection Required" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcements" message: extraPara delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

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
