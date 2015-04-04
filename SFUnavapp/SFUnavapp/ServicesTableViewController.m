//
//  ServicesTableViewController.m
//  SFUnavapp
//  Team NoMacs
//  Created by James Leong on 2015-02-12.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "ServicesTableViewController.h"


@interface ServicesTableViewController ()
{
    NSMutableArray *links;
}
@property (strong) IBOutlet UIBarButtonItem *LoginButton;
- (IBAction)LoginButtonPress:(id)sender;

@end

NSString *username;
NSString *password;
BOOL autoLogin;
BOOL goLogin;

@implementation ServicesTableViewController

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
    // this is how to change titles in navbars - James
    //self.view.backgroundColor = [UIColor grayColor];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

    //Removing extra empty cells in tableview- Arjun
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
    
    /*
     Mutable array to hold all service names and url
    Order of service names matters!! - Arjun
     */
    links = [[NSMutableArray alloc] init];
    
    
    ServicesURL *url = [[ServicesURL alloc] init];
    url.serviceName=@"SFU Homepage";
    url.serviceURL=@"http://www.sfu.ca/";
    [links addObject:url];
    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"SFU Search";
    url.serviceURL = @"http://www.sfu.ca/search.html";
    [links addObject:url];
    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"Canvas";
    url.serviceURL = @"http://canvas.sfu.ca";
    [links addObject:url];
    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"Connect";
    url.serviceURL = @"http://connect.sfu.ca";
    [links addObject:url];

    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"CourSys";
    url.serviceURL = @"http://courses.cs.sfu.ca";
    [links addObject:url];
    
    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"goSFU (SIS)";
    url.serviceURL = @"https://go.sfu.ca/psp/paprd/EMPLOYEE/EMPL/h/?tab=PAPP_GUEST";
    [links addObject:url];
    
    url=[[ServicesURL alloc] init];
    url.serviceName=@"Symplicity";
    url.serviceURL = @"http://www.sfu.ca/wil/symplicity.html";
    [links addObject:url];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"mySFU";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (autoLogin)
        _LoginButton.title=@"Logout";
    else
        _LoginButton.title=@"Login";
   // NSLog(@"%@ %@",username,password);
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
    return links.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    
    [cell.layer setMasksToBounds:YES];
    //[cell.layer setBorderWidth:1];

    // Configure the cell...
    ServicesURL* current= [links objectAtIndex:indexPath.row];
    cell.textLabel.text= [current serviceName];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"LoadWebpage"])
    { // Get the new view controller using [segue destinationViewController].
        ServicesWebViewController *webcont = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ServicesURL *send = links[path.row];
        webcont.hidesBottomBarWhenPushed = YES;
        [webcont setCurrentURL:send];
        
    }
   
}


- (IBAction)LoginButtonPress:(id)sender {
    if (!autoLogin) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    else
    {
        NSURL *url= [NSURL URLWithString:@"https://courses.cs.sfu.ca/logout/"];
        NSURLRequest *requestObj= [NSURLRequest requestWithURL:url];
        NSLog(@"Logout coursys\n");
        [_web loadRequest:requestObj];
        url= [NSURL URLWithString:@"https://connect.sfu.ca/zimbra/m/zmain?loginOp=logout&client=mobile"];
        requestObj= [NSURLRequest requestWithURL:url];
        NSLog(@"Logout connect\n");
        [_web2 loadRequest:requestObj];
        _LoginButton.title=@"Login";
        autoLogin=NO;
        username=@"";
        password=@"";
        goLogin=NO;
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
        
    }
    
}


@end
