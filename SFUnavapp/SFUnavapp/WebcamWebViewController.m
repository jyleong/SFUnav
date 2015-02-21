//
//  WebcamWebViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-02-17.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

#import "WebcamWebViewController.h"

@interface WebcamWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *currentFile;

@end

@implementation WebcamWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=_currentURL.location;
    NSURL *url = [[NSBundle mainBundle] URLForResource:_currentURL.filename withExtension:@"html"];
    [_currentFile loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)zoomToFit
{
    
    if ([_currentFile respondsToSelector:@selector(scrollView)])
    {
        UIScrollView *scroll=[_currentFile scrollView];
        
        float zoom=_currentFile.bounds.size.width/scroll.contentSize.width;
        [scroll setZoomScale:zoom animated:NO];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
