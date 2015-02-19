//
//  TransitTableViewController.h
//  SFUnavapp
//
//  Created by James Leong on 2015-02-18.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitTableViewController : UITableViewController <UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic)NSDictionary *busStopID;
@property (strong, nonatomic) NSArray *busNumbers;

@end
