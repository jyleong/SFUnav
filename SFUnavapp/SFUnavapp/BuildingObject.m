//
//  BuildingObject.m
//  SFUnavapp
//  Team NoMacs
//
//  Created by James Leong on 2015-03-03.
//  Edited by Arjun Rathee
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "BuildingObject.h"

@implementation BuildingObject

-(id) initWithbuildingObj: (NSString *) name coordinate: (NSString *) cooString floorPlan: (UIImage *) floorImage {
    self = [super init];
    self.buildingName = name;
    self.coordinateString = cooString;
    self.floorPlanImage = floorImage;
    return self;
}

//BuildingObject *AQ = [[BuildingObject alloc] initWithbuildingObj:@"Applied Science Building" coordinate:@"4006,1434,4006,1219,3767,1219,3767,1358,3836,1358,3836,1434" floorPlan:[UIImage imageNamed:@"dial.png"]];

@end
