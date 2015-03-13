//
//  News.h
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-12.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property NSString* nameoffeed; 

@property NSString* inputurlstring; //

-(id) initWithappend: (NSString *) inputcategory;
    
    
-(void) parsefeed;
    
//maybe we want a for loop that takes the name of each different feed as an input, and output the appending value for the url?




-(void) determineurl:(NSString *)feedstring;
//sets the inputurl to the proper url from the string



@end
