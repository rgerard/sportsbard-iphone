//
//  GamesViewController.h
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"

@interface GamesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SocketIODelegate>
@property(strong, nonatomic) NSMutableArray *gameData;
- (id)init;
@end
