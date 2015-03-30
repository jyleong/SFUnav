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
    //NSLog(@"found element");
    //NSLog(elementName);
    
   // NSLog(attributeDict.description);
    //rss and item is for events
    if ([elementName isEqualToString:@"rss"]){
        listArray = [[NSMutableArray alloc]init];
        //NSLog(@"BEGIN");
    }
    
    else if ([elementName isEqualToString:@"feed"]){
        listArray = [[NSMutableArray alloc]init];
        //NSLog(@"BEGIN");
    }
    
    
    
    else if ([elementName isEqualToString:@"item"]){
        thelist = [[List alloc]init];
       // NSLog(@"foundITEM");
    }
    
    else if ([elementName isEqualToString:@"entry"]){
        thelist = [[List alloc]init];
    }
    else if ([elementName isEqualToString:@"link"]){
        
        NSString *linkstring = attributeDict.description;
        NSScanner *scanner = [NSScanner scannerWithString:linkstring];
        NSString *tmp;
        
        while ([scanner isAtEnd] == NO)
        {
            [scanner scanUpToString:@"\"" intoString:NULL];
            [scanner scanString:@"\"" intoString:NULL];
            [scanner scanUpToString:@"\"" intoString:&tmp];
            
            [scanner scanString:@"\"" intoString:NULL];
        }
       
        if (currentelementvalue== nil){
            currentelementvalue = [[NSMutableString alloc]initWithString:tmp];
        //[currentelementvalue appendString:tmp];
        }
        
    }
    
   
}


-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if (!currentelementvalue){
        
        
        
        
        currentelementvalue = [[NSMutableString alloc]initWithString:string];
    }
    else{
   
        [currentelementvalue appendString:string];
    }
}

-(void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    
    //NSLog(@"FOUND CDATA");
    NSMutableString* newStr = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    currentelementvalue=newStr;
  //  NSLog(newStr);
    
    
}


-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"rss"]){
        //NSLog(@"END");
        return;
    }
    
    if ([elementName isEqualToString:@"item" ]||[elementName isEqualToString:@"entry"]){
        [listArray addObject:thelist];
       thelist = nil;
    }
    
    else if ([elementName isEqualToString:@"cdaily:contactName"]||[elementName isEqualToString:@"name"]){
        [thelist setValue:currentelementvalue forKey:@"contactName"];
        currentelementvalue = nil;
    }
    
    else if ([elementName isEqualToString:@"cdaily:contactInfo" ] || [elementName isEqualToString:@"email"]){
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
    else if ([elementName isEqualToString:@"cdaily:lastModified" ]||[elementName isEqualToString:@"updated"]){
        [thelist setValue:currentelementvalue forKey:@"lastModified"];
        currentelementvalue = nil;
        
    }
   
    else if ([elementName isEqualToString:@"published"]){
        [thelist setValue:currentelementvalue forKey:@"pubDate"];
        currentelementvalue = nil;
        
    }
    else if ([elementName isEqualToString:@"summary"]){
        [thelist setValue:currentelementvalue forKey:@"description"];
        currentelementvalue = nil;
        
    }
  

    else{
        if (![elementName isEqualToString:@"channel"]){
            
            
            if (![elementName isEqualToString:@"id"]){

                [thelist setValue:currentelementvalue forKey:elementName];
            }
        currentelementvalue = nil;
        }
    }
}

-(NSMutableArray*) getlist{
    return self.listArray; 
}



@end
