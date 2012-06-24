//
//  DataRequester.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataRequester.h"
#import "SBJson.h"

NSString * const GamesDownloadedNotification = @"GamesDownloadedNotification";

@implementation DataRequester

@synthesize gamesData;

- (id)init {
	self = [super init];
	if (self) {
		self.gamesData = [NSMutableArray alloc];
	}
	
	return self;
}

- (void)requestGamesData {
	NSURL *url = [NSURL URLWithString:@"http://sportsbard.jit.su/games"];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	// Use when fetching text data
	NSString *responseString = [request responseString];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	self.gamesData = [parser objectWithString:responseString];
	
	NSLog(@"%@", self.gamesData);
	
	NSNotification *notification = [NSNotification notificationWithName:GamesDownloadedNotification object:self.gamesData];
    [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) onThread:[NSThread mainThread] withObject:notification waitUntilDone:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog(@"%@", error);
}

@end
