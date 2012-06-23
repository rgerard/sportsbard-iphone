//
//  MainViewController.m
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

NSString * const LoginSuccessNotification = @"LoginSuccessNotification";

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize loginBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)loginClick:(id)sender {
    NSNotification *notification = [NSNotification notificationWithName:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) onThread:[NSThread mainThread] withObject:notification waitUntilDone:NO];
}

@end
