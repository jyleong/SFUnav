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

//SO WHEN PARSE IS CALLED, IT GOES THROUGH THE DOCUMENT, AND WHEN IT FINDS SOMETHING, DEPENDING ON WHAT IS FOUND (OPENING TAG, CLOSING TAG, CHARACTERS, CDATA), ONE OF THE FUNCTIONS BELOW WILL TRIGGER

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
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
    NSMutableString* newStr = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    currentelementvalue=newStr;
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
    /*
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
   */
    else if ([elementName isEqualToString:@"published"]){
        NSString *newString = [currentelementvalue substringToIndex:10];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        // ignore +11 and use timezone name instead of seconds from gmt
        [dateFormat setDateFormat:@"YYYY-MM-dd"];
        //[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
        NSDate *dte = [dateFormat dateFromString:newString];
        NSLog(@"Date: %@", dte);
        //NSString *dateString = [dateFormat stringFromDate:dte];
        
        // back to string
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        [dateFormat2 setDateFormat:@"ccc, MMMM-dd-YYYY"];
        //[dateFormat2 setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
        NSString *dateString = [dateFormat2 stringFromDate:dte];
        NSLog(@"DateString: %@", dateString);
        
        [thelist setValue:dateString forKey:@"pubDate"];
        currentelementvalue = nil;
        
    }
    else if ([elementName isEqualToString:@"pubDate"]){
        NSString *newString = [currentelementvalue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSString *newString = [currentelementvalue substringToIndex:10];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        // ignore +11 and use timezone name instead of seconds from gmt
        [dateFormat setDateFormat:@"ccc, dd MMM yyyy mm:ss Z"];
        //[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
        NSDate *dte = [dateFormat dateFromString:newString];
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        [dateFormat2 setDateFormat:@"ccc, MMMM-dd-yyyy "];
        //[dateFormat2 setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
        NSString *dateString = [dateFormat2 stringFromDate:dte];

        [thelist setValue:dateString forKey:@"pubDate"];
        currentelementvalue = nil;
    }
  
    else if ([elementName isEqualToString:@"summary"]){
        [thelist setValue:currentelementvalue forKey:@"description"];
        currentelementvalue = nil;
    }
    
    else{
        if (![elementName isEqualToString:@"channel"]){
            if (![elementName isEqualToString:@"id"]){
                if ([elementName isEqualToString:@"title"]|| [elementName isEqualToString:@"link"]){
                [thelist setValue:currentelementvalue forKey:elementName];
                }
            }
            currentelementvalue = nil;
        }
    }
}

-(NSMutableArray*) getlist{
    return self.listArray; 
}
@end
