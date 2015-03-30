//
//  NewsChannelTableViewController.m
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-20.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "NewsChannelTableViewController.h"
#import "NewsTableViewController.h"

@interface NewsChannelTableViewController ()

@end
@implementation NewsChannelTableViewController
//@synthesize currentchannel, channelList;
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
    
    
    //the following lines of code creates channel objects consisting of the name and the weblink of the channel, then adding them to the list of channels, which are presented in the view
    
    _currentchannel = [[Channel alloc]init];
    _channelList = [[NSMutableArray alloc]init];
    //Channel *newchannel = [[Channel alloc]initWithchannelname:@"Events Calendar" andlink:@"https://events.sfu.ca/rss/calendar_id/2.xml"];
    _currentchannel.channelurl = @"https://events.sfu.ca/rss/calendar_id/2.xml";
    _currentchannel.channelName = @"Events Calendar";
    [_channelList addObject:_currentchannel];
    
    
    _currentchannel = [[Channel alloc]init];
    _currentchannel.channelurl = @"https://events.sfu.ca/rss/calendar_id/29.xml";
    _currentchannel.channelName = @"Academic Advising";
    //NSLog(_currentchannel.channelName);
    [_channelList addObject:_currentchannel];
    
    
    _currentchannel = [[Channel alloc]init];
    _currentchannel.channelurl = @"https://events.sfu.ca/rss/calendar_id/4.xml";
    _currentchannel.channelName = @"Dates, Holidays, and Closures";
    //NSLog(_currentchannel.channelName);
    [_channelList addObject:_currentchannel];
    
    _currentchannel = [[Channel alloc]init];
    _currentchannel.channelurl = @"https://events.sfu.ca/rss/item_type_id/12.xml";
    _currentchannel.channelName = @"Special Events";
    //NSLog(_currentchannel.channelName);
    [_channelList addObject:_currentchannel];
    
    _currentchannel = [[Channel alloc]init];
    _currentchannel.channelurl = @"http://www.sfu.ca/content/sfu/sfunews/people/jcr:content/main_content/list.feed";
    _currentchannel.channelName = @"People";
    //NSLog(_currentchannel.channelName);
    [_channelList addObject:_currentchannel];
    
    _currentchannel = [[Channel alloc]init];
    _currentchannel.channelurl = @"http://www.sfu.ca/content/sfu/sfunews/community/jcr:content/main_content/list.feed";
    _currentchannel.channelName = @"Community";
    //NSLog(_currentchannel.channelName);
    [_channelList addObject:_currentchannel];
    
    _currentchannel = [[Channel alloc]init];
    _currentchannel.channelurl = @"http://www.sfu.ca/content/sfu/sfunews/sports/jcr:content/main_content/list.feed";
    _currentchannel.channelName = @"Sports";
    //NSLog(_currentchannel.channelName);
    [_channelList addObject:_currentchannel];
    
    _currentchannel = [[Channel alloc]init];
    _currentchannel.channelurl = @"http://www.sfu.ca/content/sfu/sfunews/learning/jcr:content/main_content/list.feed";
    _currentchannel.channelName = @"Learning";
    //NSLog(_currentchannel.channelName);
    [_channelList addObject:_currentchannel];
    
    _currentchannel = [[Channel alloc]init];
    _currentchannel.channelurl = @"http://www.sfu.ca/content/sfu/sfunews/research/jcr:content/main_content/list.feed";
    _currentchannel.channelName = @"Research";
    //NSLog(_currentchannel.channelName);
    [_channelList addObject:_currentchannel];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"News";
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
    
    if (section == 0)
    {   return 4;   }
    if (section == 1)
    {   return 5;    }

    return 0;
  //  return [_channelList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {    _currentchannel = [_channelList objectAtIndex:indexPath.row];    }
    if (indexPath.section == 1)
    {    _currentchannel = [_channelList objectAtIndex:indexPath.row+4];    }
    
   //_currentchannel = [_channelList objectAtIndex:indexPath.row];
   // NSLog(@"haha");
    //NSLog(_currentchannel.channelName);
    cell.textLabel.text = _currentchannel.channelName;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0)
    {   return @"Events"; }
    if (section == 1)
    {   return @"News";   }
    return 0;
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
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {    _currentchannel = [_channelList objectAtIndex:indexPath.row];    }
    if (indexPath.section == 1)
    {    _currentchannel = [_channelList objectAtIndex:indexPath.row+4];    }
   // _currentchannel = [_channelList objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"ChannelLink" sender:self];
    //[self performSegueWithIdentifier:@"linktoWeb" sender:self];
    
    
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([[segue identifier] isEqualToString:@"ChannelLink"]) {
        NewsTableViewController *webcont = [segue destinationViewController];
        
        // ServicesURL *send = [[ServicesURL alloc] init];
        //send.serviceName=@"About Us";
        //send.serviceURL=@"https://cmpt275g13.wordpress.com/";
        //webcont.hidesBottomBarWhenPushed = YES;
        [webcont setChannel:_currentchannel];
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
