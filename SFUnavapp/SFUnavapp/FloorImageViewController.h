//
//  FloorImageViewController.h
//  SFUnavapp
//
//  Created by James Leong on 2015-03-04.
//  Edited by Arjun Rathee
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
    ViewController to display floorplans as scrollable and zoomable images
    ImageView is loaded as a subview to the scrollview to allow zooming and scrolling
 */
#import <UIKit/UIKit.h>
#import "BuildingObject.h"

@interface FloorImageViewController : UIViewController

@property (nonatomic) BuildingObject *currentBuilding;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIImageView *FloorImage;
- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

