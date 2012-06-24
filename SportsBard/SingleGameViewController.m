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
@property (strong, nonatomic) SocketIO *socket;
@property (strong, nonatomic) IBOutlet UIButton *inningsButton;
@property (strong, nonatomic) IBOutlet UIButton *homeTeamButton;
@property (strong, nonatomic) IBOutlet UIButton *awayTeamButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITableView *gameStoryFeed;
@property (strong, nonatomic) IBOutlet UITextField *storyTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *awayLogo;
@property (strong, nonatomic) IBOutlet UIImageView *homeLogo;
@property (strong, nonatomic) NSMutableArray *storyData;

- (IBAction)clickAwayScore:(id)sender;
- (IBAction)clickHomeScore:(id)sender;
- (IBAction)clickInning:(id)sender;
- (IBAction)clickAddStory:(id)sender;
@end

@implementation SingleGameViewController

@synthesize inningsButton, homeTeamButton, awayTeamButton, gameData, socket, storyData;
@synthesize gameStoryFeed, storyTextField, scrollView, addButton, awayLogo, homeLogo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.storyData = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.socket = [[SocketIO alloc] initWithDelegate:self];

#ifdef DEBUG
	#if TARGET_IPHONE_SIMULATOR
		[self.socket connectToHost:@"localhost" onPort:8080];
	#else
		[self.socket connectToHost:@"sportsbard.jit.su" onPort:80];
	#endif
#else
	[self.socket connectToHost:@"sportsbard.jit.su" onPort:80];
#endif
	
	// Request the games data
	NSString *gameid = [self.gameData objectForKey:@"gameid"];	
	[self.socket sendEvent:@"getstories" withData:[NSDictionary dictionaryWithObject:gameid forKey:@"gameid"]];
	
	[self _updateGameData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.storyTextField resignFirstResponder];
	[self.socket disconnect];
}

- (void)_updateGameData {
	NSString *gameid = [self.gameData objectForKey:@"gameid"];	
	NSString *awayteam = [self.gameData objectForKey:@"awayteam"];
	NSString *hometeam = [self.gameData objectForKey:@"hometeam"];
	NSString *date = [self.gameData objectForKey:@"date"];
	NSNumber *inning = [self.gameData objectForKey:@"inning"];
	NSNumber *awayscore = [self.gameData objectForKey:@"awayscore"];
	NSNumber *homescore = [self.gameData objectForKey:@"homescore"];
	
	// Request the games data
	[self.socket sendEvent:@"getstories" withData:[NSDictionary dictionaryWithObject:gameid forKey:@"gameid"]];

	NSString *awayTeamScore = [NSString stringWithFormat:@"%@ %@", [awayteam uppercaseString], awayscore];
	NSString *homeTeamScore = [NSString stringWithFormat:@"%@ %@", [hometeam uppercaseString], homescore];
	
	
	if([inning integerValue] == 100) {
		[self.inningsButton setTitle:@"Finished" forState:UIControlStateNormal];	
	} else {		
		if([inning integerValue] == 0) {
			inning = [NSNumber numberWithInt:1];
		}
		
		NSString *direction = @"Top";
		if([inning integerValue] % 2 == 0) {
			direction = @"Bottom";
			NSInteger current = [inning integerValue];
			inning = [NSNumber numberWithInt:(current/2)];
		} else {
			NSInteger current = [inning integerValue] + 1;
			inning = [NSNumber numberWithInt:(current/2)];
		}
		
		NSString *ordinalNum = [self addSuffixToNumber:[inning integerValue]];
		[self.inningsButton setTitle:[NSString stringWithFormat:@"%@ %@", direction, ordinalNum] forState:UIControlStateNormal];	
	}
	
	[self.homeTeamButton setTitle:homeTeamScore forState:UIControlStateNormal];
	[self.awayTeamButton setTitle:awayTeamScore	forState:UIControlStateNormal];
	
	[self.awayLogo setImage:[UIImage imageNamed:[awayteam uppercaseString]]];
	[self.homeLogo setImage:[UIImage imageNamed:[hometeam uppercaseString]]];
}

- (IBAction)clickAwayScore:(id)sender {
	NSLog(@"Increase away score");
	
	NSString *gameid = [self.gameData objectForKey:@"gameid"];	
	NSString *awayteam = [self.gameData objectForKey:@"awayteam"];
	
	NSMutableDictionary *data = [NSMutableDictionary dictionary];
	[data setObject:gameid forKey:@"gameid"];
	[data setObject:awayteam forKey:@"team"];
	
	// Increase the away score
	[self.socket sendEvent:@"scoreupdate" withData:data];
}

- (IBAction)clickHomeScore:(id)sender {
	NSLog(@"Increase home score");	
	
	NSString *gameid = [self.gameData objectForKey:@"gameid"];	
	NSString *hometeam = [self.gameData objectForKey:@"hometeam"];
	
	NSMutableDictionary *data = [NSMutableDictionary dictionary];
	[data setObject:gameid forKey:@"gameid"];
	[data setObject:hometeam forKey:@"team"];
	
	// Increase the home score
	[self.socket sendEvent:@"scoreupdate" withData:data];
}

- (IBAction)clickInning:(id)sender {
	NSLog(@"Increase inning");
	
	NSString *gameid = [self.gameData objectForKey:@"gameid"];	
	
	NSMutableDictionary *data = [NSMutableDictionary dictionary];
	[data setObject:gameid forKey:@"gameid"];
	
	// Update the inning
	[self.socket sendEvent:@"inningupdate" withData:data];
}

