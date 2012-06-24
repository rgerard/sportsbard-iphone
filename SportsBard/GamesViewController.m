//
//  GamesViewController.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamesViewController.h"
#import "GameTableViewCell.h"
#import "SBJson.h"

@interface GamesViewController ()
@property(strong, nonatomic) UILabel *dateLbl;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) SocketIO *socket;
@end

@implementation GamesViewController

@synthesize dateLbl;
@synthesize tableView;
@synthesize gameData;
@synthesize socket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.gameData = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[view setBackgroundColor:[UIColor whiteColor]];

	UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	[header setBackgroundColor:[UIColor blackColor]];
	[view addSubview:header];
	
	self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 40)];
	[self.dateLbl setBackgroundColor:[UIColor clearColor]];
	[self.dateLbl setText:@"Date"];
	[self.dateLbl setTextColor:[UIColor whiteColor]];
	[self.dateLbl setFont:[UIFont boldSystemFontOfSize:18.0]];
	[view addSubview:self.dateLbl];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.dateLbl.frame.origin.y + self.dateLbl.frame.size.height, 320, (480 - (self.dateLbl.frame.origin.y + self.dateLbl.frame.size.height))) style:UITableViewStylePlain];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[view addSubview:self.tableView];
	
	self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.socket = [[SocketIO alloc] initWithDelegate:self];
	[self.socket connectToHost:@"localhost" onPort:8080];
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
		
		// Find the game to update
		NSString *gameid = [dataDict objectForKey:@"gameid"];
		NSInteger foundGame = -1;
		for(int i=0; i < [self.gameData count]; i++) {
			NSDictionary *game = [self.gameData objectAtIndex:i];
			if([[game objectForKey:@"gameid"] isEqualToString:gameid]) {
				foundGame = i;
				break;
			}
		}
		
		if(foundGame != -1) {
			[self.gameData replaceObjectAtIndex:foundGame withObject:dataDict];
			[self.tableView reloadData];
		}
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [self.gameData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    GameTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	NSDictionary *singleGame = [self.gameData objectAtIndex:indexPath.row];
	[cell setGameData:singleGame];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *singleGame = [self.gameData objectAtIndex:indexPath.row];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[singleGame objectForKey:@"gameid"] forKey:@"gameid"];
	[dict setObject:[singleGame objectForKey:@"awayteam"] forKey:@"team"];
	[dict setObject:@"3" forKey:@"score"];
	
	[self.socket sendEvent:@"scoreupdate" withData:dict];
}

@end
