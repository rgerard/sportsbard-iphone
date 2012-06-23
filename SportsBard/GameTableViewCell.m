//
//  GameTableViewCell.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameTableViewCell.h"

@interface GameTableViewCell ()
@property(strong, nonatomic) UIView *cellHeader;
@property(strong, nonatomic) UILabel *cellHeaderInning;
@property(strong, nonatomic) UILabel *cellHeaderScores;

@property(strong, nonatomic) UIView *cellGameView;
@property(strong, nonatomic) UIImageView *visitorLogo;
@property(strong, nonatomic) UIImageView *homeLogo;
@property(strong, nonatomic) UILabel *vsLbl;
@property(strong, nonatomic) UILabel *numStoriesLbl;
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.cellHeader = [[UIView alloc] initWithFrame:CGRectZero];
		[self.cellHeader setBackgroundColor:[UIColor redColor]];
		
		self.cellHeaderInning = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.cellHeaderInning setText:@"9up"];
		[self.cellHeader addSubview:self.cellHeaderInning];
		
		self.cellHeaderScores = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.cellHeaderScores setText:@"Scores"];
		[self.cellHeaderScores setTextAlignment:UITextAlignmentCenter];
		[self.cellHeader addSubview:self.cellHeaderScores];
		
		self.cellGameView = [[UIView alloc] initWithFrame:CGRectZero];
		[self.cellGameView setBackgroundColor:[UIColor blueColor]];
		
		self.visitorLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.cellGameView addSubview:self.visitorLogo];
		
		self.homeLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.cellGameView addSubview:self.homeLogo];
		
		self.vsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.vsLbl setText:@"VS"];
		[self.vsLbl setTextAlignment:UITextAlignmentCenter];
		[self.cellGameView addSubview:self.vsLbl];
		
		self.numStoriesLbl = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.numStoriesLbl setText:@"9 stories"];
		[self.numStoriesLbl setTextAlignment:UITextAlignmentCenter];
		[self.cellGameView addSubview:self.numStoriesLbl];
		
		[self.contentView addSubview:self.cellHeader];
		[self.contentView addSubview:self.cellGameView];
		
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentBounds = [self.contentView bounds];
    
    [self.cellHeader setFrame:CGRectMake(contentBounds.origin.x, contentBounds.origin.y + 10, 320, 40)];
	[self.cellHeaderInning setFrame:CGRectMake(contentBounds.origin.x, contentBounds.origin.y, 50, 40)];
    [self.cellHeaderScores setFrame:CGRectMake(contentBounds.origin.x + 90, contentBounds.origin.y, 130, 40)];
	
    [self.cellGameView setFrame:CGRectMake(contentBounds.origin.x, contentBounds.origin.y + 40, 320, 60)];
	[self.visitorLogo setFrame:CGRectMake(contentBounds.origin.x + 10, contentBounds.origin.y + 10, 50, 50)];
	[self.homeLogo setFrame:CGRectMake(contentBounds.origin.x + 100, contentBounds.origin.y + 10, 50, 50)];
    [self.vsLbl setFrame:CGRectMake(contentBounds.origin.x + 110, contentBounds.origin.y + 10, 100, 20)];
	[self.numStoriesLbl setFrame:CGRectMake(contentBounds.origin.x + 110, contentBounds.origin.y + 30, 100, 20)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
