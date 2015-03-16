//
//  CampusContactsViewController.h
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-01.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampusContactsViewController : UIViewController <UIAlertViewDelegate> 
// segmented button
@property (strong, nonatomic) IBOutlet UIView *burnabyView;
@property (strong, nonatomic) IBOutlet UIView *surreyView;
@property (strong, nonatomic) IBOutlet UIView *vancouverView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedValueChange:(id)sender;
- (IBAction)makeCall:(id)sender;


@end
