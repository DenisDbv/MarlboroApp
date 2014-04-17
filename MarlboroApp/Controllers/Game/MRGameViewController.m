//
//  MRGameViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 15.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRGameViewController.h"
#import "MRRegistrationViewController.h"

#import <MZFormSheetController/MZFormSheetController.h>

@interface MRGameViewController ()

@end

@implementation MRGameViewController
{
    ActivationIDs _activeID;
    
    UIButton *leftButton, *centerButton, *rightButton;
    UIImage *leftTopImage, *centerTopImage, *rightTopImage;
    UIImage *leftBottomImage, *centerBottomImage, *rightBottomImage;
    
    NSMutableArray *buttonIndexArray;
    NSMutableArray *topImageArray;
    NSMutableArray *bottomImageArray;
}
@synthesize isExit;

- (id)initWithActiveID:(ActivationIDs)activeID
{
    self = [super initWithNibName:@"MRGameViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _activeID = activeID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isExit = NO;
    
    [self initializeGameObjects];
    
    [self animateShowActivations];
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onExit:) name:MROnExitClickNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MROnExitClickNotification object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self showExitButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)onExit:(id)sender
{
    isExit = YES;
    
    if( IS_OS_7_OR_LATER )  {
        [self.navigationController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            //
        }];
    } else  {
        [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            //
        }];
    }
}

-(void) initializeGameObjects
{
    if(_activeID == eLogo)  {
        leftTopImage = [UIImage imageNamed:@"bullion_top_logo_left.png"];
        centerTopImage = [UIImage imageNamed:@"bullion_top_logo_center.png"];
        rightTopImage = [UIImage imageNamed:@"bullion_top_logo_right.png"];
    } else if(_activeID == eBarcode)    {
        leftTopImage = [UIImage imageNamed:@"bullion_top_barcode_left.png"];
        centerTopImage = [UIImage imageNamed:@"bullion_top_barcode_center.png"];
        rightTopImage = [UIImage imageNamed:@"bullion_top_barcode_right.png"];
    }
    
    leftBottomImage = [UIImage imageNamed:@"bullion_bottom_germany.png"];
    centerBottomImage = [UIImage imageNamed:@"bullion_bottom_usa.png"];
    rightBottomImage = [UIImage imageNamed:@"bullion_bottom_russia.png"];
    
    buttonIndexArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    topImageArray = [[NSMutableArray alloc] initWithObjects:leftTopImage, centerTopImage, rightTopImage, nil];
    bottomImageArray = [[NSMutableArray alloc] initWithObjects:leftBottomImage, centerBottomImage, rightBottomImage, nil];
    [self randomArrays:buttonIndexArray :topImageArray :bottomImageArray];
    
    NSInteger marginContent = 80;
    NSInteger contentWidth = leftTopImage.size.width + centerTopImage.size.width + rightTopImage.size.width + (marginContent*2);
    NSInteger xOffset = (self.view.bounds.size.width - contentWidth)/2;
    NSInteger yOffset = (self.view.frame.size.height - leftTopImage.size.height)/2;
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(onLeftClick:) forControlEvents:UIControlEventTouchDown];
    [leftButton setImage:[self imageOfTopArray:0] forState:UIControlStateNormal];
    [leftButton setImage:[self imageOfTopArray:0] forState:UIControlStateHighlighted];
    leftButton.frame = CGRectMake(xOffset, yOffset+25, leftTopImage.size.width, leftTopImage.size.height);
    leftButton.alpha = 0;
    [self.view addSubview:leftButton];
    
    centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerButton addTarget:self action:@selector(onCenterClick:) forControlEvents:UIControlEventTouchDown];
    [centerButton setImage:[self imageOfTopArray:1] forState:UIControlStateNormal];
    [centerButton setImage:[self imageOfTopArray:1] forState:UIControlStateHighlighted];
    centerButton.frame = CGRectMake(xOffset+leftButton.frame.size.width+marginContent, yOffset-25, centerTopImage.size.width, centerTopImage.size.height);
    centerButton.alpha = 0;
    [self.view addSubview:centerButton];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(onRightClick:) forControlEvents:UIControlEventTouchDown];
    [rightButton setImage:[self imageOfTopArray:2] forState:UIControlStateNormal];
    [rightButton setImage:[self imageOfTopArray:2] forState:UIControlStateHighlighted];
    rightButton.frame = CGRectMake(centerButton.frame.origin.x+centerButton.frame.size.width+marginContent, yOffset+25, rightTopImage.size.width, rightTopImage.size.height);
    rightButton.alpha = 0;
    [self.view addSubview:rightButton];
}

