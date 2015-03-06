//
//  TransitTableViewController.m
//  SFUnavapp
//  Team NoMacs
//  Created by James Leong on 2015-02-18.
//
//	Edited by James Leong
//	Edited by Tyler Wong
//  Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "TransitTableViewController.h"
#import "AppDelegate.h"
#import "BusRouteStorage.h" //  to use custom object to hold businfo
#import <QuartzCore/QuartzCore.h> // handles the appearance of UI elements
#import "ServicesURL.h"
#import "ServicesWebViewController.h" // code to add bus pass ups segue

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
@property (weak, nonatomic) IBOutlet UILabel *timeDIsplayLabel; // the grey background that holds the refresh button and timer
@property (weak, nonatomic) IBOutlet UILabel *timerLabel; // the timer label that displays X min until next bus

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

#pragma mark - initialization methods

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
    [self.view endEditing:YES]; // so the keyboard will always resign when you click ANYWHERE
}

- (void) updateuserDefaults: (NSString *) string{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:string forKey:@"currentstopID"];
    [[NSUserDefaults standardUserDefaults] synchronize]; // immediately updates user defaults
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
// also the first intended method to send API request

-(void)cancelNumberPad{ // when click cancel of numberpad, clears the textfield without submitting
    [_transitTextField resignFirstResponder];
    _transitTextField.text = @"";
}

// just like the behavior with sending the text information
-(void)doneWithNumberPad{
    
    if ([_transitTextField.text isEqualToString:@""]) {
        [_transitTextField resignFirstResponder];
        return;
    }
    else if (_transitTextField.text.length < 5) { // just resigns if they submitted a string of length 4 or less
        UIAlertView *invalidAlert = [[UIAlertView alloc] initWithTitle:@"Invalid bus stop ID" message:@"A valid input is a 5 digit stop ID or the ID with bus number e.g. 59044, 59044145" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [invalidAlert show];
        [_transitTextField resignFirstResponder];
        return;
    }
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
// note: make this method also display in label of time difference
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
    
    [self setTimer];
}


//timer works!! dont mess with it yet, i'll add good comments later -James
-(void) setTimer {
    NSString *key;
    NSString *currentTime; // gets the minutes
    NSString *displayTimerString;
    NSMutableArray *holds_from_d = [[NSMutableArray alloc] init]; //get from dictionary
    
    for(key in self.retrieveInfo.dictionary) // to get first item of dictionary
    { // this loop will not execute if the dictionary is empty
        [holds_from_d addObject:self.retrieveInfo.dictionary[key][0]]; //holds first string from the dictonary
        //break; // exit loop as soon as we enter it (key will be set to some key)
    }
    //this block here gets the string from array
    NSMutableArray *modifiedArr = [[NSMutableArray alloc] init]; // will hold those new strings;
    // must cut out the and leave only the minutes of each item, 5:47pm -> 5:47
    NSString *elem;
    for(elem in holds_from_d) {
        elem = [elem substringToIndex:[elem length] -2];
        NSLog(elem);
        [modifiedArr addObject:elem];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    
    NSMutableArray *dates = [NSMutableArray arrayWithCapacity:modifiedArr.count];
    for (NSString *timeString in modifiedArr)
    {
        NSDate *date = [dateFormatter dateFromString:timeString];
        [dates addObject:date];
    }
    
    [dates sortUsingSelector:@selector(compare:)];
    
    NSMutableArray *sortedTimes = [NSMutableArray arrayWithCapacity:dates.count]; // sorted times
    for (NSDate *date in dates)
    {
        NSString *timeString = [dateFormatter stringFromDate:date];
        [sortedTimes addObject:timeString];
    }
    
    
    if ([sortedTimes count] != 0) {
        NSString *firstTime = sortedTimes[0];
        NSLog(@"%@", firstTime);
    
        if (firstTime != nil) {
        
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"hh:mm"];
        
            NSDate *date = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
            int dateminute = [components minute]; //this holds the minutes from urrent phone
            NSLog(@"%i dateminute",dateminute);
        
            NSDate *busDate = [dateFormatter dateFromString:firstTime];
            NSCalendar *buscalendar = [NSCalendar currentCalendar];
            NSDateComponents *buscomponents = [buscalendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:busDate];
            int busMinutes = [buscomponents minute];
        
            int resultMinutes; // holds the minutes to didspaly
            if (dateminute > busMinutes) {
                busMinutes += 60;
                resultMinutes = busMinutes - dateminute;
            }
            else {
                resultMinutes = busMinutes - dateminute;
            }
            displayTimerString = [NSString stringWithFormat:@"%i", resultMinutes];
        }
    }
    else { //dictionary is empty
        displayTimerString = @"";
    }
    
    [_timerLabel setText:displayTimerString];
}


- (void) initialDisplay { // error check when initial loading app from clean state (userdefaults has no saved busID)
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userdefaults objectForKey:@"currentstopID"] != nil) {
        _busNum = [[userdefaults objectForKey:@"currentstopID"] substringFromIndex:5];
        _stopID = [[userdefaults objectForKey:@"currentstopID"] substringToIndex:5];
        self.retrieveInfo = [[BusRouteStorage alloc] initWithbusroute:_busNum andbusid:_stopID];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"passUps"]) {
        ServicesWebViewController *webcont = [segue destinationViewController];
        
        ServicesURL *send = [[ServicesURL alloc] init];
        send.serviceName=@"Pass Ups";
        send.serviceURL=@"http://www.sfu.ca/busstop.html";
        webcont.hidesBottomBarWhenPushed = YES;
        [webcont setCurrentURL:send];
    }
}


@end
