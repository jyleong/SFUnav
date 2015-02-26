//
//  WeatherViewController.m
//  SFUnavapp
//  Team NoMacs
//  Created by Arjun Rathee on 2015-02-20.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()
{
    NSMutableArray * links;
    NSMutableArray * collection;
}
@end

@implementation WeatherViewController

- (void) CampusInfoGen
{
    collection=[[NSMutableArray alloc]init];
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.sfu.ca/security/sfuroadconditions"]];
    TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:result];
    //use xpath to search element
    Campus* info = [[Campus alloc]init];
    
    //Burnaby Campus
    NSArray *data = [xpath searchWithXPathQuery:@"//div[@class='main-campus-status half first']/div/div/h3"];
    //item to convert object type and write content
    TFHppleElement *item = data[0];
    
    //write name
    info.name=item.text;
    
    data = [xpath searchWithXPathQuery:@"//div[@class='main-campus-status half first']/div/h1"];
    item = data[0];
    //write status
    info.status=item.text;
  
    data = [xpath searchWithXPathQuery:@"//div[@class='extra-weather-conditions last']/ul/li/span"];
    item = data[1];
    info.ClassExam=item.text;
    //NSLog(@"Class Exma bur%@",info.ClassExam);
  
    //data = [xpath searchWithXPathQuery:@"//div[@class='extra-weather-conditions last']/ul/li/li/li"];
    item = data[2];
    info.translink=item.text;
    //NSLog(@"Bus bur%@",info.translink);
    
    data = [xpath searchWithXPathQuery:@"//div[@class='main-campus-info half last']/div/div/div/h3/span"];
    item = data[0];
    info.road=item.text;
    //NSLog(@"road bur%@",info.road);
    [collection addObject:info];
    
    //Surrey Campus
    info = [[Campus alloc] init];
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half first']/a/div/div/h4"];
    
    item = data[0];
       //write log
    info.name=item.text;
    
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half first']/a/div/h3"];
    
    item = data[0];
        //write log
    info.status=item.text;
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half first']/p/span/strong"];
    item = data[0];
    info.ClassExam= item.text;
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
       //write status
    info.status=item.text;
    data = [xpath searchWithXPathQuery:@"//div[@class='status-container half last']/p/span/strong"];
    item = data[0];
    info.ClassExam= item.text;
    //NSLog(@"Class Exma van%@",info.ClassExam);
    info.translink= @"NODATA";
    info.road=@"NODATA";

    [collection addObject:info];
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CampusInfoGen];
    self.navigationItem.title = @"Weather";
    // Do any additional setup after loading the view.
    //Footer to remove extra cells
    _webcamTable.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
  
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (tableView == self.webcamTable)
        return links.count;
    else
        return collection.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.webcamTable)
    {
        static NSString *CellIdentifier=@"WebcamCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        // Configure the cell...
        Webcam* current= [links objectAtIndex:indexPath.row];
       // cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
        cell.textLabel.text= [current location];
        
        return cell;
    
    }
    
    else
    {
        UIColor * close = [UIColor colorWithRed:255/255.0f green:161/255.0f blue:0/255.0f alpha:1.0f];
        UIColor * open = [UIColor colorWithRed:51/255.0f green:161/255.0f blue:0/255.0f alpha:1.0f];
        static NSString *CellIdentifier=@"CampusCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        // Configure the cell...
        Campus* current= [collection objectAtIndex:indexPath.row];
        if ([current.status isEqual:@"Open"] && [current.ClassExam isEqual:@"On schedule"] )
        {
            if ([current.translink isEqual:@"NODATA"] || [current.translink isEqual:@"On schedule"])
            cell.backgroundColor= open;
        }
        else
            cell.backgroundColor= close;
        cell.textLabel.text= [current name];
        cell.textLabel.textColor= [UIColor whiteColor];
        cell.detailTextLabel.textColor= [UIColor grayColor];
        if (cell.backgroundColor==open)
            cell.detailTextLabel.text= @"Everything is fine! Click for more details";
        else
        {
            cell.detailTextLabel.text= @"Looks like something is wrong! Click Here!!";
        }
        /*[cell.layer setCornerRadius:7.0f];
        [cell.layer setMasksToBounds:NO];
        [cell.layer setBorderWidth:1.0f];
        */
        //[cell.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        

        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView== self.campusTable)
    {
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
        
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    WebcamWebViewController *webcont = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    
    NSIndexPath *path = [_webcamTable indexPathForSelectedRow];
    Webcam *send = links[path.row];
    webcont.hidesBottomBarWhenPushed = YES;
    [webcont setCurrentURL:send];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
