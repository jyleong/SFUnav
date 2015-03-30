//
//  List.h
//  testnews2
//
//  Created by Tyler Wong on 2015-03-16.
//  Copyright (c) 2015 Tyler Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface List : NSObject
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *category;

@property (nonatomic, retain) NSString *pubDate;
@property (nonatomic, retain) NSString *contactName;
@property (nonatomic, retain) NSString *contactInfo;
@property (nonatomic, retain) NSString *addlInfoURL;
@property (nonatomic, retain) NSString *eventStartDate;
@property (nonatomic, retain) NSString *eventEndDate;
@property (nonatomic, retain) NSString *lastModified;
@property (nonatomic, retain) NSString *guid;



@end

//these are all the properties that are returned from the rss news feed. The parser stores 