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
{
    UIButton *exitButton;
}

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
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.multipleTouchEnabled = YES;
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
    if(exitButton == nil)   {
        exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamed:@"back.png"];
        exitButton.alpha = 0.0f;
        [exitButton addTarget:self action:@selector(onExit:) forControlEvents:UIControlEventTouchUpInside];
        [exitButton setImage:buttonImage forState:UIControlStateNormal];
        [exitButton setImage:buttonImage forState:UIControlStateHighlighted];
        exitButton.frame = CGRectMake(10, 10, buttonImage.size.width, buttonImage.size.height);
        [self.view addSubview:exitButton];
        
        [UIView animateWithDuration:0.2 animations:^{
            exitButton.alpha = 1;
        }];
    }
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
    
    [[AppDelegateInstance() rootViewController] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    [[AppDelegateInstance() rootViewController] touchesMoved:touches withEvent:event];
}

@end
