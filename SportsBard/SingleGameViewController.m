//
//  SingleGameViewController.m
//  SportsBard
//
//  Created by Administrator on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleGameViewController.h"
#import "SBJson.h"

@interface SingleGameViewController ()
@property(strong, nonatomic) SocketIO *socket;
@end

@implementation SingleGameViewController

@synthesize inningsButton, homeTeamButton, awayTeamButton, gameData, socket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.socket = [[SocketIO alloc] initWithDelegate:self];
	[self.socket connectToHost:@"localhost" onPort:8080];
	
	NSString *awayteam = [self.gameData objectForKey:@"awayteam"];
	NSString *hometeam = [self.gameData objectForKey:@"hometeam"];
	NSString *date = [self.gameData objectForKey:@"date"];
	NSNumber *inning = [self.gameData objectForKey:@"inning"];
	NSNumber *awayscore = [self.gameData objectForKey:@"awayscore"];
	NSNumber *homescore = [self.gameData objectForKey:@"homescore"];
	
	if([awayscore integerValue] == -1) {
		awayscore = [NSNumber numberWithInt:0];
	}
	
	if([homescore integerValue] == -1) {
		homescore = [NSNumber numberWithInt:0];
	}
	
	NSString *awayTeamScore = [NSString stringWithFormat:@"%@ %@", [awayteam uppercaseString], awayscore, [hometeam uppercaseString], homescore];
	NSString *homeTeamScore = [NSString stringWithFormat:@"%@ %@", [hometeam uppercaseString], homescore];
	
    // Do any additional setup after loading the view from its nib.
	[self.inningsButton setTitle:[inning stringValue] forState:UIControlStateNormal];
	[self.homeTeamButton setTitle:homeTeamScore forState:UIControlStateNormal];
	[self.awayTeamButton setTitle:awayTeamScore	forState:UIControlStateNormal];
}

- (IBAction)clickAwayScore:(id)sender {
	NSLog(@"Increase away score");
}

- (IBAction)clickHomeScore:(id)sender {
	NSLog(@"Increase home score");	
}

- (IBAction)clickInning:(id)sender {
	NSLog(@"Increase inning");
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSLog(@"didReceiveMessage() >>> data: %@", packet.data);
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
	NSLog(@"didReceiveEvent() >>> data: %@", packet.data);
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSDictionary *eventData = [parser objectWithString:packet.data];
	
	if(eventData && [[eventData objectForKey:@"name"] isEqualToString:@"scoreupdated"]) {
		NSArray *dataArr = [eventData objectForKey:@"args"];
		NSDictionary *dataDict = [dataArr objectAtIndex:0];
		
		NSLog(@"data is %@", dataDict);
		self.gameData = dataDict;
		[self.view setNeedsLayout];
	}
}

@end
