//
//  MRRootMenuViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 27.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRRootMenuViewController.h"

#import "PMActivationView.h"
#import "MRRegistrationViewController.h"
#import "MRSettingsViewController.h"
#import "MRGameViewController.h"
#import "MRStampRootViewController.h"

#import <MZFormSheetController/MZFormSheetController.h>

@interface MRRootMenuViewController () <PMActivationViewDelegate>
@property (nonatomic, strong) NSMutableArray *activationButtonsArray;
@end

@implementation MRRootMenuViewController
{
    BOOL secret_doubleTap;
    BOOL secret_disable;
    UIButton *settingButton;
    
    UILabel *titleLabel;
}
@synthesize activationButtonsArray;

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
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.alpha = 0;
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DEFAULT_COLOR_SCHEME;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"ВЫБЕРИТЕ АКТИВАЦИЮ";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    [self.view addSubview:titleLabel];
    
    secret_doubleTap = NO;
    secret_disable = NO;
    
    [self buttonsConfigure];
    [self buttonsReposition];
    [self animateShowActivations];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    
    UIImage *settingImage = [UIImage imageNamed:@"settings.png"];
    settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.alpha = 0.0f;
    [settingButton addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton setImage:settingImage forState:UIControlStateHighlighted];
    settingButton.frame = CGRectMake(screenWidth - settingImage.size.width - 10, 10, settingImage.size.width, settingImage.size.height);
    [self.view addSubview:settingButton];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap2:)];
    tapGesture2.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap1:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture1];
    
    [tapGesture1 requireGestureRecognizerToFail:tapGesture2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)handleTap1:(UIGestureRecognizer *)sender
{
    CGPoint coords = [sender locationInView:sender.view];
    
    CGFloat widthArea = self.view.frame.size.width-100;
    CGFloat heightArea = self.view.frame.size.height-100;
    
    if(!IS_OS_7_OR_LATER)
    {
        widthArea = self.view.frame.size.height-100;
        heightArea = self.view.frame.size.width-100;
    }
    
    if(coords.x > widthArea && coords.y > heightArea)    {
        //NSLog(@"!%@", NSStringFromCGPoint(coords));
        if(secret_doubleTap == YES) {
            NSLog(@"Show settings secret button");
            
            secret_disable = YES;
            
            [UIView animateWithDuration:0.3f animations:^{
                settingButton.alpha = 1.0;
            } completion:^(BOOL finished) {
                int64_t delayInSeconds = 3.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        settingButton.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        secret_disable = NO;
                    }];
                    NSLog(@"Setting button hidden");
                });
            }];
        }
    }
}

- (void)handleTap2:(UIGestureRecognizer *)sender
{
    CGPoint coords = [sender locationInView:sender.view];
    if(coords.x < 100 && coords.y < 100)    {
        //NSLog(@"%@", NSStringFromCGPoint(coords));
        
        if(!secret_disable) {
            secret_doubleTap = YES;
            
            int64_t delayInSeconds = 1.6;   //1.6
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                secret_doubleTap = NO;
            });
        }
    }
}

-(void) onSetting:(UIButton*)btn
{
    [UIView animateWithDuration:0.03 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.03f animations:^{
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [self hideAllContext];
                             
                             MRSettingsViewController *settingVC = [[MRSettingsViewController alloc] initWithNibName:@"MRSettingsViewController" bundle:[NSBundle mainBundle]];
                             __weak id wself = self;
                             
                             if(IS_OS_7_OR_LATER)   {
                                 MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:settingVC];
                                 formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
                                 formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
                                     
                                     [wself buttonsConfigure];
                                     [wself buttonsReposition];
                                     [wself noAnimateShowActivations];
                                     [wself showAllContext];
                                 };
                                 [formSheet presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                                     
                                 }];
                             } else {
                                 UINavigationController *navCntrl = [[UINavigationController alloc] init];
                                 navCntrl.navigationBarHidden = YES;
                                 
                                 [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:(__bridge CGColorRef)([UIColor clearColor])];
                                 [self presentFormSheetWithViewController:navCntrl animated:NO transitionStyle:MZFormSheetTransitionStyleFade completionHandler:^(MZFormSheetController *formSheetController) {
                                     formSheetController.landscapeTopInset = 0.0f;
                                     formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
                                     formSheetController.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
                                         [wself buttonsConfigure];
                                         [wself buttonsReposition];
                                         [wself noAnimateShowActivations];
                                         [wself showAllContext];
                                     };
                                     [formSheetController presentViewController:settingVC animated:YES completion:^{
                                         
                                     }];
                                 }];
                             }
                         }];
                     }];
}

