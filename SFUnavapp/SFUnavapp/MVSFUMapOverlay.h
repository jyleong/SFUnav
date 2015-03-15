//
//  MVSFUMapOverlay.h
//  SFUnavapp
//
//  Created by James Leong on 2015-03-15.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class MVSFU;

@interface MVSFUMapOverlay : NSObject <MKOverlay>

- (instancetype)initWithSFU:(MVSFU *)sfum;

@end