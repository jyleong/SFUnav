//
//  AppDelegate.m
//  SFUnavapp
//  Team NoMacs
//  Created by James Leong on 2015-02-12.
//
//	Edited by James Leong
//	Edited by Arjun Rathee
//	Edited by <Your name>
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "AppDelegate.h"

#import "Parser.h"
// defined this to manipulate colors for navbar - James
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green: ((float)((rgbValue & 0xF00) >> 8))/255.0 blue: ((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate
@synthesize listArray;
@synthesize window = _window;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    
    
    
    //code to manipulate navbar - James B5111B
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xB5111B)];
    //changing the navbar was done by chaning the RGB
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; 
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];// changes all titles in navbar to white
    //code to manipulate tabbar - James
    //UIImage *tabBarBackground = [UIImage imageNamed:@"CustomUITabbar.png"];
    // changing the tabbar used an image
    //[[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setBarTintColor:UIColorFromRGB(0xB5111B)];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    // Override point for customization after application launch.
    
    
    
    
    
    NSString *inputurlstring =@"https://events.sfu.ca/rss/calendar_id/2.xml";
    //NSString *storage;
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:inputurlstring]];
    
    NSXMLParser *xmlparser = [[NSXMLParser alloc]initWithData:result];
    
    
    
    
    Parser *theparser = [[Parser alloc]initParser];
    
    [xmlparser setDelegate:theparser];
    
    
    BOOL worked = [xmlparser parse];
    
    if (worked){
        
        
        NSLog(@"amount %i",[listArray count]);
    }
    else{
        
        NSLog(@"boo");
    }
    
    for (int i=0; i<[listArray count]; i++){
       // NSLog( [listArray[i] title]);
        //NSLog([listArray[i] description]);
        
    }
    
    
    
    
    
    
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
