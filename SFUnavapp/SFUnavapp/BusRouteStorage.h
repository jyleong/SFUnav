//
//  BusRouteStorage.h
//  SFUnavapp
//  Team NoMacs
//  Created by Tyler Wong on 2015-02-26.
//
//	Edited by James Leong
//	Edited by Tyler Wong
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"

@interface BusRouteStorage : NSObject
@property NSString *routnumber;//INPUT ROUTE NUMBER (OPTIONAL, COULD BE BLANK) the 3 digits
@property NSString *busstopid;//INPUT STOP NUMBER (COMPULSORY) the 5 digits
// holds the returned bus routes
@property NSMutableDictionary *dictionary; // DICTIONARY OBJECT THAT HOLDS ROUTES ALONG WITH THE TIMES
@property NSMutableArray *busroutereturnvalues;// THE LIST OF BUS ROUTES THAT COME THROUGH THE INPUTTED STOP

// first field for 3 digit, next field for 5 digit
-(id) initWithbusroute: (NSString *) routenumber andbusid: (NSString *) busid;

//-(void) printhello;

-(void) updatebustimes;
@end
