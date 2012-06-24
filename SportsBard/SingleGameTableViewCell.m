//
//  SingleGameTableViewCell.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleGameTableViewCell.h"
#import "SBJson.h"
#import <QuartzCore/QuartzCore.h>

@interface SingleGameTableViewCell ()
@property(strong, nonatomic) UIView *backView;
@property(strong, nonatomic) UITextView *story;
@property(strong, nonatomic) UILabel *likes;
@property(strong, nonatomic) UIButton *like;
@property(strong, nonatomic) UIButton *hide;
@end

@implementation SingleGameTableViewCell

@synthesize backView, storyData = storyData_, story, likes, like, hide, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.backView = [[UIView alloc] initWithFrame:CGRectZero];
		[self.backView setBackgroundColor:[UIColor whiteColor]];
		self.backView.layer.cornerRadius = 5.0;
		
		self.story = [[UITextView alloc] initWithFrame:CGRectZero];
		[self.story setBackgroundColor:[UIColor clearColor]];
		[self.backView addSubview:self.story];
		
		self.likes = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.likes setBackgroundColor:[UIColor clearColor]];
		[self.likes setFont:[UIFont systemFontOfSize:12.0]];
		[self.likes setTextAlignment:UITextAlignmentRight];
		[self.backView addSubview:self.likes];
		
		self.like = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.like setImage:[UIImage imageNamed:@"thumbsup.png"] forState:UIControlStateNormal];
		[self.like addTarget:self action:@selector(_likeStory:) forControlEvents:UIControlEventTouchUpInside];
		[self.backView addSubview:self.like];
		
		self.hide = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.hide setImage:[UIImage imageNamed:@"close.jpeg"] forState:UIControlStateNormal];
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
    
    [self.backView setFrame:CGRectMake(contentBounds.origin.x + 10, contentBounds.origin.y, 300, 80)];
	[self.story setFrame:CGRectMake(contentBounds.origin.x + 5, contentBounds.origin.y + 5, 245, 55)];
    [self.likes setFrame:CGRectMake(contentBounds.origin.x + 140, contentBounds.origin.y + 60, 100, 20)];
	
    [self.like setFrame:CGRectMake(contentBounds.origin.x + 263, contentBounds.origin.y + 5, 25, 25)];
	[self.hide setFrame:CGRectMake(contentBounds.origin.x + 260, contentBounds.origin.y + 40, 30, 30)];
}

- (void)setStoryData:(NSDictionary *)storyData {
	storyData_ = storyData;
	
	[self.story setText:[storyData objectForKey:@"story"]];
	
	NSNumber *numLikes = [storyData objectForKey:@"likes"];
	[self.likes setText:[NSString stringWithFormat:@"%@ likes", [numLikes stringValue]]];
}

- (void)_likeStory:(id)sender {
	NSLog(@"Like story");
	
	NSString *storyid = [self.storyData objectForKey:@"_id"];	
	if ([self.delegate respondsToSelector:@selector(gameCell:didLike:)]) {
		[self.delegate gameCell:self didLike:storyid];
	}
}

- (void)_hideStory:(id)sender {
	NSLog(@"Hide story");
	
	NSString *storyid = [self.storyData objectForKey:@"_id"];	
	if ([self.delegate respondsToSelector:@selector(gameCell:didHide:)]) {
		[self.delegate gameCell:self didHide:storyid];
	}
}


@end
