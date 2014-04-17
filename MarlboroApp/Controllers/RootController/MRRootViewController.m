//
//  MRRootViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 27.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRRootViewController.h"
#import <MZFormSheetController/MZFormSheetController.h>

#import "MRRootMenuViewController.h"

@interface MRRootViewController ()

@end

@implementation MRRootViewController
{
    MZFormSheetController *menuSheetController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self windowInitiailization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) windowInitiailization
{
    MRRootMenuViewController *rootMenuViewController = [[MRRootMenuViewController alloc] initWithNibName:@"MRRootMenuViewController" bundle:[NSBundle mainBundle]];
    
    if( IS_OS_7_OR_LATER )  {
        menuSheetController = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:rootMenuViewController];
        menuSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
        [menuSheetController presentFormSheetController:menuSheetController animated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            NSLog(@"Root menu view controller present");
        }];
    } else  {
        UINavigationController *navCntrl = [[UINavigationController alloc] init];
        navCntrl.navigationBarHidden = YES;
        
        [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:(__bridge CGColorRef)([UIColor clearColor])];
        [self presentFormSheetWithViewController:navCntrl animated:NO transitionStyle:MZFormSheetTransitionStyleFade completionHandler:^(MZFormSheetController *formSheetController) {
            formSheetController.landscapeTopInset = 0.0f;
            //formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
            [formSheetController presentViewController:rootMenuViewController animated:YES completion:^{
                
            }];
        }];
    }
}

@end
