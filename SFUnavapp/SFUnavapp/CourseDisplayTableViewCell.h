//
//  CourseDisplayTableViewCell.h
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-04-01.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDisplayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *campusLocation;
@property (weak, nonatomic) IBOutlet UIButton *mondayButton;
@property (weak, nonatomic) IBOutlet UIButton *tuesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *wednesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *thursdayButton;
@property (weak, nonatomic) IBOutlet UIButton *fridayButton;

@end
