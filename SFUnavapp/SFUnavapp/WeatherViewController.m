//
//  WeatherViewController.m
//  SFUnavapp
//
//  Created by James Leong on 2015-02-12.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()
{
    NSMutableArray * links;
    
}
@end

@implementation WeatherViewController

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
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"WebcamCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Webcam* current= [links objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
    cell.textLabel.text= [current location];
    return cell;
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
