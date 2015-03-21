//
//  Channel.m
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-20.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "Channel.h"

@implementation Channel
//@synthesize channelurl,channelName;
-(id) initWithchannelname:(NSString *)channelname andlink:(NSString *)channelurl{
    
    
    self = [super init];
    
    self.channelName = channelname;
    self.channelurl = channelurl;
    return self; 
}

@end
