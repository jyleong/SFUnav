//
//  AppDelegate.m
//  SFUnavapp
//
//  Created by James Leong on 2015-02-12.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

#import "AppDelegate.h"
// defined this to manipulate colors for navbar - James
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green: ((float)((rgbValue & 0xF00) >> 8))/255.0 blue: ((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate

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
    return YES;
}

//added by James - copied from XMl parsing tutorial http://www.appcoda.com/parse-xml-and-json-web-service/
//may delete if we decide to use hpple
+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %d", HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
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
