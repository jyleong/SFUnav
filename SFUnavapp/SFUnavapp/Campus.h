//
//  Campus.h
//  SFUnavapp
//  Team NoMacs
//  Created by Arjun Rathee on 2015-02-20.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
    Class to handle the HTML parsing information for each campus
    Data values are set to NODATA when not applicable (e.g: translink and road for Surrey and Vancouver Campus
 */
#import <Foundation/Foundation.h>

@interface Campus : NSObject

@property  NSString* name;
@property  NSString* status;
@property  NSString* ClassExam;
@property  NSString* translink;
@property  NSString* road;

@end
