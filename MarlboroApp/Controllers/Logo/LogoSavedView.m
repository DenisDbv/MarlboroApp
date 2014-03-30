//
//  LogoSavedView.m
//  MarlboroApp
//
//  Created by DenisDbv on 31.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "LogoSavedView.h"
#import "PMTimeManager.h"

@implementation LogoSavedView

@synthesize finishTitle1, finishTitle2, finishTitle3;
@synthesize delegate;

-(void) setDefault
{
    finishTitle1.alpha = 0;
    finishTitle1.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    finishTitle1.backgroundColor = [UIColor clearColor];
    finishTitle1.textColor = DEFAULT_COLOR_SCHEME;
    finishTitle1.textAlignment = NSTextAlignmentCenter;
    
    finishTitle2.alpha = 0;
    finishTitle2.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    finishTitle2.backgroundColor = [UIColor clearColor];
    finishTitle2.textColor = DEFAULT_COLOR_SCHEME;
    finishTitle2.textAlignment = NSTextAlignmentCenter;
    
    finishTitle3.alpha = 0;
    finishTitle3.font = [UIFont fontWithName:@"MyriadPro-Cond" size:45.0];
    finishTitle3.backgroundColor = [UIColor clearColor];
    finishTitle3.textColor = DEFAULT_COLOR_SCHEME;
    finishTitle3.textAlignment = NSTextAlignmentCenter;
    
    PMTimeManager *timeManager = [[PMTimeManager alloc] init];
    finishTitle3.text = [NSString stringWithFormat:@"СПАСИБО И %@!", [timeManager titleTimeArea]];
}

-(void) animateView
{
    [UIView animateWithDuration:0.3 animations:^{
        finishTitle1.alpha = 1;
        finishTitle2.alpha = 1;
        finishTitle3.alpha = 1;
    }];
}

-(IBAction)onExit:(id)sender
{
    if([delegate respondsToSelector:@selector(exitFromFinishView)])
    {
        [delegate exitFromFinishView];
    }
}

@end
