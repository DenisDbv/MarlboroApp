//
//  MRParentViewController.h
//  MarlboroApp
//
//  Created by DenisDbv on 27.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MROnExitClickNotification;

@interface MRParentViewController : UIViewController

-(void) hideAllContext;
-(void) showAllContext;

-(void) showExitButton;
-(void) hideExitButton;

@end
