//
//  CourseDetailViewController.h
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-04-03.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailViewController : UIViewController

@property NSString *courseTerm;
@property NSString *courseDept;
@property NSString *courseNumber;
@property NSString *courseSection;
@property NSString *nodePath;
@property (weak, nonatomic) NSString *courseTimesText;
@property (weak, nonatomic) NSString *instructorNameText;
@property (weak, nonatomic) NSString *examTimesText;
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UITextView *instructorName;
@property (weak, nonatomic) IBOutlet UITextView *courseTimes;
@property (weak, nonatomic) IBOutlet UITextView *examTimes;
@property (weak, nonatomic) IBOutlet UIButton *moreDetails;


@end
