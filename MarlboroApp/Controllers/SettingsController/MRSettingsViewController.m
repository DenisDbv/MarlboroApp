//
//  MRSettingsViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 01.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRSettingsViewController.h"
#import "PMActivationView.h"

#import <SVSegmentedControl/SVSegmentedControl.h>
#import <MBSwitch/MBSwitch.h>
#import <MZFormSheetController/MZFormSheetController.h>

@interface MRSettingsViewController () <PMActivationViewDelegate>
@property (nonatomic, strong) NSMutableArray *activationButtonsArray;

@property (strong, nonatomic) IBOutlet UIView *registrationFormView;
@property (strong, nonatomic) IBOutlet MBSwitch *regValueSwitcher;
@property (strong, nonatomic) IBOutlet UILabel *regTitleLeft;
@property (strong, nonatomic) IBOutlet UILabel *regTitleRight;

@end

@implementation MRSettingsViewController
{
    SVSegmentedControl *navSC;
    
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
    
    __block id wself = self;
    navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Механики", @"Кейс", nil]];
    navSC.thumb.tintColor = [UIColor colorWithRed:0.0/255.0 green:48.0/255.0 blue:92.0/255.0 alpha:1.0];
    navSC.height = 46;
    navSC.changeHandler = ^(NSUInteger newIndex) {
        [wself changeSwitchValue:newIndex];
    };
    navSC.frame = CGRectOffset(navSC.frame, self.view.center.x, self.view.frame.size.height - 80);
    [self.view addSubview:navSC];
    
    BOOL shortRegForm = [[userSettings objectForKey:@"ShortRegForm"] boolValue];
    self.regValueSwitcher.delegate = self;
    [self.regValueSwitcher setOnTintColor:[UIColor lightGrayColor]];//[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.00f]];
    [self.regValueSwitcher setOffTintColor:[UIColor lightGrayColor]];//[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.00f]];
    [self.regValueSwitcher setTintColor:[UIColor lightGrayColor]];//[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.00f]
    [self.regValueSwitcher setThumbTintColor:[UIColor colorWithRed:0.0/255.0 green:20.0/255.0 blue:46.0/255.0 alpha:1.0]];
    [self.regValueSwitcher setOn:shortRegForm];
    
    self.regTitleLeft.font = [UIFont fontWithName:@"MyriadPro-Cond" size:20.0];
    self.regTitleLeft.backgroundColor = [UIColor clearColor];
    self.regTitleLeft.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    self.regTitleLeft.textAlignment = NSTextAlignmentCenter;
    self.regTitleRight.font = [UIFont fontWithName:@"MyriadPro-Cond" size:20.0];
    self.regTitleRight.backgroundColor = [UIColor clearColor];
    self.regTitleRight.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    self.regTitleRight.textAlignment = NSTextAlignmentCenter;
    
    [self switchSetRightPosition:shortRegForm];
    
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
    
    self.registrationFormView.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) changeSwitchValue:(NSInteger)newIndex
{
    if(newIndex == 0)   {
        self.registrationFormView.alpha = 0.0;
        
        for ( PMActivationView *button in activationButtonsArray )
        {
            button.alpha = 1;
        }
    }
    else if(newIndex == 1)  {
        self.registrationFormView.alpha = 1.0;
        for ( PMActivationView *button in activationButtonsArray )
        {
            button.alpha = 0;
        }
    }
}

-(void) onSettingClose:(UIButton*)btn
{
    [userSettings setObject:[NSNumber numberWithBool:self.regValueSwitcher.on] forKey:@"ShortRegForm"];
    
    [UIView animateWithDuration:0.05 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];
    
    if(IS_OS_7_OR_LATER)   {
        [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            
        }];
    } else {
        [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            //formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
        }];
    }
}

-(void) buttonsConfigure
{
    // read from config
    
    activationButtonsArray = [[NSMutableArray alloc] init];
    
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eBarcode withText:NO]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eLogo withText:NO]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eStamp withText:NO]];
    //[activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:ePrint withText:NO]];
    
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

-(void) switchSetRightPosition:(BOOL)on
{
    if(on)
    {
        self.regTitleLeft.font = [UIFont fontWithName:@"MyriadPro-Cond" size:20.0];
        self.regTitleRight.font = [UIFont fontWithName:@"MyriadPro-Cond" size:32.0];
        
        CGPoint location = self.regTitleRight.center;
    }
    else
    {
        self.regTitleLeft.font = [UIFont fontWithName:@"MyriadPro-Cond" size:32.0];
        self.regTitleRight.font = [UIFont fontWithName:@"MyriadPro-Cond" size:20.0];
        
        CGPoint location = self.regTitleLeft.center;
    }
}

@end
