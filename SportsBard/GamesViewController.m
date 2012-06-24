//
//  GamesViewController.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamesViewController.h"
#import "GameTableViewCell.h"
#import "SingleGameViewController.h"
#import "SBJson.h"
#import "AddGameViewController.h"

@interface GamesViewController ()
@property(strong, nonatomic) UILabel *dateLbl;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) SocketIO *socket;
@property(strong, nonatomic) UIView *backView;
@property(strong, nonatomic) UIImageView *backImage;
@end

@implementation GamesViewController

@synthesize dateLbl;
@synthesize tableView;
@synthesize gameData;
@synthesize socket;
@synthesize backView;
@synthesize backImage;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
		self.gameData = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
	self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	
	self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[self.backImage setImage:[UIImage imageNamed:@"background_fade.png"]];
	[self.backView addSubview:self.backImage];

	UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	[header setBackgroundColor:[UIColor clearColor]];
	[self.backView addSubview:header];
	
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 150, 40)];
	[self.dateLbl setBackgroundColor:[UIColor clearColor]];
	[self.dateLbl setText:[dateFormatter stringFromDate:today]];
	[self.dateLbl setTextColor:[UIColor blackColor]];
	[self.dateLbl setTextAlignment:UITextAlignmentCenter];
	[self.dateLbl setFont:[UIFont boldSystemFontOfSize:18.0]];
	[self.backView addSubview:self.dateLbl];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.dateLbl.frame.origin.y + self.dateLbl.frame.size.height, 320, (480 - (self.dateLbl.frame.origin.y + self.dateLbl.frame.size.height))) style:UITableViewStylePlain];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	[self.backView addSubview:self.tableView];
	
	// Add the invite image inside of a larger view that will push the image a little more to the right
    UIView *inviteContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 25)];
    [inviteContainer setBackgroundColor:[UIColor clearColor]];
	
	UIButton *inviteImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteImage setFrame:CGRectMake(10, 0, 25, 25)];
    [inviteImage setImage:[UIImage imageNamed:@"invite_button.png"] forState:UIControlStateNormal];
    [inviteImage addTarget:self action:@selector(_addGamePressed:) forControlEvents:UIControlEventTouchUpInside];
	[inviteContainer addSubview:inviteImage];
	
    UIBarButtonItem *inviteBarBtn = [[UIBarButtonItem alloc] initWithCustomView:inviteContainer];
    self.navigationItem.leftBarButtonItem = inviteBarBtn; 
	
	self.view = self.backView;
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *singleGame = [self.gameData objectAtIndex:indexPath.row];
	SingleGameViewController *singleGameVC = [[SingleGameViewController alloc] initWithNibName:@"SingleGameViewController" bundle:nil];
	[singleGameVC setGameData:singleGame];
	
	[self.navigationController pushViewController:singleGameVC animated:YES];
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *singleGame = [self.gameData objectAtIndex:indexPath.row];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[singleGame objectForKey:@"gameid"] forKey:@"gameid"];
	[dict setObject:[singleGame objectForKey:@"awayteam"] forKey:@"team"];
	[dict setObject:@"3" forKey:@"score"];
	
	[self.socket sendEvent:@"scoreupdate" withData:dict];
}
 */

- (void)_addGamePressed:(id)sender {
	NSLog(@"Add game");
	
	AddGameViewController *addGame = [[AddGameViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:addGame animated:YES];
}

@end
