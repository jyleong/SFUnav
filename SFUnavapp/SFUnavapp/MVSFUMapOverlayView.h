//
//  MVSFUMapOverlayView.h
//  SFUnavapp
//
//  Created by James Leong on 2015-03-15.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MVSFUMapOverlayView : MKOverlayPathRenderer

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end
