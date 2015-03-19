//
//  NewsWebViewController.h
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-18.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"

@interface NewsWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *Newswebview;

@property (nonatomic) List *currentURL;

@end
