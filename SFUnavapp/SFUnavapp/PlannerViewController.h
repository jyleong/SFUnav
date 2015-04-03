//
//  PlannerViewController.h
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-31.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlannerViewController : UITableViewController

@property NSMutableArray *semesterNames;
@property NSMutableArray *deptNames;
@property NSMutableArray *courseNames;
@property NSMutableArray *sectionNames;
@property unsigned int currentRow;
@property (weak, nonatomic) IBOutlet UIButton *courseDone;
@property (weak, nonatomic) IBOutlet UIButton *sectionDone;
@property (weak, nonatomic) IBOutlet UIButton *deptDone;
@property (weak, nonatomic) NSString *semesterChoice;
@property (weak, nonatomic) NSString *deptChoice;
@property (weak, nonatomic) NSString *courseChoice;
@property (weak, nonatomic) NSString *sectionChoice;

@end
