//
//  MVSFU.m
//  SFUnavapp
//
//  Created by James Leong on 2015-03-15.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "MVSFU.h"

@implementation MVSFU

- (instancetype)initWithFilename:(NSString *)filename {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        CGPoint midPoint = CGPointFromString(properties[@"midCoord"]);
        _midCoordinate = CLLocationCoordinate2DMake(midPoint.x, midPoint.y);
        
        CGPoint overlayTopLeftPoint = CGPointFromString(properties[@"overlayTopLeftCoord"]);
        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(overlayTopLeftPoint.x, overlayTopLeftPoint.y);
        
        CGPoint overlayTopRightPoint = CGPointFromString(properties[@"overlayTopRightCoord"]);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(overlayTopRightPoint.x, overlayTopRightPoint.y);
        
        CGPoint overlayBottomLeftPoint = CGPointFromString(properties[@"overlayBottomLeftCoord"]);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(overlayBottomLeftPoint.x, overlayBottomLeftPoint.y);
        
    }
    
    return self;
}

- (CLLocationCoordinate2D)overlayBottomRightCoordinate {
    return CLLocationCoordinate2DMake(self.overlayBottomLeftCoordinate.latitude, self.overlayTopRightCoordinate.longitude);
}

- (MKMapRect)overlayBoundingMapRect {
    
    MKMapPoint topLeft = MKMapPointForCoordinate(self.overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(self.overlayTopRightCoordinate);
    MKMapPoint bottomLeft = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate);
    
    return MKMapRectMake(topLeft.x,
                         topLeft.y,
                         fabs(topLeft.x - topRight.x),
                         fabs(topLeft.y - bottomLeft.y));
    NSLog(@"made rectangle");
}

@end