-(void) buttonsConfigure
{
    if(activationButtonsArray.count != 0)   {
        for ( PMActivationView *button in activationButtonsArray )
        {
            [button removeFromSuperview];
        }
    }
    
    activationButtonsArray = [[NSMutableArray alloc] init];
    
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eBarcode withText:YES]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eLogo withText:YES]];
    //[activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eStamp withText:YES]];
    //[activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:ePrint withText:YES]];
    
    [self activationsStatusRefresh];
}

-(void) activationsStatusRefresh
{
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tempBuffer = [[NSMutableArray alloc] init];
    
    for ( PMActivationView *button in activationButtonsArray )
    {
        NSString *activationName = [NSString stringWithFormat:@"%i", button.ids];
        BOOL activationStatusDisable = [[userSettings objectForKey:activationName] boolValue];
        if(activationStatusDisable)
            [tempBuffer addObject:button];
    }
    
    [activationButtonsArray removeObjectsInArray:tempBuffer];
}

-(void) buttonsReposition
{
    if(activationButtonsArray.count == 0) return;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    
    NSInteger buttonCount = activationButtonsArray.count;
    PMActivationView *actButton = [activationButtonsArray objectAtIndex:0];
    
    NSInteger offsetPx = (screenWidth - actButton.frame.size.width*buttonCount) / (buttonCount+1);
    NSInteger indexSpace = 1;
    NSInteger indexButton = 0;
    
    for ( PMActivationView *button in activationButtonsArray )
    {
        button.delegate = self;
        button.frame = CGRectOffset(button.frame, (offsetPx * indexSpace) + (actButton.frame.size.width * indexButton), 320);
        [self.view addSubview:button];
        ++indexSpace;
        ++indexButton;
    }
}

-(void) animateShowActivations
{
    if(activationButtonsArray.count == 0) return;
    
    __block int loop = 0;
    __block int activeCount = activationButtonsArray.count;
    dispatch_repeated(0.15, dispatch_get_main_queue(), ^(BOOL *stop) {
        PMActivationView *button = [activationButtonsArray objectAtIndex:loop];
        
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
            CGRect btnRect = button.frame;
            btnRect.origin.y = 277;
            button.frame = btnRect;
            
            button.activeButton.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                button.englishDesc.alpha = 1;
            }];
        }];
        
        if(loop == (activeCount-1)) {
            [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                titleLabel.alpha = 1;
            } completion:^(BOOL finished) {
                //
            }];
            *stop = YES;
        }   else loop++;
    });
}

-(void) noAnimateShowActivations
{
    for ( PMActivationView *button in activationButtonsArray )
    {
        CGRect btnRect = button.frame;
        btnRect.origin.y = 277;
        button.frame = btnRect;
        
        button.activeButton.alpha = 1;
        button.englishDesc.alpha = 1;
    }
}

static void dispatch_repeated_internal(dispatch_time_t firstPopTime, double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop))
{
    __block BOOL shouldStop = NO;
    dispatch_time_t nextPopTime = dispatch_time(firstPopTime, (int64_t)(intervalInSeconds * NSEC_PER_SEC));
    dispatch_after(nextPopTime, queue, ^{
        work(&shouldStop);
        if(!shouldStop)
        {
            dispatch_repeated_internal(nextPopTime, intervalInSeconds, queue, work);
        }
    });
}

void dispatch_repeated(double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop))
{
    dispatch_time_t firstPopTime = dispatch_time(DISPATCH_TIME_NOW, intervalInSeconds * NSEC_PER_SEC);
    dispatch_repeated_internal(firstPopTime, intervalInSeconds, queue, work);
}

