//
//  MRSettingsViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 01.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRSettingsViewController.h"
#import <MZFormSheetController/MZFormSheetController.h>
#import "PMActivationView.h"

@interface MRSettingsViewController () <PMActivationViewDelegate>
@property (nonatomic, strong) NSMutableArray *activationButtonsArray;
@end

@implementation MRSettingsViewController
{
    NSUserDefaults *userSettings;
    UIButton *settingButton;
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
    
    userSettings = [NSUserDefaults standardUserDefaults];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    
    UIImage *settingImage = [UIImage imageNamed:@"settings-close-small.png"];
    settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.alpha = 0;
    [settingButton addTarget:self action:@selector(onSettingClose:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton setImage:settingImage forState:UIControlStateHighlighted];
    settingButton.frame = CGRectMake(screenWidth - settingImage.size.width - 10, 10, settingImage.size.width, settingImage.size.height);
    [self.view addSubview:settingButton];
    
    [self buttonsConfigure];
    [self buttonsReposition];
    [self noAnimateShowActivations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) onSettingClose:(UIButton*)btn
{
    [UIView animateWithDuration:0.05 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];
    
    [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

-(void) buttonsConfigure
{
    // read from config
    
    activationButtonsArray = [[NSMutableArray alloc] init];
    
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eBarcode withText:NO]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eLogo withText:NO]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eStamp withText:NO]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:ePrint withText:NO]];
    
    [self activationsStatusRefresh];
}

-(void) activationsStatusRefresh
{
    for ( PMActivationView *button in activationButtonsArray )
    {
        NSString *activationName = [NSString stringWithFormat:@"%i", button.ids];
        BOOL activationStatus = [[userSettings objectForKey:activationName] boolValue];
        [button disableActivation:activationStatus];
    }
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
                settingButton.alpha = 1;
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
    }
    
    settingButton.alpha = 1;
}

-(void) activationView:(PMActivationView*)activationView didSelectWithID:(ActivationIDs)ids
{
    NSString *activationName = [NSString stringWithFormat:@"%i", ids];
    BOOL activationStatus = [[userSettings objectForKey:activationName] boolValue];
    if(activationStatus == NO)  {
        [activationView disableActivation:YES];
    }
    else    {
        [activationView disableActivation:NO];
    }
    
    [userSettings setObject:[NSNumber numberWithBool:!activationStatus] forKey:activationName];
    [userSettings synchronize];
}

@end
