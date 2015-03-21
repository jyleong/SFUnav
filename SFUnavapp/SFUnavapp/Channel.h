//
//  Channel.h
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-20.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject


@property NSString *channelurl;
@property NSString *channelName;


-(id) initWithchannelname: (NSString *)channelname andlink: (NSString*) channelurl;
@end
