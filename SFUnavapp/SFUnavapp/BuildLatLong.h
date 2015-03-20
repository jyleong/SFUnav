//
//  BuildLatLong.h
//  SFUnavapp
//
//  Created by James Leong on 2015-03-20.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildLatLong : NSObject

@property NSString* buildingName;
@property double lati;
@property double longi;

-(id) initWithBuildLL: (NSString *) name latitude: (double) lat longitude: (double) longi;

@end
