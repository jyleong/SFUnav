//
//  TransitTableViewController.m
//  SFUnavapp
//  Team NoMacs
//  Created by James Leong on 2015-02-18.
//
//	Edited by James Leong
//	Edited by Tyler Wong
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "TransitTableViewController.h"
#import "AppDelegate.h"
#import "BusRouteStorage.h" //  to use custom object to hold businfo
#import <QuartzCore/QuartzCore.h>

#define kPickerIndex 2
#define kPickerCellHeight 163
//string ID for NSuserDefaults for saved bus stop = @"currentstopID"

@interface TransitTableViewController ()

@property (assign) BOOL PickerIsShowing;
@property (weak, nonatomic) IBOutlet UITextField *transitTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *quicklinksPicker;
@property (weak, nonatomic) IBOutlet UILabel *quicklinkLabel;
@property (strong, nonatomic) NSArray *busstopNames; // trivially to set up dictionary
@property (strong, nonatomic) NSString *stopID; // stopID and busNUm to keep track of current stopid and busnum
@property (strong, nonatomic) NSString *busNum;
@property (strong, nonatomic) NSArray *fivedigitID; // trivially to set up dictionary
@property (strong, nonatomic) UIGestureRecognizer *tapper; // for the gesture to dismiss keyboard when tap out of textfield

@property (strong, nonatomic) BusRouteStorage *retrieveInfo; // instantiate object here
@property (weak, nonatomic) IBOutlet UITextView *busDisplaytextView;
@property (weak, nonatomic) IBOutlet UILabel *timeDIsplayLabel;

@end

@implementation TransitTableViewController

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
    self.navigationItem.title = @"Transit";
    [self signUpForKeyboardNotifications];
    // initialize tapper in viewdidload
    _tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    _tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapper];
    
    self.busNumbers = @[@"",@"135",@"143",@"144", @"145"];
    //to map the keys to objects
    self.busstopNames = @[@"Tower Rd", @"S Campus Rd", @"SFU Transportation Centre", @"University Dr W"];
    self.fivedigitID = @[@"59044", @"51862",@"51863", @"51864"];
    
    self.busStopID = [NSDictionary dictionaryWithObjects:self.fivedigitID forKeys:self.busstopNames];
    // need to keep list of keys to display in picker
    [self showbusnumcontents];
    [self hidePickerCell]; // picker needs to be initially hidden state
    self.tableView.tableFooterView = [[UIView alloc] init];
    _busDisplaytextView.layer.cornerRadius = 8;
    _timeDIsplayLabel.layer.cornerRadius = 8;
    
    [self initialDisplay];
    [self displayBusroutes]; // load up last inputed valid stop id
    self.tableView.separatorColor = [UIColor clearColor]; // hides the separator lines in table cells, cant seem to only get rid of the last one
    
    // this block of code makes the done and cancel buttons for the numpad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    _transitTextField.inputAccessoryView = numberToolbar;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}
// these two are methods must be called in viewdidload to handle the keyboard and picker
- (void)keyboardWillShow {
    
    if (self.PickerIsShowing){
        
        [self hidePickerCell];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

#pragma mark - PickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.busstopNames.count;
    }
    else {
        return self.busNumbers.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component ==0) {
        return self.busstopNames[row];
    }
    else {
        return self.busNumbers[row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    switch (component){
        case 0:
            return 260.0f;
        case 1:
            return 55.0f;
    }
    return 0;
}

#pragma mark - Table view methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == kPickerIndex){
        
        height = self.PickerIsShowing ? kPickerCellHeight : 0.0f;
        
    }
    
    //index path for label cell. Height adjusted to have full cell interactions
    if (indexPath.row ==3)
    {
        height= 265;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1){
        
        if (self.PickerIsShowing){
            
            [self hidePickerCell];
            
        }else {
            
            [self.transitTextField resignFirstResponder];
            
            [self showPickerCell];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showPickerCell {
    
    self.PickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.quicklinksPicker.hidden = NO;
    self.quicklinksPicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.quicklinksPicker.alpha = 1.0f;
        
    }];
}
- (void) updateuserDefaults: (NSString *) string{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:string forKey:@"currentstopID"];
    [[NSUserDefaults standardUserDefaults] synchronize]; // immediately updates user defaults
}

