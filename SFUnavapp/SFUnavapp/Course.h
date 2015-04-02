//
//  Course.h
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-31.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property NSString *name;
@property NSMutableString *days;
@property NSString *campus;
//No-for coursys YES-for canvas
@property BOOL location;

@end
