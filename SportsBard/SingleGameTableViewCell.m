//
//  SingleGameTableViewCell.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleGameTableViewCell.h"

@interface SingleGameTableViewCell ()
@property(strong, nonatomic) UIView *backView;
@property(strong, nonatomic) UITextView *story;
@property(strong, nonatomic) UILabel *likes;
@property(strong, nonatomic) UIButton *like;
@property(strong, nonatomic) UIButton *hide;
@end

@implementation SingleGameTableViewCell

@synthesize backView, storyData = storyData_, story, likes, like, hide;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.backView = [[UIView alloc] initWithFrame:CGRectZero];

		self.story = [[UITextView alloc] initWithFrame:CGRectZero];
		[self.story setBackgroundColor:[UIColor redColor]];
		[self.backView addSubview:self.story];
		
		self.likes = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.likes setBackgroundColor:[UIColor blueColor]];
		[self.likes setFont:[UIFont systemFontOfSize:12.0]];
		[self.likes setTextAlignment:UITextAlignmentRight];
		[self.backView addSubview:self.likes];
		
		self.like = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[self.like setTitle:@"L" forState:UIControlStateNormal];
		[self.like addTarget:self action:@selector(_likeStory:) forControlEvents:UIControlEventTouchUpInside];
		[self.backView addSubview:self.like];
		
		self.hide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[self.hide setTitle:@"H" forState:UIControlStateNormal];
		[self.hide addTarget:self action:@selector(_hideStory:) forControlEvents:UIControlEventTouchUpInside];
		[self.backView addSubview:self.hide];
		
		[self.contentView addSubview:self.backView];
		
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentBounds = [self.contentView bounds];
    
    [self.backView setFrame:CGRectMake(contentBounds.origin.x, contentBounds.origin.y, 320, 80)];
	[self.story setFrame:CGRectMake(contentBounds.origin.x + 10, contentBounds.origin.y, 240, 60)];
    [self.likes setFrame:CGRectMake(contentBounds.origin.x + 150, contentBounds.origin.y + 60, 100, 20)];
	
    [self.like setFrame:CGRectMake(contentBounds.origin.x + 270, contentBounds.origin.y, 30, 30)];
	[self.hide setFrame:CGRectMake(contentBounds.origin.x + 270, contentBounds.origin.y + 35, 30, 30)];
}

- (void)setStoryData:(NSDictionary *)storyData {
	storyData_ = storyData;
	
	[self.story setText:[storyData objectForKey:@"story"]];
	
	NSNumber *numLikes = [storyData objectForKey:@"likes"];
	[self.likes setText:[NSString stringWithFormat:@"%@ likes", [numLikes stringValue]]];
}

- (void)_likeStory:(id)sender {
	NSLog(@"Like story");
}

- (void)_hideStory:(id)sender {
	NSLog(@"Hide story");
}

@end
