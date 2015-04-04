//
//  TransitTableViewController.m
//  SFUnavapp
//  Team NoMacs
//  Created by James Leong on 2015-02-18.
//
//	Edited by James Leong
//	Edited by Tyler Wong
//  Edited by Arjun Rathee
//  Edited by Steven Zhou
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
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green: ((float)((rgbValue & 0xFF00) >> 8))/255.0 blue: ((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TransitTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *picker_updown_arrow;
@property (weak, nonatomic) IBOutlet UIButton *picker_done_btn;
@property (assign) BOOL PickerIsShowing;
@property (weak, nonatomic) IBOutlet UITextField *transitTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *quicklinksPicker;
@property (weak, nonatomic) IBOutlet UILabel *quicklinkLabel;
@property (strong, nonatomic) NSArray *busstopNames; // trivially to set up dictionary
@property (weak, nonatomic) NSString *stopID; // stopID and busNUm to keep track of current stopid and busnum
@property (weak, nonatomic) NSString *busNum;
@property (strong, nonatomic) NSArray *fivedigitID; // trivially to set up dictionary
@property (strong, nonatomic) UIGestureRecognizer *tapper; // for the gesture to dismiss keyboard when tap out of textfield

@property (strong, nonatomic) BusRouteStorage *retrieveInfo; // instantiate object here
@property (weak, nonatomic) IBOutlet UITextView *busDisplaytextView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel; // the timer label that displays X min until next bus
@property (strong, nonatomic) NSString *stringofTimes; // two strings to hold the current text to show in disaply

@property (strong, nonatomic) NSString *stringofCounts;
@property (weak, nonatomic) IBOutlet UISwitch *textSwitch;


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
    [self signUpForKeyboardNotifications];
    // initialize tapper in viewdidload
    _tapper = [[UITapGestureRecognizer alloc]
               initWithTarget:self action:@selector(handleSingleTap:)];
    _tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapper];
    
    self.busNumbers = @[@"",@"135",@"143",@"144", @"145"];
    //to map the keys to objects
    self.busstopNames = @[@"Transit Hub - 145", @"Transit Hub - 135", @"Transit Hub - 143", @"Transit Hub - 144", @"Production Way",@"Tower Rd", @"S Campus Rd", @"Transportation Centre", @"University Dr W"];
    self.fivedigitID = @[@"51861",@"53096",@"52998",@"52807", @"59314",@"59044", @"51862",@"51863", @"51864"];
    
    self.busStopID = [NSDictionary dictionaryWithObjects:self.fivedigitID forKeys:self.busstopNames];
    // need to keep list of keys to display in picker
    //[self showbusnumcontents];
    [self hidePickerCell]; // picker needs to be initially hidden state
    self.tableView.tableFooterView = [[UIView alloc] init];
    _busDisplaytextView.layer.cornerRadius = 8;
    _quicklinkLabel.layer.cornerRadius = 8;
    
    [self.quicklinksPicker selectRow:4 inComponent:0 animated:YES]; // so the first component in picker defaulted at production way
    [self initialDisplay];
    [self displayBusroutes]; // load up last inputed valid stop id
    //self.tableView.separatorColor = [UIColor clearColor]; // hides the separator lines in table cells, cant seem to only get rid of the last one
    
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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0 green:83/255.0 blue:155/255.0 alpha:1.0];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];

    _textSwitch.onTintColor=UIColorFromRGB(0xB5111B);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"Transit";
}

