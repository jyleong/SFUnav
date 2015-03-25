//
//  Parser.h
//  testingurls
//
//  Created by Tyler Wong on 2015-03-15.
//  Copyright (c) 2015 Tyler Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"
@interface Parser : NSObject<NSXMLParserDelegate>{
    List *thelist;
    NSMutableString *currentelementvalue;
  
    int count; 
}

@property NSMutableArray* listArray;
-(NSMutableArray *) getlist; 

@end