-(void) randomArrays:(NSMutableArray*)array1 :(NSMutableArray*)array2 :(NSMutableArray*)array3
{
    srandom(time(NULL));
    for (NSInteger x = 0; x < [array1 count]; x++) {
        NSInteger randInt = (random() % ([array1 count] - x)) + x;
        [array1 exchangeObjectAtIndex:x withObjectAtIndex:randInt];
        [array2 exchangeObjectAtIndex:x withObjectAtIndex:randInt];
        [array3 exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
}

-(NSInteger) indexOfImageInButtonArray:(NSInteger)index
{
    if(index > buttonIndexArray.count)  {
        NSLog(@"ERROR. indexOfImageInButtonArray beyond the bounds of the array");
        return 0;
    }
    
    return [[buttonIndexArray objectAtIndex:index] integerValue];
}

-(UIImage*) imageOfTopArray:(NSInteger)index
{
    return [topImageArray objectAtIndex:index];
}

-(UIImage*) imageOfBottomArray:(NSInteger)index
{
    return [bottomImageArray objectAtIndex:index];
}

-(void) onLeftClick:(UIButton*)button
{
    [button setEnabled:NO];
    
    [button setImage:[self imageOfBottomArray:0] forState:UIControlStateNormal];
    [button setImage:[self imageOfBottomArray:0] forState:UIControlStateHighlighted];
    [button setImage:[self imageOfBottomArray:0] forState:UIControlStateDisabled];
    
    [UIView beginAnimations:@"Flip" context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:button cache:NO];
    //[UIView setAnimationDidStopSelector:@selector(stopFlipAnimation)];
    [UIView commitAnimations];
    
    if([self indexOfImageInButtonArray:0] != 1) {
        dispatch_time_t popTimeShake = dispatch_time(DISPATCH_TIME_NOW,
                                                     0.40f * NSEC_PER_SEC);
        dispatch_after(popTimeShake, dispatch_get_main_queue(), ^(void)
                       {
                           [self shakeIt:button withDelta:-2.0f];
                       });
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                2.0f * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [button setEnabled:YES];
            
            [button setImage:[self imageOfTopArray:0] forState:UIControlStateNormal];
            [button setImage:[self imageOfTopArray:0] forState:UIControlStateHighlighted];
            [button setImage:[self imageOfTopArray:0] forState:UIControlStateDisabled];
            
            [UIView beginAnimations:@"Flip" context:NULL];
            [UIView setAnimationDuration:0.35];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:button cache:NO];
            //[UIView setAnimationDidStopSelector:@selector(stopFlipAnimation)];
            [UIView commitAnimations];
        });
    } else  {
        [self animationClosingFormByButton:button];
    }
}

-(void) onCenterClick:(UIButton*)button
{
    [button setEnabled:NO];
    
    [button setImage:[self imageOfBottomArray:1] forState:UIControlStateNormal];
    [button setImage:[self imageOfBottomArray:1] forState:UIControlStateHighlighted];
    [button setImage:[self imageOfBottomArray:1] forState:UIControlStateDisabled];
    
    [UIView beginAnimations:@"Flip" context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:button cache:NO];
    //[UIView setAnimationDidStopSelector:@selector(stopFlipAnimation)];
    [UIView commitAnimations];
    
    if([self indexOfImageInButtonArray:1] != 1) {
        dispatch_time_t popTimeShake = dispatch_time(DISPATCH_TIME_NOW,
                                                     0.40f * NSEC_PER_SEC);
        dispatch_after(popTimeShake, dispatch_get_main_queue(), ^(void)
                       {
                           [self shakeIt:button withDelta:-2.0f];
                       });
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                2.0f * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [button setEnabled:YES];
                           
                           [button setImage:[self imageOfTopArray:1] forState:UIControlStateNormal];
                           [button setImage:[self imageOfTopArray:1] forState:UIControlStateHighlighted];
                           [button setImage:[self imageOfTopArray:1] forState:UIControlStateDisabled];
                           
                           [UIView beginAnimations:@"Flip" context:NULL];
                           [UIView setAnimationDuration:0.35];
                           [UIView setAnimationDelegate:self];
                           [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:button cache:NO];
                           //[UIView setAnimationDidStopSelector:@selector(stopFlipAnimation)];
                           [UIView commitAnimations];
                       });
    } else  {
        [self animationClosingFormByButton:button];
    }
}

