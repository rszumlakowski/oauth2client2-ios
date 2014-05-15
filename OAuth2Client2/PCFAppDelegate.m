//
//  PCFAppDelegate.m
//  OAuth2Client2
//
//  Created by Rob Szumlakowski on 2014-05-15.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFAppDelegate.h"
#import <NXOAuth2Client/NXOAuth2.h>

@implementation PCFAppDelegate

+ (void)initialize;
{
    [[NXOAuth2AccountStore sharedStore] setClientID:@"947045348411-lf2k2rpp7gmhgonthk2l39221ei36ugq.apps.googleusercontent.com"
                                             secret:@"cYvu_h-koYhJYYzKk7aEXpxr"
                                              scope:[NSSet setWithArray:@[@"profile", @"email"]]
                                   authorizationURL:[NSURL URLWithString:@"https://accounts.google.com/o/oauth2/auth"]
                                           tokenURL:[NSURL URLWithString:@"https://accounts.google.com/o/oauth2/token"]
                                        redirectURL:[NSURL URLWithString:@"https://mobile.cf.pivotal.com/oauth2callback"]
                                     forAccountType:@"Google"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Google"
//                                                              username:@"rszumlakowski@pivotallabs.com"
//                                                              password:@"nxjufsefhoavneuo"];
//    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Google"];
    
    
    
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Received url '%@'", url);
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
