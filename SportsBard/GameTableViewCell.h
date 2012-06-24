//
//  GameTableViewCell.h
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameTableViewCell : UITableViewCell
@property(strong, nonatomic) NSDictionary *gameData;
- (void)reset;
@end