-(void) onRightClick:(UIButton*)button
{
    [button setEnabled:NO];
    
    [button setImage:[self imageOfBottomArray:2] forState:UIControlStateNormal];
    [button setImage:[self imageOfBottomArray:2] forState:UIControlStateHighlighted];
    [button setImage:[self imageOfBottomArray:2] forState:UIControlStateDisabled];
    
    [UIView beginAnimations:@"Flip" context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:button cache:NO];
    //[UIView setAnimationDidStopSelector:@selector(stopFlipAnimation)];
    [UIView commitAnimations];
    
    if([self indexOfImageInButtonArray:2] != 1) {
        dispatch_time_t popTimeShake = dispatch_time(DISPATCH_TIME_NOW,
                                                0.40f * NSEC_PER_SEC);
        dispatch_after(popTimeShake, dispatch_get_main_queue(), ^(void)
                       {
                           [self shakeIt:button withDelta:-2.0f];
                       });
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                2.0f * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [button setEnabled:YES];
                           
                           [button setImage:[self imageOfTopArray:2] forState:UIControlStateNormal];
                           [button setImage:[self imageOfTopArray:2] forState:UIControlStateHighlighted];
                           [button setImage:[self imageOfTopArray:2] forState:UIControlStateDisabled];
                           
                           [UIView beginAnimations:@"Flip" context:NULL];
                           [UIView setAnimationDuration:0.35];
                           [UIView setAnimationDelegate:self];
                           [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:button cache:NO];
                           //[UIView setAnimationDidStopSelector:@selector(stopFlipAnimation)];
                           [UIView commitAnimations];
                       });
    } else  {
        [self animationClosingFormByButton:button];
    }
}

-(void) shakeIt:(UIView*)view withDelta:(CGFloat)delta
{
    CAKeyframeAnimation *anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ];
    anim.values = [ NSArray arrayWithObjects:
                   [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(delta, 0.0f, 0.0f) ],
                   [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-delta, 0.0f, 0.0f) ],
                   nil ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 8.0f ;
    anim.duration = 0.03f ;
    
    [view.layer addAnimation:anim forKey:nil ];
}

-(void) extensionIt:(UIView*)view withDelta:(CGFloat)delta
{
    CAKeyframeAnimation *anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ];
    anim.delegate = self;
    [anim setValue:@"exAnimation" forKey:@"tag"];
    anim.values = [ NSArray arrayWithObjects:
                   [ NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0f, 1.0) ],
                   [ NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05f, 1.0) ],
                   [ NSValue valueWithCATransform3D:CATransform3DMakeScale(1.10, 1.10f, 1.0) ],
                   nil ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 1.0f ;
    anim.duration = 0.15f ;
    
    [view.layer addAnimation:anim forKey:nil ];
}

- (void)animationDidStop:(CAKeyframeAnimation *)anim finished:(BOOL)flag
{
    if([anim isKindOfClass:[CAKeyframeAnimation class]]) {
        if(IS_OS_7_OR_LATER)   {
            [self.navigationController.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
        } else {
            [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            }];
        }
    }
}

