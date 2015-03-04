//
//  BuildingObject.h
//  SFUnavapp
//  Team NoMacs
//
//  Created by James Leong on 2015-03-03.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildingObject : NSObject

@property NSString* buildingName;
@property NSString* coordinateString;
@property UIImage* floorPlanImage;

-(id) initWithbuildingObj: (NSString *) name coordinate: (NSString *) cooString floorPlan: (UIImage *) floorImage;

@end
