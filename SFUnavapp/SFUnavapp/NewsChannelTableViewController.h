//
//  NewsChannelTableViewController.h
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-20.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Channel.h"
@interface NewsChannelTableViewController : UITableViewController
@property Channel *currentchannel; 


@property NSMutableArray * channelList; 
@end
