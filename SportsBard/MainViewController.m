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
	
	// This notification is posted when the accounts managed by this account store changed in the database.
    // When you receive this notification, you should refetch all account objects.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canTweetStatus) name:ACAccountStoreDidChangeNotification object:nil];
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
    // Create an account store object.
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
				NSString *username = [twitterAccount username];
				NSLog(@"username is %@", username);
				
				if(username && ![username isEqualToString:@""]) {
					[[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
				}
            }
			
			NSNotification *notification = [NSNotification notificationWithName:LoginSuccessNotification object:nil];
			[[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) onThread:[NSThread mainThread] withObject:notification waitUntilDone:NO];
        }
    }];
}

@end
