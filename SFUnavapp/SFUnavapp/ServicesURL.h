//
//  ServicesURL.h
//  SFUnavapp
//  Team NoMacs
//  Created by Arjun Rathee on 2015-02-14.
//
//	Edited by Arjun Rathee
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
    Holds URL and Service Name to be loaded into the Services WebView controller
    Both properties must be defined for proper functioning
 */
#import <Foundation/Foundation.h>

@interface ServicesURL : NSObject
@property NSString* serviceName;
@property NSString* serviceURL;
@end
