//
//  MRParentViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 27.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRParentViewController.h"

NSString *const MROnExitClickNotification = @"MROnExitClickNotification";

@interface MRParentViewController ()

@end

@implementation MRParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Show/Hide all context
-(void) hideAllContext
{
    self.view.alpha = 0.0;
}

-(void) showAllContext
{
    self.view.alpha = 1.0;
}

#pragma mark - Exit button
-(void) showExitButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"exit.png"];
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.alpha = 1.0f;
    [exitButton addTarget:self action:@selector(onExit:) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setImage:buttonImage forState:UIControlStateNormal];
    [exitButton setImage:buttonImage forState:UIControlStateHighlighted];
    exitButton.frame = CGRectMake(10, 10, buttonImage.size.width, buttonImage.size.height);
    [self.view addSubview:exitButton];
}

-(void) hideExitButton
{
    
}

-(void) onExit:(UIButton*)btn
{
    [UIView animateWithDuration:0.03 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.03f animations:^{
            btn.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MROnExitClickNotification object:nil];
        }];
    }];
}

@end
