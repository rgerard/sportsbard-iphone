//
//  MainViewController.h
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const LoginSuccessNotification;

@interface MainViewController : UIViewController
@property(strong, nonatomic) IBOutlet UIButton *loginBtn;
-(IBAction)loginClick:(id)sender;
@end
