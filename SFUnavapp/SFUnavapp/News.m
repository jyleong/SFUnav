//
//  News.m
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-12.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "News.h"

@implementation News


-(void) determineurl:(NSString *)feedstring{
    //we need to write code that modifies
    self.inputurlstring = @"haha";
    
}







-(void) parsefeed{
    
    
    
    
    
    
}



-(id) initWithappend:(NSString*)feedstring{
    self=[super init];
    self.nameoffeed = feedstring;
    
  //  [self parsefeed];
    [self determineurl:self.nameoffeed];
    
    [self parsefeed];//AT THIS POINT, THE
    return self; 
    
    
}

@end