// second method to send api information
- (void)hidePickerCell {
    
    self.PickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.quicklinksPicker.hidden = YES;
    
    /*[UIView animateWithDuration:0.25
                     animations:^{
                         self.quicklinksPicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.quicklinksPicker.hidden = YES;
                     }];*/
}
- (IBAction)selectedpicker:(id)sender {
    // may rewrite this block into function later
    // or move this call to an actual button to submit picker input
    // button will hide picker, and save and send API information
    // this saves the picker values to nsuserdefaults
    [self hidePickerCell];
    NSString *chosenstopName = [self.busstopNames objectAtIndex:[self.quicklinksPicker selectedRowInComponent:0]]; //gets 5 digit
    _busNum = [self.busNumbers objectAtIndex:[self.quicklinksPicker selectedRowInComponent:1]]; //gets bus number
    //append the 5 + 3 length strings
    _stopID = [self.busStopID objectForKey:chosenstopName];
    NSString *pickerstopID = [_stopID stringByAppendingString:_busNum]; // string that is full length id for API
    [self updateuserDefaults:pickerstopID]; // immediately updates ns user defaults
    
    
    //Tylers custom class
    self.retrieveInfo = [[BusRouteStorage alloc] initWithbusroute:_busNum andbusid:_stopID];
    //test output terminal
    /*NSString *key;
    
    for(key in self.retrieveInfo.dictionary) {
        NSLog(key);
        NSArray *temparray = [self.retrieveInfo.dictionary objectForKey:key];
        for(NSString *elem in temparray) {
            NSLog(@"time: %@",elem);
        }
    }*/
    [self displayBusroutes];
    
}
- (IBAction)refreshAction:(id)sender {
    self.retrieveInfo = [[BusRouteStorage alloc] initWithbusroute:_busNum andbusid:_stopID];
    [self displayBusroutes];
}

# pragma mark - textFieldmethods
// BUG: app crahses if user enters wrong transit information such as blank string or character string, need to error check
// also the first intended method to send API request

-(void)cancelNumberPad{ // when click cancel of numberpad, clears the textfield without submitting
    [_transitTextField resignFirstResponder];
    _transitTextField.text = @"";
}

// just like the behavior with sending the text information
-(void)doneWithNumberPad{
    NSString *bustext  = [[NSString alloc] init]; // save the numbers to busnumText, doesn't account for errors yet
    bustext = _transitTextField.text;
    [self updateuserDefaults:bustext];
    _stopID = [bustext substringToIndex:5]; // 5 digit
    _busNum = [bustext substringFromIndex:5]; // 3 digit
    
    self.retrieveInfo = [[BusRouteStorage alloc] initWithbusroute:_busNum andbusid:_stopID];
    
    [self displayBusroutes];
    [_transitTextField resignFirstResponder];
}
// test method to display userdefaults
- (void) showbusnumcontents {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentstring = [userDefaults objectForKey:@"currentstopID"];
    NSLog(@"current: %@", currentstring);
}

# pragma mark - displaymethods

-(void) displayBusroutes {
    NSString *currstring = @"";
    NSString *key;
    for(key in self.retrieveInfo.dictionary) {
        currstring = [currstring stringByAppendingFormat:@"%@\n", key];
        NSArray *temparray = [self.retrieveInfo.dictionary objectForKey:key];
        for(NSString *elem in temparray) {
            currstring = [currstring stringByAppendingFormat:@"%@ ", elem];
        };
        currstring = [currstring stringByAppendingString:@"\n"];
    }
    [_busDisplaytextView setText:currstring];
}

- (void) initialDisplay { // error check when initial loading app from clean state (userdefaults has no saved busID)
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userdefaults objectForKey:@"currentstopID"] != nil) {
        _busNum = [[userdefaults objectForKey:@"currentstopID"] substringFromIndex:5];
        _stopID = [[userdefaults objectForKey:@"currentstopID"] substringToIndex:5];
        self.retrieveInfo = [[BusRouteStorage alloc] initWithbusroute:_busNum andbusid:_stopID];
    }
}
/*#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
