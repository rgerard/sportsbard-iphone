//
//  GamesViewController.h
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSMutableArray *gameData;
@end
