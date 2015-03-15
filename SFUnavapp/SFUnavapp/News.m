//
//  News.m
//  SFUnavapp
//
//  Created by Tyler Wong on 2015-03-12.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
// NOT YET TESTED

#import "News.h"
#import "TFHpple.h"

@implementation News


-(void) determineurl:(NSString *)feedstring{
   
    
    NSArray *items = @[@"athletics",@"research studies",@"events calendar"];
            
            int item = [items indexOfObject:feedstring];
    
    switch (item){
        case 0 :
            self.inputurlstring =@"https://events.sfu.ca/rss/calendar_id/33.xml";
            break;
            
        case 1 :
        self.inputurlstring = @"https://events.sfu.ca/rss/calendar_id/15.xml";
            break;
            
        case 2 :
            self.inputurlstring = @"https://events.sfu.ca/rss/calendar_id/2.xml";
            break;
    }
  
    
}


-(void) parsefeed{
    NSString *storage;
     NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.inputurlstring]];
    
    TFHpple *xmldocument = [[TFHpple alloc]initWithHTMLData:result];
    
    //THIS ASSIGNS THE NEWS FEED TYPE TO SECTIONTITLE
    
    NSArray *sectiontitle = [xmldocument searchWithXPathQuery:@"//channel/title"];
    
    for (TFHppleElement *item in sectiontitle){
        self.sectiontitle = item.text;
    }
    
    
    //THIS TAKES THE ARTICLES AND STORES THEM IN THE NSARRAY ARTICLETITLE
    NSArray *articletitle = [xmldocument searchWithXPathQuery:@"//channel/item/title"];
    
    for (TFHppleElement *item in articletitle){
        storage = item.text;
        [self.articletitle addObject:storage];
        
        
    }

    //THIS TAKES THE ARTICLES AND STORES THEM IN THE NSARRAY ARTICLECONTENT
    
    NSArray *articles =[xmldocument searchWithXPathQuery:@"//channel/item"];
    for (TFHppleElement *item in articles){
        storage = item.text;
        [self.articlecontent addObject:storage];
    }
    
    
}



-(id) initWithnameoffeed:(NSString*)nameoffeed{
    self=[super init];
    self.nameoffeed = nameoffeed;
    self.articletitle = [[NSMutableArray alloc]init];
    
    self.articlecontent = [[NSMutableArray alloc]init];
    
  //  [self parsefeed];
    [self determineurl:self.nameoffeed];
    
    [self parsefeed];
    return self; 
    
    
}

@end
