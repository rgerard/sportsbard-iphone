//
//  GamesViewController.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamesViewController.h"
#import "GameTableViewCell.h"

@interface GamesViewController ()
@property(strong, nonatomic) UILabel *dateLbl;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *gamesInfo;
@end

@implementation GamesViewController

@synthesize dateLbl;
@synthesize tableView;
@synthesize gamesInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.gamesInfo = [NSMutableArray array];
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [self.gamesInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    GameTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

@end
