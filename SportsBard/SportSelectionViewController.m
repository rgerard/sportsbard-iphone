//
//  SportSelectionViewController.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SportSelectionViewController.h"

NSString * const SportSelectedNotification = @"SportSelectedNotification";

@interface SportSelectionViewController ()
@property(strong, nonatomic) NSMutableArray *sports;
@end

@implementation SportSelectionViewController

@synthesize pickerView;
@synthesize sports;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.sports = [[NSMutableArray alloc] initWithObjects:@"Baseball", @"Football", @"Tennis", @"Soccer", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.sports count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *sport = [self.sports objectAtIndex:row];
	
	NSNotification *notification = [NSNotification notificationWithName:SportSelectedNotification object:sport];
    [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) onThread:[NSThread mainThread] withObject:notification waitUntilDone:NO];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.sports objectAtIndex:row];
}

@end