- (IBAction)clickAddStory:(id)sender {
	[self.storyTextField resignFirstResponder];
	
	NSString *gameid = [self.gameData objectForKey:@"gameid"];	
	NSString *inning = [self.gameData objectForKey:@"inning"];	
	NSString *story = [self.storyTextField text];
	
	NSMutableDictionary *data = [NSMutableDictionary dictionary];
	[data setObject:gameid forKey:@"gameid"];
	[data setObject:inning forKey:@"inning"];
	[data setObject:story forKey:@"story"];	
	
	// Send a new story
	[self.socket sendEvent:@"newstory" withData:data];
	
	[self.storyTextField setText:@""];
}

- (void)gameCell:(SingleGameTableViewCell *)inGameCell didLike:(NSString *)storyid {
	NSMutableDictionary *data = [NSMutableDictionary dictionary];
	[data setObject:storyid forKey:@"storyid"];
	
	// Increase the away score
	[self.socket sendEvent:@"storylike" withData:data];
}

- (void)gameCell:(SingleGameTableViewCell *)inGameCell didHide:(NSString *)storyid {
	NSMutableDictionary *data = [NSMutableDictionary dictionary];
	[data setObject:storyid forKey:@"storyid"];
	
	// Increase the away score
	[self.socket sendEvent:@"storyhide" withData:data];
}

- (void)socketIOHandshakeFailed:(SocketIO *)socket {
	NSLog(@"Handshake failed!");
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSLog(@"didReceiveMessage() >>> data: %@", packet.data);
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
	NSLog(@"didReceiveEvent() >>> data: %@", packet.data);
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSDictionary *eventData = [parser objectWithString:packet.data];
	
	if(eventData && [[eventData objectForKey:@"name"] isEqualToString:@"stories"]) {
		NSArray *dataArr = [eventData objectForKey:@"args"];
		NSArray *storyArr = [dataArr objectAtIndex:0];
		NSMutableArray *stories = [NSMutableArray arrayWithArray:storyArr];
		
		NSLog(@"data is %@", stories);
		self.storyData = stories;
		[self.gameStoryFeed reloadData];
	} else if(eventData && [[eventData objectForKey:@"name"] isEqualToString:@"scoreupdated"]) {
		NSArray *dataArr = [eventData objectForKey:@"args"];
		NSDictionary *scoreData = [dataArr objectAtIndex:0];
		
		NSLog(@"data is %@", scoreData);
		self.gameData = scoreData;
		[self _updateGameData];
	} else if(eventData && [[eventData objectForKey:@"name"] isEqualToString:@"inningupdated"]) {
		NSArray *dataArr = [eventData objectForKey:@"args"];
		NSDictionary *scoreData = [dataArr objectAtIndex:0];
		
		NSLog(@"data is %@", scoreData);
		self.gameData = scoreData;
		[self _updateGameData];
	} else if(eventData && [[eventData objectForKey:@"name"] isEqualToString:@"newstory"]) {
		NSArray *dataArr = [eventData objectForKey:@"args"];
		NSDictionary *story = [dataArr objectAtIndex:0];
		
		NSLog(@"data is %@", story);
		[self.storyData addObject:story];
		[self.gameStoryFeed reloadData];
	} else if(eventData && [[eventData objectForKey:@"name"] isEqualToString:@"storyupdated"]) {
		NSArray *dataArr = [eventData objectForKey:@"args"];
		NSDictionary *story = [dataArr objectAtIndex:0];
		
		NSLog(@"data is %@", story);
		
		// Find and replace the story
		NSInteger foundStory = -1;
		for(int i=0; i < [self.storyData count]; i++) {
			NSDictionary *data = [self.storyData objectAtIndex:i];
			NSString *storyid = [data objectForKey:@"_id"];
			if([storyid isEqualToString:[story objectForKey:@"_id"]]) {
				foundStory = i;
				break;
			}
		}
		
		if(foundStory != -1) {
			[self.storyData replaceObjectAtIndex:foundStory withObject:story];
			[self.gameStoryFeed reloadData];
		}
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.storyData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	SingleGameTableViewCell *cell = [self.gameStoryFeed dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {	
		cell = [[SingleGameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		[cell setDelegate:self];
	}

	NSInteger index = [self.storyData count] - indexPath.row - 1;
	NSDictionary *story = [self.storyData objectAtIndex:index];
	[cell setStoryData:story];
	
	return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//  CGRect rc = [textField bounds];
//  UIScrollView *sv = self.scrollView;
//  rc = [textField convertRect:rc toView:sv];
  CGPoint pt = textField.bounds.origin ;
  pt.x = 0 ;
  pt.y = 210;
  [self.scrollView setContentOffset:pt animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

-(NSString *)addSuffixToNumber:(int)number {
    NSString *suffix;
    int ones = number % 10;
    int temp = floor(number/10.0);
    int tens = temp%10;
	
    if (tens ==1) {
        suffix = @"th";
    } else if (ones ==1){
        suffix = @"st";
    } else if (ones ==2){
        suffix = @"nd";
    } else if (ones ==3){
        suffix = @"rd";
    } else {
        suffix = @"th";
    }
	
	NSString *completeAsString = [NSString stringWithFormat:@"%d%@",number,suffix];
	return completeAsString;
}

@end
