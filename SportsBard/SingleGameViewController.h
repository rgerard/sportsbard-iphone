//
//  SingleGameViewController.h
//  SportsBard
//
//  Created by Administrator on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"

@interface SingleGameViewController : UIViewController<SocketIODelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSDictionary *gameData;

@end
