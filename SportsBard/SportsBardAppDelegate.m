//
//  SportsBardAppDelegate.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SportsBardAppDelegate.h"
#import "MainViewController.h"
#import "SportSelectionViewController.h"
#import "GamesViewController.h"

@interface SportsBardAppDelegate ()
@property(strong, nonatomic) UINavigationController *mainNavController;
@property(strong, nonatomic) MainViewController *mainViewController;
@property(strong, nonatomic) SportSelectionViewController *sportSelectionViewController;
@property(strong, nonatomic) GamesViewController *gamesViewController;
@end

@implementation SportsBardAppDelegate

@synthesize window = _window;
@synthesize mainNavController;
@synthesize mainViewController;
@synthesize sportSelectionViewController;
@synthesize gamesViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleLoginSuccess:) name:LoginSuccessNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleSportSelected:) name:SportSelectedNotification object:nil];
	
	//self.mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
	//[self.window addSubview:self.mainViewController.view];
	[self _handleSportSelected:nil];
	
    return YES;
}

- (void)_handleLoginSuccess:(NSNotification *)inNotification {
	[self.mainViewController.view removeFromSuperview];
	
	self.sportSelectionViewController = [[SportSelectionViewController alloc] initWithNibName:nil bundle:nil];
	[self.window addSubview:self.sportSelectionViewController.view];
}

- (void)_handleSportSelected:(NSNotification *)inNotification {
	[self.sportSelectionViewController.view removeFromSuperview];
	
	self.gamesViewController = [[GamesViewController alloc] initWithNibName:nil bundle:nil];
	[self.gamesViewController setTitle:@"SportsBard"];
	
	self.mainNavController = [[UINavigationController alloc] initWithRootViewController:self.gamesViewController];
	
	[self.window addSubview:self.mainNavController.view];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
