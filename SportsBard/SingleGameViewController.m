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
	[self.socket connectToHost:@"localhost" onPort:8080];
	
	// Request the games data
	NSString *gameid = [self.gameData objectForKey:@"gameid"];	
	[self.socket sendEvent:@"getstories" withData:[NSDictionary dictionaryWithObject:gameid forKey:@"gameid"]];
	
	[self _updateGameData];
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
	
	if([inning integerValue] == 0) {
		inning = [NSNumber numberWithInt:1];
	}
	
	NSString *awayTeamScore = [NSString stringWithFormat:@"%@ %@", [awayteam uppercaseString], awayscore];
	NSString *homeTeamScore = [NSString stringWithFormat:@"%@ %@", [hometeam uppercaseString], homescore];
	
    // Do any additional setup after loading the view from its nib.
	[self.inningsButton setTitle:[inning stringValue] forState:UIControlStateNormal];
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
	
	// Request the games data
	[self.socket sendEvent:@"scoreupdate" withData:data];
}

- (IBAction)clickHomeScore:(id)sender {
	NSLog(@"Increase home score");	
	
	NSString *gameid = [self.gameData objectForKey:@"gameid"];	
	NSString *hometeam = [self.gameData objectForKey:@"hometeam"];
	
	NSMutableDictionary *data = [NSMutableDictionary dictionary];
	[data setObject:gameid forKey:@"gameid"];
	[data setObject:hometeam forKey:@"team"];
	
	// Request the games data
	[self.socket sendEvent:@"scoreupdate" withData:data];
}

- (IBAction)clickInning:(id)sender {
	NSLog(@"Increase inning");
	
	NSString *gameid = [self.gameData objectForKey:@"gameid"];	
	
	NSMutableDictionary *data = [NSMutableDictionary dictionary];
	[data setObject:gameid forKey:@"gameid"];
	
	// Request the games data
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
	
	// Request the games data
	[self.socket sendEvent:@"newstory" withData:data];
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
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.storyData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [self.gameStoryFeed dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {	
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
  
	NSDictionary *story = [self.storyData objectAtIndex:indexPath.row];
	[[cell textLabel] setText:[story objectForKey:@"story"]];
	
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

@end
