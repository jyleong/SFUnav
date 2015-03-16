//
//  studContactTableViewController.h
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-14.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface studContactTableViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

- (IBAction)makeCall:(NSString *)phoneNumber;
- (IBAction)showEmail:(id)sender;
- (void)showSMS:(NSString*)recipient;

@end