-(void) animationClosingFormByButton:(UIButton*)button
{
    dispatch_time_t popTimeShake = dispatch_time(DISPATCH_TIME_NOW,
                                                 0.40f * NSEC_PER_SEC);
    dispatch_after(popTimeShake, dispatch_get_main_queue(), ^(void)
                   {
                       [self extensionIt:button withDelta:-2.0f];
                   });
    
    //drop rule
    __block int loop = 0;
    
    if([self indexOfImageInButtonArray:0] == 1) {           //Left
        dispatch_repeated2(0.15, dispatch_get_main_queue(), ^(BOOL *stop) {
            loop++;
            
            if(loop == 1)   {
                [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                    CGRect btnRect = rightButton.frame;
                    btnRect.origin.y += 50;
                    rightButton.frame = btnRect;
                    rightButton.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            } else if(loop == 2)    {
                [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                    CGRect btnRect = centerButton.frame;
                    btnRect.origin.y += 50;
                    centerButton.frame = btnRect;
                    centerButton.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if(loop == 2) {
                [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                    CGRect btnRect = leftButton.frame;
                    btnRect.origin.y -= 50;
                    leftButton.frame = btnRect;
                    leftButton.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
                *stop = YES;
            }
        });
    } else if([self indexOfImageInButtonArray:1] == 1) {    //Center
        dispatch_repeated2(0.15, dispatch_get_main_queue(), ^(BOOL *stop) {
            loop++;
            
            if(loop == 1)   {
                [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                    CGRect btnRect = leftButton.frame;
                    btnRect.origin.y += 50;
                    leftButton.frame = btnRect;
                    leftButton.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            } else if(loop == 2)    {
                [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                    CGRect btnRect = rightButton.frame;
                    btnRect.origin.y += 50;
                    rightButton.frame = btnRect;
                    rightButton.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if(loop == 2) {
                [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                    CGRect btnRect = centerButton.frame;
                    btnRect.origin.y -= 50;
                    centerButton.frame = btnRect;
                    centerButton.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
                *stop = YES;
            }
        });
    } else if([self indexOfImageInButtonArray:2] == 1) {    //Right
        dispatch_repeated2(0.15, dispatch_get_main_queue(), ^(BOOL *stop) {
            loop++;
            
            if(loop == 1)   {
                [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                    CGRect btnRect = leftButton.frame;
                    btnRect.origin.y += 50;
                    leftButton.frame = btnRect;
                    leftButton.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            } else if(loop == 2)    {
                [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                    CGRect btnRect = centerButton.frame;
                    btnRect.origin.y += 50;
                    centerButton.frame = btnRect;
                    centerButton.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if(loop == 2) {
                [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                    CGRect btnRect = rightButton.frame;
                    btnRect.origin.y -= 50;
                    rightButton.frame = btnRect;
                    rightButton.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
                *stop = YES;
            }
        });
    }
}

-(void) animateShowActivations
{
    //__block int loop = 0;
    //dispatch_repeated(0.15, dispatch_get_main_queue(), ^(BOOL *stop) {
    for(int loop = 1; loop <= 3; loop++)    {
        //loop++;
        
        if(loop == 1)   {
            [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                CGRect btnRect = leftButton.frame;
                btnRect.origin.y -= 25;
                leftButton.frame = btnRect;
                leftButton.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        } else if(loop == 2)    {
            [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                CGRect btnRect = centerButton.frame;
                btnRect.origin.y += 25;
                centerButton.frame = btnRect;
                centerButton.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        } else if(loop == 3)    {
            [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                CGRect btnRect = rightButton.frame;
                btnRect.origin.y -= 25;
                rightButton.frame = btnRect;
                rightButton.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            //*stop = YES;
        }
    }
    //});
}

static void dispatch_repeated_internal2(dispatch_time_t firstPopTime, double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop))
{
    __block BOOL shouldStop = NO;
    dispatch_time_t nextPopTime = dispatch_time(firstPopTime, (int64_t)(intervalInSeconds * NSEC_PER_SEC));
    dispatch_after(nextPopTime, queue, ^{
        work(&shouldStop);
        if(!shouldStop)
        {
            dispatch_repeated_internal2(nextPopTime, intervalInSeconds, queue, work);
        }
    });
}

void dispatch_repeated2(double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop))
{
    dispatch_time_t firstPopTime = dispatch_time(DISPATCH_TIME_NOW, intervalInSeconds * NSEC_PER_SEC);
    dispatch_repeated_internal2(firstPopTime, intervalInSeconds, queue, work);
}

@end
