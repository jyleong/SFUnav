//
//  BusRouteStorage.m
//  SFUnavapp
//  Team NoMacs
//  Created by Tyler Wong on 2015-02-26.
//
//	Edited by James Leong
//	Edited by Tyler Wong
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "BusRouteStorage.h"

@implementation BusRouteStorage

/*-(void) printhello{
    NSLog(@"helloworld");
}*/

//this method is called when the object is initiated. It will take the parameters of the bus stop number and bus route requested, and add entries to the dictionary properties with the buses servicing that stop and the times they will come.
-(void) updatebustimes{
    /*
     NSString *result = [NSString stringWithFormat:@"http://api.translink.ca/rttiapi/v1/stops/%@/estimates?apikey=Inm4xjwOOLahxETIK89R &count=3&timeframe=60&routeNo=%@",self.busstopid, self.routnumber];
     */
    
    
    // NSMutableArray *busnumberarray = [[NSMutableArray alloc] initWithCapacity:0];
    //NSMutableArray *bustimearray; //= [[NSMutableArray alloc] initWithCapacity:0];
    //NSString *test;
    NSString *info;
    NSString *routeinfo;
    /*
     NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://api.translink.ca/rttiapi/v1/stops/59044/estimates?apikey=Inm4xjwOOLahxETIK89R&count=3&timeframe=60&routeNo="]];
     */
    //setting up URL connection
    NSString *inputurlstring=[NSString stringWithFormat:@"http://api.translink.ca/rttiapi/v1/stops/%@/estimates?apikey=Inm4xjwOOLahxETIK89R&count=3&timeframe=60&routeNo=%@",self.busstopid,self.routnumber];
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:inputurlstring]];
    
    
    //PARSES HTML DOCUMENT
    TFHpple *haha = [[TFHpple alloc]initWithHTMLData:result];
    NSArray *busnumber = [haha searchWithXPathQuery:@"//nextbus/routeno"];
    
    //LOOPS THROUGH ALL THE BUS ROUTES THAT WILL COME, AND WILL RETURN THE TIMES ALONG WITH THE ROUTES IN DICTIONARY OBJECT
    for (TFHppleElement *item in busnumber)
    {   //write log
        NSMutableArray *bustimearray = [[NSMutableArray alloc] initWithCapacity:0];
        //NSString *output = item.tagName;
        //NSLog(output);
        routeinfo=item.text;
        //NSLog(info);
        [self.busroutereturnvalues addObject:routeinfo];//this should create the array of busroutes servicing at the given busstopnumber
        
        NSString *query = [NSString stringWithFormat:@"//nextbus[routeno=%@]/schedules/schedule/expectedleavetime",routeinfo];
        NSMutableArray *expleavetime = [haha searchWithXPathQuery:query];
        
        
        //this loops through the
        for (TFHppleElement *item in expleavetime)
        {   //write log
            //NSString *output = item.tagName;
            //NSLog(output);
            info=item.text;
            //NSLog(info);
            [bustimearray addObject:info];
        }
        
        //create a temporary dictionary of 1 entry, attatch the bus times to that entry, and attatch the temporary dictionary to the main dictionary.
        NSMutableDictionary *tempdictionary = [[NSMutableDictionary alloc] init];
        [tempdictionary setObject:bustimearray forKey:routeinfo];
        [self.dictionary addEntriesFromDictionary:tempdictionary];
        
        
        
    }
    /*
     NSArray *expleavetime = [haha searchWithXPathQuery:@"//nextbus/schedules/schedule/expectedleavetime"];
     
     
     
     for (TFHppleElement *item in expleavetime)
     {   //write log
     NSString *output = item.tagName;
     NSLog(output);
     info=item.text;
     NSLog(info);
     [bustimearray addObject:info];
     }
     
     
     
     NSLog(@"PRINTING");
     
     for (NSString *i in bustimearray){
     test=i;
     NSLog(test);
     
     
     }
     
     for (NSString *i in busnumberarray){
     test=i;
     NSLog(test);
     
     
     }
     
     */
    
}


//CODE THAT WILL BE USED TO INSTANTIATE THE OBJECT
-(id) initWithbusroute: (NSString *) routenumber andbusid: (NSString *) busid{
    self=[super init];
    self.routnumber=routenumber;
    self.busstopid = busid;
    self.dictionary = [[NSMutableDictionary alloc] init];
    self.busroutereturnvalues = [[NSMutableArray alloc] init] ;
    [self updatebustimes];
    return self;
}

@end
