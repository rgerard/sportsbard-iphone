//
//  SingleGameViewController.m
//  SportsBard
//
//  Created by Administrator on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleGameViewController.h"

@interface SingleGameViewController ()
@property (strong, nonatomic) IBOutlet UIButton *inningsButton;
@property (strong, nonatomic) IBOutlet UIButton *homeTeamButton;
@property (strong, nonatomic) IBOutlet UIButton *awayTeamButton;
@end

@implementation SingleGameViewController

@synthesize inningsButton, homeTeamButton, awayTeamButton, gameData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.inningsButton.titleLabel.text = @"9up";
  self.homeTeamButton.titleLabel.text = @"ATL 4";
  self.awayTeamButton.titleLabel.text = @"SEA 2";  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
