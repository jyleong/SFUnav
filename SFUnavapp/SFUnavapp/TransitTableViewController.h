//
//  TransitTableViewController.h
//  SFUnavapp
//  Team NoMacs
//  Created by James Leong on 2015-02-18.
//
//	Edited by James Leong
//	Edited by <Your name>
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitTableViewController : UITableViewController <UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic)NSDictionary *busStopID; // these two are what goes into pickerview
@property (strong, nonatomic) NSArray *busNumbers;

@end
