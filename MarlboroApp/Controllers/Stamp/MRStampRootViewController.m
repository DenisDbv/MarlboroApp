//
//  MRStampRootViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 16.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRStampRootViewController.h"
#import "MRPhotoViewController.h"
#import "ALRadialMenu.h"
#import "MRImageBlockView.h"

#import <MZFormSheetController/MZFormSheetController.h>
#import <QuartzCore/QuartzCore.h>

@interface MRStampRootViewController () <ALRadialMenuDelegate, MRPhotoViewControllerDelegate, MRImageBlockViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (strong, nonatomic) ALRadialMenu *mainMenu;

@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) MRPhotoViewController *photoViewController;
@property (nonatomic, strong) MRImageBlockView *imageBlockView;
@end

@implementation MRStampRootViewController
{
    BOOL photoForm;
    BOOL cutForm;
    BOOL resultForm;
}
@synthesize mainMenuButton, mainMenu;
@synthesize photoArray;
@synthesize photoViewController;
@synthesize imageBlockView;

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
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
#endif
    
    photoArray = [[NSMutableArray alloc] initWithObjects:[UIImage new], [UIImage new], [UIImage new], [UIImage new], nil];
    
    photoForm = YES;
    cutForm = resultForm = NO;
    
    self.mainMenu = [[ALRadialMenu alloc] init];
	self.mainMenu.delegate = self;
    
    [self showExitButton];
    
    [self createCameraController];
    [self createImageBlockView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onExit:) name:MROnExitClickNotification object:nil];
    
    [self onMainMenu:self.mainMenuButton];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [photoViewController stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MROnExitClickNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onExit:(NSNotification*)notification
{
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

- (IBAction)onMainMenu:(id)sender {
    [self.mainMenu buttonsWillAnimateFromButton:sender withFrame:self.mainMenuButton.frame inView:self.view];
}

#pragma mark - radial menu delegate methods
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
	return 3;
}


- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu {
	return -90;
}


- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
	return 120;
}


- (UIImage *) radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger) index {
	if (index == 1) {
        return [UIImage imageNamed:@"result"];
    } else if (index == 2) {
        return [UIImage imageNamed:@"cut"];
    } else if (index == 3) {
        return [UIImage imageNamed:@"photo"];
    }
	
	return nil;
}

- (float) buttonSizeForRadialMenu:(ALRadialMenu *)radialMenu
{
    return 50.0f;
}

- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
	if (index == 1) {
        resultForm = YES;
        photoForm = cutForm = NO;
        NSLog(@"photo form select");
        
        [self destroyCameraController];
    } else if (index == 2) {
        cutForm = YES;
        photoForm = resultForm = NO;
        NSLog(@"cut form select");
        
        [self destroyCameraController];
    } else if (index == 3 && !photoForm) {
        photoForm = YES;
        cutForm = resultForm = NO;
        NSLog(@"result form select");
        
        [self openCameraController];
    }
}

#pragma mark - camera methods
-(void) createCameraController
{
    photoViewController = [[MRPhotoViewController alloc] init];
    photoViewController.delegate = self;
    
    [self openCameraController];
}

-(void) openCameraController
{
    photoViewController.view.frame = self.view.frame;
    [self.view insertSubview:photoViewController.view belowSubview:[self.view viewWithTag:10]];
    [self addChildViewController:photoViewController];
    [photoViewController didMoveToParentViewController:self];
    
    [photoViewController showAllContext];
}

-(void) destroyCameraController
{
    [photoViewController didMoveToParentViewController:nil];
    [[photoViewController view] removeFromSuperview];
    [photoViewController removeFromParentViewController];
    //[photoViewController stop];
    
    [photoViewController hideAllContext];
}

-(void) photoDidDone:(UIImage*)image
{
    NSInteger currentIndex = [imageBlockView selectItem];
    
    [photoArray replaceObjectAtIndex:currentIndex withObject:image];
    
    [imageBlockView setImage:image byIndex:currentIndex];
    [imageBlockView nextItem];
}

#pragma mark - image block view methods
-(void) createImageBlockView
{
    imageBlockView = [[MRImageBlockView alloc] initWithFrame:CGRectMake( (CGRectGetWidth(self.view.bounds) - 700)/2+80, (CGRectGetHeight(self.view.bounds) - 150 - 5), 700, 150)];
    imageBlockView.delegate = self;
    [self.view addSubview:imageBlockView];
}

-(void) imageBlockClickedByIndex:(NSInteger)index
{
    if(photoForm)   {
        NSInteger currentIndex = [imageBlockView selectItem];
        UIImage *currentImage = photoArray[currentIndex];
        
        [photoViewController showModalImage:currentImage];
    }
}

@end
