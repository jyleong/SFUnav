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

-(id) initWithbuildingObj: (NSString *) name floorPlan: (UIImage *) floorImage {
    self = [super init];
    self.buildingName = name;
    self.floorPlanImage = floorImage;
    return self;
}

@end
