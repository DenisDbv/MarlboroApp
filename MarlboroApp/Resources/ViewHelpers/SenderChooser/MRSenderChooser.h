//
//  MRSenderChooser.h
//  MarlboroApp
//
//  Created by DenisDbv on 29.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NibLoading.h"

@protocol MRSenderChooserDelegate <NSObject>
-(void) onExitAfterSenderChecker;
-(void) onContinueAfterSenderChecker;
@end

@interface MRSenderChooser : NibLoadedView

@property (nonatomic, strong) id <MRSenderChooserDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;

-(void) initialize;

@end
