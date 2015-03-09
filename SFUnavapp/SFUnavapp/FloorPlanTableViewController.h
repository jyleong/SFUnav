//
//  FloorPlanTableViewController.h
//  SFUnavapp
//  Team NoMacs
//
//  Created by James Leong on 2015-03-03.
//  Edited by Arjun Rathee
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
    container for displaying floorplan search results.
 */

#import <UIKit/UIKit.h>
#import "BuildingObject.h"

@interface FloorPlanTableViewController : UITableViewController <UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *BuildingObjects; //mutable array that holds CUSTOM OBJETS
@property (nonatomic, strong) NSMutableArray *searchResult; //mutable array that holds results STRINGS

@end
