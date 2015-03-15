//
//  MVSFUMapOverlayView.m
//  SFUnavapp
//
//  Created by James Leong on 2015-03-15.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "MVSFUMapOverlayView.h"

@interface MVSFUMapOverlayView()

@property (nonatomic, strong) UIImage *overlayImage;

@end

@implementation MVSFUMapOverlayView

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage {
    self = [super initWithOverlay:overlay];
    if(self) {
        _overlayImage = overlayImage;
    }
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    CGImageRef imageReference = self.overlayImage.CGImage;
    
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
}

@end

