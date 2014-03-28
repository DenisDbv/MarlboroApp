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

#import <MZFormSheetController/MZFormSheetController.h>

@interface MRRootMenuViewController () <PMActivationViewDelegate>
@property (nonatomic, strong) NSMutableArray *activationButtonsArray;
@end

@implementation MRRootMenuViewController
{
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
    
    [self buttonsConfigure];
    [self buttonsReposition];
    [self animateShowActivations];
}

-(void) viewWillAppear:(BOOL)animated
{
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) buttonsConfigure
{
    activationButtonsArray = [[NSMutableArray alloc] init];
    
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eBarcode withText:YES]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eLogo withText:YES]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eStamp withText:YES]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:ePrint withText:YES]];
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
                titleLabel.alpha = 1;
            } completion:^(BOOL finished) {
                //
            }];
            *stop = YES;
        }   else loop++;
    });
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
    [self openRegistrationForm:ids];
}

-(void) openRegistrationForm:(ActivationIDs)ids
{
    [self hideAllContext];
    
    MRRegistrationViewController *registrationController = [[MRRegistrationViewController alloc] initWithNibName:@"MRRegistrationViewController" bundle:[NSBundle mainBundle]];
    
    __weak id wself = self;
    MZFormSheetController *registraionSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:registrationController];
    registraionSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        MRRegistrationViewController *regVC = (MRRegistrationViewController*)presentedFSViewController;
        [wself showAllContext];
    };
    
    [registraionSheet presentFormSheetController:registraionSheet animated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        NSLog(@"Registartion view controller present");
    }];
}

@end
