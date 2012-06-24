//
//  DataRequester.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataRequester.h"

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
	
	NSLog(@"%@", responseString);
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog(@"%@", error);
}

@end
