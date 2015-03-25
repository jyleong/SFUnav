//
//  NewsTableViewController.h
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-16.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "Channel.h"
#import "ServicesURL.h"
#import "ServicesWebViewController.h"
@interface NewsTableViewController : UITableViewController
@property (nonatomic,retain) List *theList;

@property (strong, nonatomic) NSMutableArray *listArray;

@property (nonatomic)Channel *channel;
@end
