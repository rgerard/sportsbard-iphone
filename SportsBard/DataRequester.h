//
//  DataRequester.h
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface DataRequester : NSObject<ASIHTTPRequestDelegate>
@property(strong, nonatomic) NSMutableArray *gamesData;
- (id)init;
- (void)requestGamesData;
@end
