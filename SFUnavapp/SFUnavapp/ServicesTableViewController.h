//
//  ServicesTableViewController.h
//  SFUnavapp
//  Team NoMacs
//  Created by James Leong on 2015-02-12.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
 Custom UITableViewController class declaration to hold the names of online services
 and perform segue action on cell selection
 */
#import <UIKit/UIKit.h>
#import "ServicesURL.h"
#import "ServicesWebViewController.h"

extern NSString *username;
extern NSString *password;
extern BOOL autoLogin;

@interface ServicesTableViewController : UITableViewController

@end
