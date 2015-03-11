//
//  MapViewController.h
//  SFUnavapp
//  Team NoMacs
//
//  Created by Arjun Rathee on 2015-03-03.
//  Edited by Arjun Rathee
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
    Custom class declaration to hold container for displaying map
    ScrollView holds MTImageMapView as a subview to show a scrollable and zoomable image
 */
#import <UIKit/UIKit.h>
#import "MTImageMapView.h"
#import "FloorImageViewController.h"

extern NSMutableArray *BuildingObjects;

@interface MapViewController : UIViewController <MTImageMapDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *BuildingNames;
@property MTImageMapView *viewImageMap;
@property unsigned int currentIndex;

@end