-(void) activationView:(PMActivationView*)activationView didSelectWithID:(ActivationIDs)ids
{
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    BOOL shortRegForm = [[userSettings objectForKey:@"ShortRegForm"] boolValue];
    
    if(ids == eStamp) {
        [self openRegistrationForm:ids];
        /*[self hideAllContext];
        __weak id wself = self;
        MRStampRootViewController *stampController = [[MRStampRootViewController alloc] init];
        MZFormSheetController *stampSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:[[UINavigationController alloc] initWithRootViewController:stampController]];
        stampSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [wself showAllContext];
        };
        
        [stampSheet presentFormSheetController:stampSheet animated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            NSLog(@"Stamp view controller present");
        }];*/
        return;
    }
    
    if(shortRegForm)    {
        [self openGameForm:ids];
    } else  {
        [self openRegistrationForm:ids];
    }
}

-(void) openGameForm:(ActivationIDs)ids
{
    [self hideAllContext];
    
    MRGameViewController *gameController = [[MRGameViewController alloc] initWithActiveID:ids];
    __weak id wself = self;
    
    if( IS_OS_7_OR_LATER )  {
        MZFormSheetController *registraionSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:[[UINavigationController alloc] initWithRootViewController:gameController]];
        registraionSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            UINavigationController *navCntrl = (UINavigationController*)presentedFSViewController;
            MRGameViewController *regVC = ((MRGameViewController*)([navCntrl.viewControllers objectAtIndex:0]));
            if(regVC.isExit)
                [wself showAllContext];
            else
                [self openRegistrationForm:ids];
        };
        
        [registraionSheet presentFormSheetController:registraionSheet animated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            NSLog(@"Registartion view controller present");
        }];
    } else  {
        UINavigationController *navCntrl = [[UINavigationController alloc] init];
        navCntrl.navigationBarHidden = YES;
        
        //registrationController.formSheetController.transitionStyle = MZFormSheetTransitionStyleSlideFromLeft;
        [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:(__bridge CGColorRef)([UIColor clearColor])];
        [self presentFormSheetWithViewController:navCntrl animated:NO transitionStyle:MZFormSheetTransitionStyleSlideAndBounceFromLeft completionHandler:^(MZFormSheetController *formSheetController) {
            
            formSheetController.landscapeTopInset = 0.0f;
            
            formSheetController.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
                UINavigationController *navCntrl = (UINavigationController*)presentedFSViewController;
                MRGameViewController *regVC = ((MRGameViewController*)([navCntrl.viewControllers objectAtIndex:0]));
                if(regVC.isExit)
                    [wself showAllContext];
                else
                    [self openRegistrationForm:ids];
            };
            
            [formSheetController presentViewController:[[UINavigationController alloc] initWithRootViewController:gameController] animated:NO completion:^{
                
            }];
        }];
    }
}

-(void) openRegistrationForm:(ActivationIDs)ids
{
    if(ids == eBarcode || ids == eLogo || ids == eStamp) {
    
        [self hideAllContext];
        
        MRRegistrationViewController *registrationController = [[MRRegistrationViewController alloc] initWithActiveID:ids];
        
        __weak id wself = self;
        
        if( IS_OS_7_OR_LATER )  {
            MZFormSheetController *registraionSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:[[UINavigationController alloc] initWithRootViewController:registrationController]];
            registraionSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
                MRRegistrationViewController *regVC = (MRRegistrationViewController*)presentedFSViewController;
                [wself showAllContext];
            };
            
            [registraionSheet presentFormSheetController:registraionSheet animated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                NSLog(@"Registartion view controller present");
            }];
        } else  {
            UINavigationController *navCntrl = [[UINavigationController alloc] init];
            navCntrl.navigationBarHidden = YES;
            
            //registrationController.formSheetController.transitionStyle = MZFormSheetTransitionStyleSlideFromLeft;
            [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:(__bridge CGColorRef)([UIColor clearColor])];
            [self presentFormSheetWithViewController:navCntrl animated:NO transitionStyle:MZFormSheetTransitionStyleSlideAndBounceFromLeft completionHandler:^(MZFormSheetController *formSheetController) {
                
                formSheetController.landscapeTopInset = 0.0f;
                
                formSheetController.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
                    MRRegistrationViewController *regVC = (MRRegistrationViewController*)presentedFSViewController;
                    [wself showAllContext];
                };
                
                [formSheetController presentViewController:[[UINavigationController alloc] initWithRootViewController:registrationController] animated:NO completion:^{
                    
                }];
            }];
        }
    }
}

@end
