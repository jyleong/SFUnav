//
//  FloorImageViewController.m
//  SFUnavapp
//
//  Created by James Leong on 2015-03-04.
//  Edited by Arjun Rathee
//            Steven Zhou
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "FloorImageViewController.h"


@interface FloorImageViewController ()
//@property (weak, nonatomic) IBOutlet UIImageView *FloorImage;

@end

@implementation FloorImageViewController

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
    
    //self.scrollView.minimumZoomScale=0.4348;
    //self.scrollView.maximumZoomScale=0.75;
    //[_scrollView setDelegate:self];
    self.scrollView.contentSize = _FloorImage.frame.size;
    
    _FloorImage =[[UIImageView alloc] initWithImage:_currentBuilding.floorPlanImage] ;
 
    //_FloorImage.delegate=self;
    //[_FloorImage setDelegate:self];
    self.navigationItem.title = _currentBuilding.buildingName;
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self.scrollView addSubview:_FloorImage];
    
    //_scrollView.contentOffset = CGPointMake(950.0, 990.0);
    //self.scrollView.zoomScale=0.5;
    
    // 4
    //CGRect scrollViewFrame = _FloorImage.frame;
    CGFloat scaleWidth = 320 / _FloorImage.frame.size.width;
    CGFloat scaleHeight = 320 / _FloorImage.frame.size.height;
    CGFloat minScale = MAX(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    // 5
    self.scrollView.maximumZoomScale = 0.7;
    self.scrollView.zoomScale = minScale;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
}

- (void)centerScrollViewContents {
    CGSize boundsSize = _scrollView.bounds.size;
    CGRect contentsFrame = _FloorImage.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    _FloorImage.frame = contentsFrame;
}


- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:_FloorImage];
    
    // 2
    CGFloat newZoomScale = _scrollView.zoomScale * 1;
    newZoomScale = MIN(newZoomScale, _scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = _scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [_scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = _scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, _scrollView.minimumZoomScale);
    [_scrollView setZoomScale:newZoomScale animated:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return _FloorImage;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Custom deallocater called by ARC. Forcing image deallocation
-(void) dealloc
{
    
    _currentBuilding.floorPlanImage=nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/


@end
