//
//  MVSFUMapOverlay.m
//  SFUnavapp
//
//  Created by James Leong on 2015-03-15.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "MVSFUMapOverlay.h"
#import "MVSFU.h"

@implementation MVSFUMapOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithSFU:(MVSFU *)sfum {
    self = [super init];
    if (self) {
        boundingMapRect = sfum.overlayBoundingMapRect;
        coordinate = sfum.midCoordinate;
    }
    
    return self;
}

@end
