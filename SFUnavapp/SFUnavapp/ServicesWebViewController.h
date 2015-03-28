//
//  ServicesWebViewController.h
//  SFUnavapp
//  Team NoMacs
//  Created by Arjun Rathee on 2015-02-14.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
 UIWebView Controller for displaying services with HTML URL provided
 Objects should be of type ServicesURL to use with this view
 */
#import <UIKit/UIKit.h>
#import "ServicesURL.h"
#import "ServicesTableViewController.h"
@interface ServicesWebViewController : UIViewController

@property (weak, nonatomic) ServicesURL *currentURL;

@end
