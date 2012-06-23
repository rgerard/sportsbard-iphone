//
//  SportSelectionViewController.h
//  SportsBard
//
//  Created by Ryan Gerard on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const SportSelectedNotification;

@interface SportSelectionViewController : UIViewController<UIPickerViewDelegate>
@property(strong, nonatomic) IBOutlet UIPickerView *pickerView;
@end
