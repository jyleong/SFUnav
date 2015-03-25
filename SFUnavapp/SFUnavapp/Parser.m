//
//  Parser.m
//  testingurls
//
//  Created by Tyler Wong on 2015-03-15.
//  Copyright (c) 2015 Tyler Wong. All rights reserved.
//

#import "Parser.h"
@implementation Parser


@synthesize listArray;
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"rss"]){
        listArray = [[NSMutableArray alloc]init];
        //NSLog(@"BEGIN");
    }
    else if ([elementName isEqualToString:@"item"]){
        thelist = [[List alloc]init];
       // NSLog(@"foundITEM");
    }
   
}


-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (!currentelementvalue){
        currentelementvalue = [[NSMutableString alloc]initWithString:string];
    }
    else{
       // NSLog(string);
        [currentelementvalue appendString:string];
    }
}

-(void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    
    //NSLog(@"FOUND CDATA");
    NSMutableString* newStr = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    currentelementvalue=newStr;
  //  NSLog(newStr);
    
    
}


-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"rss"]){
        //NSLog(@"END");
        return;
    }
    
    if ([elementName isEqualToString:@"item"]){
        [listArray addObject:thelist];
       thelist = nil;
    }
    
    else if ([elementName isEqualToString:@"cdaily:contactName"]){
        [thelist setValue:currentelementvalue forKey:@"contactName"];
        currentelementvalue = nil;
    }
    
    else if ([elementName isEqualToString:@"cdaily:contactInfo"]){
        [thelist setValue:currentelementvalue forKey:@"contactInfo"];
        currentelementvalue = nil;
        
    }
    else if ([elementName isEqualToString:@"cdaily:addlInfoURL"]){
        [thelist setValue:currentelementvalue forKey:@"addlInfoURL"];
        currentelementvalue = nil;
        
    }
    else if ([elementName isEqualToString:@"cdaily:eventStartDate"]){
        [thelist setValue:currentelementvalue forKey:@"eventStartDate"];
        currentelementvalue = nil;
        
    }
    else if ([elementName isEqualToString:@"cdaily:eventEndDate"]){
        [thelist setValue:currentelementvalue forKey:@"eventEndDate"];
        currentelementvalue = nil;
        
    }
    else if ([elementName isEqualToString:@"cdaily:lastModified"]){
        [thelist setValue:currentelementvalue forKey:@"lastModified"];
        currentelementvalue = nil;
        
    }
    
    else{
        if (![elementName isEqualToString:@"channel"]){
        [thelist setValue:currentelementvalue forKey:elementName];
        currentelementvalue = nil;
        }
    }
}

-(NSMutableArray*) getlist{
    return self.listArray; 
}



@end
