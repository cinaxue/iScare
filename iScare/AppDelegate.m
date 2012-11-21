//
//  AppDelegate.m
//  iScare
//
//  Created by Cina on 8/6/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import "AppDelegate.h"

#import "DrawingViewController.h"
#import "UserInfoViewController.h"
#import "iScareListViewController.h"
#import "FollowUPViewController.h"


@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    DrawingViewController *drawingViewController = [[[DrawingViewController alloc] initWithNibName:@"DrawingViewController" bundle:nil] autorelease];
    
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:drawingViewController] autorelease];
    
    UserInfoViewController *userInfoViewController = [[[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil] autorelease];
    
    UINavigationController *navigationController1 = [[[UINavigationController alloc] initWithRootViewController:userInfoViewController] autorelease];
    
    iScareListViewController *iscareListViewController = [[[iScareListViewController alloc] initWithNibName:@"iScareListViewController" bundle:nil] autorelease];
    
    UINavigationController *navigationController2 = [[[UINavigationController alloc] initWithRootViewController:iscareListViewController] autorelease];

    FollowUPViewController *followUPViewController = [[[FollowUPViewController alloc] initWithNibName:@"FollowUPViewController" bundle:nil] autorelease];
    
    UINavigationController *navigationController3 = [[[UINavigationController alloc] initWithRootViewController:followUPViewController] autorelease];

    drawingViewController.title = @"iScare";
    userInfoViewController.title= @"Settings";
    iscareListViewController.title= @"Top keep-fitter";
    followUPViewController.title= @"Analyse";

    UITabBarController *metalTabbar =[[[UITabBarController alloc] init] autorelease];
    metalTabbar.viewControllers = [NSArray arrayWithObjects:navigationController,navigationController2,navigationController3, navigationController1,nil];
    
    self.window.rootViewController = metalTabbar;
    [self.window makeKeyAndVisible];
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