- (void)reload
{
    // Reload Bus Results
    self.retrieveInfo = [[BusRouteStorage alloc] initWithbusroute:_busNum andbusid:_stopID];
    [self displayBusroutes];
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        // shows last refresh time
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
    if (indexPath.row ==4)
    {
        height= 215;
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
    self.picker_done_btn.hidden = NO;
    self.picker_updown_arrow.image = [UIImage imageNamed:@"Upward_table_arrow"];
    self.quicklinkLabel.text = @"Close Quick links"; // change text of quicklinklabel
    
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
    self.picker_done_btn.hidden = YES;
    self.picker_updown_arrow.image = [UIImage imageNamed:@"Downward_table_arrow"];
    self.quicklinkLabel.text = @"Open Quick links";
    
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
    // button will hide picker, and save and send API information
    // this saves the picker values to nsuserdefaults
    // only sends information if pickerisshowing
    
    if (_PickerIsShowing) {
        [self hidePickerCell];
        NSString *chosenstopName = [self.busstopNames objectAtIndex:[self.quicklinksPicker selectedRowInComponent:0]]; //gets 5 digit
        _busNum = [self.busNumbers objectAtIndex:[self.quicklinksPicker selectedRowInComponent:1]]; //gets bus number
        //append the 5 + 3 length strings
        _stopID = [self.busStopID objectForKey:chosenstopName];
        NSString *pickerstopID = [_stopID stringByAppendingString:_busNum]; // string that is full length id for API
        [self updateuserDefaults:pickerstopID]; // immediately updates ns user defaults
        
        
        //Tylers custom class
        self.retrieveInfo = [[BusRouteStorage alloc] initWithbusroute:_busNum andbusid:_stopID];

        // updates the display
        [self displayBusroutes];
    }
    
}
- (IBAction)refreshAction:(id)sender {
    self.retrieveInfo = [[BusRouteStorage alloc] initWithbusroute:_busNum andbusid:_stopID];
    [self displayBusroutes];
}
- (IBAction)toggletime_min:(id)sender {
    if (_textSwitch.on) {
        [_busDisplaytextView setText:_stringofTimes];
    }
    else{
        [_busDisplaytextView setText:_stringofCounts];
    }
}


# pragma mark - textFieldmethods
// also the first intended method to send API request

-(void)cancelNumberPad{ // when click cancel of numberpad, clears the textfield without submitting
    [_transitTextField resignFirstResponder];
    _transitTextField.text = @"";
}

// tapping done sends the information to api

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
    
    //updates userdefaults with stored bus string
    [self updateuserDefaults:_transitTextField.text];
    _stopID = [_transitTextField.text substringToIndex:5]; // 5 digit
    _busNum = [_transitTextField.text substringFromIndex:5]; // 3 digit
    
    self.retrieveInfo = [[BusRouteStorage alloc] initWithbusroute:_busNum andbusid:_stopID];
    
    [self displayBusroutes];
    [_transitTextField resignFirstResponder];
}
// test method to display userdefaults commented out
/*
- (void) showbusnumcontents {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentstring = [userDefaults objectForKey:@"currentstopID"];
    NSLog(@"current: %@", currentstring);
}*/

# pragma mark - displaymethods
-(void) displayBusroutes {
    // block of code to format the textview with bus infroamtion
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
    _stringofTimes = currstring;
    
    NSString *currstring2 = @"";
    NSString *secondkey;
    for(secondkey in self.retrieveInfo.dictionary_count) {
        currstring2 = [currstring2 stringByAppendingFormat:@"%@\n", secondkey];
        
        NSArray *temparray2 = [self.retrieveInfo.dictionary_count objectForKey:secondkey];
        for(NSString *elem2 in temparray2) {
            currstring2 = [currstring2 stringByAppendingFormat:@"%@min ", elem2];
        };
        currstring2 = [currstring2 stringByAppendingString:@"\n"];
        //NSLog(@"%@", currstring2);
    }
    _stringofCounts = currstring2;
    
    //NSLog(@"%@", _stringofCounts);
    [_busDisplaytextView setText:_stringofTimes];
    // call to method to display the time remaining for next bus
    [self setTimer];
    [_textSwitch setOn:YES];
}

-(void) setTimer {
    NSString *key;
    NSString *displayTimerString; // text to display in label
    NSMutableArray *holds_from_d = [[NSMutableArray alloc] init]; //get from dictionary
    
    for(key in self.retrieveInfo.dictionary_count) // to get first item of dictionary
    { // this loop will not execute if the dictionary is empty
        [holds_from_d addObject:self.retrieveInfo.dictionary_count[key][0]]; //holds first string from the dictonary
    }
    //block sorts the array
    [holds_from_d sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:(NSNumericSearch)];
    }];
    
    //logging
    //NSLog(@"%@", holds_from_d);
    if ([holds_from_d count] != 0) {
        NSString *firstTime = holds_from_d[0];
        if (firstTime != nil) {
            //displayTimerString = [firstTime stringByAppendingString:@" min"];
            displayTimerString = [NSString stringWithFormat:@"%@ Next Bus: %@min", _stopID, firstTime];
        }
        else {
            displayTimerString = @"";
        }
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
    ServicesWebViewController *webcont = [segue destinationViewController];
    
    ServicesURL *send = [[ServicesURL alloc] init];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"passUps"]) {
        send.serviceName=@"Pass Ups";
        send.serviceURL=@"http://www.sfu.ca/busstop.html";
    }
    // translink webservice must have cases
    else if ([[segue identifier] isEqualToString:@"viewBus"]) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *currentstring = [userDefaults objectForKey:@"currentstopID"];
        NSLog(@"current string to pass to web: %@", currentstring);
        send.serviceName=@"Translink";
        
        if (currentstring.length ==5) {
            send.serviceURL=[NSString stringWithFormat:@"http://nb.translink.ca/Map/Stop/%@", _stopID];
        }
        else if (currentstring.length >=5) {
            send.serviceURL=[NSString stringWithFormat:@"http://nb.translink.ca/Map/Stop/%@/Route/%@", _stopID,_busNum];
        }
    }
    webcont.hidesBottomBarWhenPushed = YES;
    [webcont setCurrentURL:send];
    
}

@end