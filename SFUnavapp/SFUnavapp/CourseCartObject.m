//
//  CourseCartObject.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-04-03.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "CourseCartObject.h"

@implementation CourseCartObject

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:_courseTerm forKey:@"courseTerm"];
    [encoder encodeObject:_courseDept forKey:@"courseDept"];
    [encoder encodeObject:_courseNumber forKey:@"courseNumber"];
    [encoder encodeObject:_courseSection forKey:@"courseSection"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        _courseTerm = [decoder decodeObjectForKey:@"courseTerm"];
        _courseDept = [decoder decodeObjectForKey:@"courseDept"];
        _courseNumber = [decoder decodeObjectForKey:@"courseNumber"];
        _courseSection = [decoder decodeObjectForKey:@"courseSection"];
    }
    return self;
}

@end
