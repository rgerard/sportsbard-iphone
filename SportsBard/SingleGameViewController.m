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
@property (strong, nonatomic) IBOutlet UITableView *gameStoryFeed;
@property (strong, nonatomic) IBOutlet UITextField *storyTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)clickAwayScore:(id)sender;
- (IBAction)clickHomeScore:(id)sender;
- (IBAction)clickInning:(id)sender;
- (IBAction)clickAddStory:(id)sender;
@end

@implementation SingleGameViewController

@synthesize inningsButton, homeTeamButton, awayTeamButton, gameData, socket;
@synthesize gameStoryFeed, storyTextField, scrollView;

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

- (IBAction)clickAddStory:(id)sender {
  [self.storyTextField resignFirstResponder];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [self.gameStoryFeed dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  
  return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
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
