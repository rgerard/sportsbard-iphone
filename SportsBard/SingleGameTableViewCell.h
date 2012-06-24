//
//  SingleGameTableViewCell.h
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SingleGameTableViewCell;
@protocol SingleGameCellDelegate<NSObject>
@optional
- (void)gameCell:(SingleGameTableViewCell *)inGameCell didLike:(NSString *)storyid;
- (void)gameCell:(SingleGameTableViewCell *)inGameCell didHide:(NSString *)storyid;
@end

@interface SingleGameTableViewCell : UITableViewCell
@property(strong, nonatomic) NSDictionary *storyData;
@property (nonatomic, assign) id<SingleGameCellDelegate> delegate;
@end
