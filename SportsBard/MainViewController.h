//
//  MainViewController.h
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

extern NSString * const LoginSuccessNotification;

@interface MainViewController : UIViewController
@property(strong, nonatomic) IBOutlet UIButton *loginBtn;
-(IBAction)loginClick:(id)sender;
@end
