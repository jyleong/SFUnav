//
//  PlannerViewController.h
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-31.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlannerViewController : UITableViewController
@property NSMutableArray *deptNames;
@property NSMutableArray *courseNames;
@property NSMutableArray *sectionNames;
@property unsigned int currentRow;
@property (strong, nonatomic) IBOutlet UIButton *courseDone;
@property (strong, nonatomic) IBOutlet UIButton *sectionDone;

@end
