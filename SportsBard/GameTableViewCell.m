//
//  GameTableViewCell.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface GameTableViewCell ()
@property(strong, nonatomic) UIView *cellHeader;
@property(strong, nonatomic) UILabel *cellHeaderInning;
@property(strong, nonatomic) UILabel *cellHeaderScores;

@property(strong, nonatomic) UIView *cellGameView;
@property(strong, nonatomic) UIImageView *visitorLogo;
@property(strong, nonatomic) UIImageView *homeLogo;
@property(strong, nonatomic) UILabel *vsLbl;
@property(strong, nonatomic) UILabel *numStoriesLbl;
@property(strong, nonatomic) UIImageView *indicator;
@end

@implementation GameTableViewCell

@synthesize cellHeader;
@synthesize cellHeaderInning;
@synthesize cellHeaderScores;
@synthesize cellGameView;
@synthesize visitorLogo;
@synthesize homeLogo;
@synthesize vsLbl;
@synthesize numStoriesLbl;
@synthesize gameData = gameData_;
@synthesize indicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.gameData = [NSDictionary dictionary];
		
		self.cellHeader = [[UIView alloc] initWithFrame:CGRectZero];
		[self.cellHeader setBackgroundColor:[UIColor clearColor]];
		[self.cellHeader setFrame:CGRectMake(20, 10, 280, 40)];
		
		// Set a gradient
		UIColor *lowColor = [UIColor colorWithRed:0.0/255.0 green:129.0/255.0 blue:69.0/255.0 alpha:1.0];
		UIColor *highColor = [UIColor colorWithRed:120.0/255.0 green:195.0/255.0 blue:114.0/255.0 alpha:1.0];
		
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = self.cellHeader.bounds;
		gradient.colors = [NSArray arrayWithObjects:(id)[highColor CGColor], (id)[lowColor CGColor], nil];
		[self.cellHeader.layer insertSublayer:gradient atIndex:0];
		
		self.cellHeaderInning = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.cellHeaderInning setText:@"9up"];
		[self.cellHeaderInning setFont:[UIFont systemFontOfSize:12.0]];
		[self.cellHeaderInning setBackgroundColor:[UIColor clearColor]];
		[self.cellHeaderInning setTextColor:[UIColor whiteColor]];
		[self.cellHeader addSubview:self.cellHeaderInning];
		
		self.cellHeaderScores = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.cellHeaderScores setText:@"Scores"];
		[self.cellHeaderScores setTextAlignment:UITextAlignmentCenter];
		[self.cellHeaderScores setBackgroundColor:[UIColor clearColor]];
		[self.cellHeader addSubview:self.cellHeaderScores];
		
		self.cellGameView = [[UIView alloc] initWithFrame:CGRectZero];
		[self.cellGameView setBackgroundColor:[UIColor lightGrayColor]];
		
		self.visitorLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.cellGameView addSubview:self.visitorLogo];
		
		self.homeLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.cellGameView addSubview:self.homeLogo];
		
		self.vsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.vsLbl setText:@"VS"];
		[self.vsLbl setFont:[UIFont boldSystemFontOfSize:18.0]];
		[self.vsLbl setTextAlignment:UITextAlignmentCenter];
		[self.vsLbl setBackgroundColor:[UIColor clearColor]];
		[self.cellGameView addSubview:self.vsLbl];
		
		self.numStoriesLbl = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.numStoriesLbl setText:@"9 stories"];
		[self.numStoriesLbl setTextAlignment:UITextAlignmentCenter];
		[self.numStoriesLbl setFont:[UIFont systemFontOfSize:12.0]];
		[self.numStoriesLbl setBackgroundColor:[UIColor clearColor]];
		[self.cellGameView addSubview:self.numStoriesLbl];
		
		self.indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator.png"]];
		[self.cellGameView addSubview:self.indicator];
		
		[self.contentView addSubview:self.cellHeader];
		[self.contentView addSubview:self.cellGameView];
		
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentBounds = [self.contentView bounds];
    
    [self.cellHeader setFrame:CGRectMake(contentBounds.origin.x + 20, contentBounds.origin.y + 10, 280, 40)];
	[self.cellHeaderInning setFrame:CGRectMake(contentBounds.origin.x, contentBounds.origin.y-5, 90, 40)];
    [self.cellHeaderScores setFrame:CGRectMake(contentBounds.origin.x + 80, contentBounds.origin.y-5, 130, 40)];
	
    [self.cellGameView setFrame:CGRectMake(contentBounds.origin.x + 20, contentBounds.origin.y + 40, 280, 80)];
	[self.visitorLogo setFrame:CGRectMake(contentBounds.origin.x + 30, contentBounds.origin.y + 15, 50, 50)];
    [self.vsLbl setFrame:CGRectMake(contentBounds.origin.x + 90, contentBounds.origin.y + 30, 100, 20)];
	[self.homeLogo setFrame:CGRectMake(contentBounds.origin.x + 200, contentBounds.origin.y + 15, 50, 50)];
	[self.numStoriesLbl setFrame:CGRectMake(contentBounds.origin.x + 90, contentBounds.origin.y + 55, 100, 20)];
	
	[self.indicator setFrame:CGRectMake(contentBounds.origin.x + 260, contentBounds.origin.y + 35, 16, 16)];
}

- (void)setGameData:(NSDictionary *)gameData {
	gameData_ = gameData;
	
	NSString *awayteam = [gameData objectForKey:@"awayteam"];
	NSString *hometeam = [gameData objectForKey:@"hometeam"];
	NSString *date = [gameData objectForKey:@"date"];
	NSNumber *inning = [gameData objectForKey:@"inning"];
	NSString *awayscore = [gameData objectForKey:@"awayscore"];
	NSString *homescore = [gameData objectForKey:@"homescore"];
	
	// Formatter to convert date string to NSDate object
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[dateFormat setLocale:usLocale];
	[dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
	NSDate *actualDate = [dateFormat dateFromString:date];
	
	NSDate *now = [NSDate date];
	if([now compare:actualDate] == NSOrderedAscending) {
		// Formatter to turn the NSDate into a nicely formatter time
		NSDateFormatter *cellHeaderDateFormatter = [[NSDateFormatter alloc] init];
		[cellHeaderDateFormatter setDateFormat:@"K:mm a, z"];
		
		// 0 means it hasn't started, 100 means it's over
		if([inning integerValue] == 0) {
			[self.cellHeaderInning setText:[cellHeaderDateFormatter stringFromDate:actualDate]];
		} else if([inning integerValue] == 100) {
			[self.cellHeaderInning setText:@""];
		} else {
			
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
			[self.cellHeaderInning setText:[NSString stringWithFormat:@"%@ %@", direction, ordinalNum]];
		}
		
		[self.cellHeaderScores setText:[NSString stringWithFormat:@"%@ vs %@", [awayteam uppercaseString], [hometeam uppercaseString]]];
	} else {
		NSString *headerScore = [NSString stringWithFormat:@"%@ %@, %@ %@", [awayteam uppercaseString], awayscore, [hometeam uppercaseString], homescore];
		[self.cellHeaderScores setText:headerScore];	
	}

	[self.visitorLogo setImage:[UIImage imageNamed:[awayteam uppercaseString]]];
	[self.homeLogo setImage:[UIImage imageNamed:[hometeam uppercaseString]]];
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
