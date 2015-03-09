//
//  WebcamWebViewController.h
//  SFUnavapp
//  Team NoMacs
//  Created by Arjun Rathee on 2015-02-17.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
    UIWebView custom class to handle requests to webcam files.
    Relative links are provided to the contained HTML files
 */
#import <UIKit/UIKit.h>
#import "Webcam.h"

@interface WebcamWebViewController : UIViewController

@property (nonatomic) Webcam* currentURL;

@end
