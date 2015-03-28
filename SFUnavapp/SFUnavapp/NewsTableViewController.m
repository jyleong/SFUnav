//
//  NewsTableViewController.m
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-16.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "NewsTableViewController.h"

#import "Parser.h"

@interface NewsTableViewController ()
@end

@implementation NewsTableViewController
@synthesize listArray,theList;
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
    
    
    self.navigationController.navigationBar.topItem.title = @""; // line to hide back button text
    
    NSString *inputurlstring =_channel.channelurl;
    //NSString *storage;
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:inputurlstring]];
    
    NSXMLParser *xmlparser = [[NSXMLParser alloc]initWithData:result];
    
    
    
    //initiates the parser object and parses the xml document from within the parser object
    Parser *theparser = [[Parser alloc]init];
    [xmlparser setDelegate:theparser];
    BOOL worked = [xmlparser parse];
    listArray = theparser.listArray;
    
    /*
    //nslogs the number of articles found, if none, boo
    if (worked){
        NSLog(@"amount %i",[listArray count]);
    }
    else{
        NSLog(@"boo");
    }
    
    for (int i=0; i<[listArray count]; i++){
         NSLog( [listArray[i] title]);
        NSLog([listArray[i] description]);
    }
    */
    
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = _channel.channelName;
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
    return [listArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     static NSString *cellidentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier forIndexPath:indexPath];
    
    // Configure the cell...
   // for (int i=0; i<[listArray count]; i++){
        // NSLog( [listArray[i] title]);
        //NSLog([listArray[i] description]);
        
    //}
    
    
    
    //retrieves the title of the selected article and link from the list array and displays them in a table
    
    theList = [listArray objectAtIndex:indexPath.row];
    NSString *input = theList.title;
    //NSLog(input);
    NSString* result = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *inputdate = theList.pubDate;
    cell.textLabel.text = result;
    
    
    NSString *result2 = [inputdate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//result2 = @"haha";
    cell.detailTextLabel.text =result2;
    
   // NSLog(result2);
   // NSLog(theList.title);
    //NSLog(theList.link);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    theList = [listArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"NewsLink" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"NewsLink"]) {
        ServicesWebViewController *webcont = [segue destinationViewController];
        
        ServicesURL *send = [[ServicesURL alloc] init];
        send.serviceName=theList.title;
        send.serviceURL=[theList.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
        webcont.hidesBottomBarWhenPushed = YES;
        [webcont setCurrentURL:send];
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

//the reload button reloads the data by parsing the xml document another time and reloading the table with the new results
- (IBAction)reload:(id)sender {
    
    NSLog(@"RELOAD");
    NSString *inputurlstring =_channel.channelurl;
    //NSString *inputurlstring =@"https://events.sfu.ca/rss/calendar_id/2.xml";
    //NSString *storage;
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:inputurlstring]];
    
    NSXMLParser *xmlparser = [[NSXMLParser alloc]initWithData:result];
    Parser *theparser = [[Parser alloc]init];
    [xmlparser setDelegate:theparser];
    //BOOL worked = [xmlparser parse];
    listArray = theparser.listArray;
    
    /*
    if (worked){
        NSLog(@"amount %i",[listArray count]);
    }
    else{
        NSLog(@"boo");
    }
   
    for (int i=0; i<[listArray count]; i++){
        // NSLog( [listArray[i] title]);
        //NSLog([listArray[i] description]);
        
    }
     */
    
    [self.tableView reloadData];

}


@end
