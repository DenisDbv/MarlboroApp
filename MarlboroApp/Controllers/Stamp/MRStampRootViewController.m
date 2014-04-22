//
//  MRStampRootViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 16.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRStampRootViewController.h"
#import "MRPhotoViewController.h"
#import "MRCropperViewController.h"
#import "MRFilterViewController.h"
#import "MRResultStampViewController.h"
#import "ALRadialMenu.h"
#import "MRImageBlockView.h"
#import "StampSavedView.h"

#import <MZFormSheetController/MZFormSheetController.h>
#import <QuartzCore/QuartzCore.h>

@interface MRStampRootViewController () <ALRadialMenuDelegate, MRPhotoViewControllerDelegate, MRImageBlockViewDelegate, MRCropperViewControllerDelegate, MRFilterViewControllerDelegate, StampSavedViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (strong, nonatomic) ALRadialMenu *mainMenu;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *photoCroppedArray;
@property (nonatomic, strong) NSMutableArray *photoFilteredArray;

@property (nonatomic, strong) MRPhotoViewController *photoViewController;
@property (nonatomic, strong) MRImageBlockView *imageBlockView;
@property (nonatomic, strong) MRCropperViewController *cropperViewController;
@property (nonatomic, strong) MRFilterViewController *filterViewController;
@property (nonatomic, strong) MRResultStampViewController *resultStampViewController;
@end

@implementation MRStampRootViewController
{
    BOOL photoForm;
    BOOL cutForm;
    BOOL filterForm;
    BOOL resultForm;
    
    NSArray *menuButtonImages;
}
@synthesize mainMenuButton, mainMenu;
@synthesize photoArray, photoCroppedArray, photoFilteredArray;
@synthesize photoViewController;
@synthesize imageBlockView;
@synthesize cropperViewController;
@synthesize filterViewController;
@synthesize resultStampViewController;

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
    
    menuButtonImages = @[[UIImage imageNamed:@"200x-photo-1.png"], [UIImage imageNamed:@"200x-crop-2.png"], [UIImage imageNamed:@"200x-filt-2.png"], [UIImage imageNamed:@"200x-letter-2.png"], [UIImage imageNamed:@"exit.png"]];
    
    photoArray = [[NSMutableArray alloc] initWithObjects:[UIImage new], [UIImage new], [UIImage new], [UIImage new], nil];
    photoCroppedArray = [[NSMutableArray alloc] initWithObjects:[UIImage new], [UIImage new], [UIImage new], [UIImage new], nil];
    photoFilteredArray = [[NSMutableArray alloc] initWithObjects:[UIImage new], [UIImage new], [UIImage new], [UIImage new], nil];
    
    photoForm = YES;
    cutForm = filterForm = resultForm = NO;
    
    self.mainMenu = [[ALRadialMenu alloc] init];
	self.mainMenu.delegate = self;
    //[self showExitButton];
    
    [self createCameraController];
    [self createImageBlockView];
    [self createCropController];
    [self createFilterController];
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onExit:) name:MROnExitClickNotification object:nil];
}

-(void) viewDidAppear:(BOOL)animated    {
    [self onMainMenu:self.mainMenuButton];
    [self openCameraController];
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
	return menuButtonImages.count;
}


- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu {
	return 90;
}


- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
	return 150;
}


- (UIImage *) radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger) index {
	return menuButtonImages[index-1];
}

- (float) buttonSizeForRadialMenu:(ALRadialMenu *)radialMenu
{
    return 50.0f;
}

- (BOOL) radialMenu:(ALRadialMenu *)radialMenu isButtonEnable:(NSInteger) index {
    if(index == 2 || index == 3 || index == 4)   {
        return NO;
    }
    return YES;
}

- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
	if (index == 1 && !photoForm) {
        photoForm = YES;
        cutForm = filterForm = resultForm = NO;
        
        [self destroyCropperController];
        [self destroyFilterController];
        [self destroyResultController];
        [self openCameraController];
        
        [imageBlockView firstItem];
    } else if (index == 2 && !cutForm) {
        cutForm = YES;
        photoForm = filterForm = resultForm = NO;
        
        [self destroyFilterController];
        [self destroyCameraController];
        [self destroyResultController];
        [self openCropperController];
        
        [imageBlockView firstItem];
    } else if (index == 3 && !filterForm) {
        filterForm = YES;
        photoForm = cutForm = resultForm = NO;
        
        [self destroyResultController];
        [self destroyCropperController];
        [self destroyCameraController];
        [self openFilterController];
        
        [imageBlockView firstItem];
    } else if (index == 4 && !resultForm)  {
        resultForm = YES;
        photoForm = cutForm = filterForm = NO;
        
        [self destroyCameraController];
        [self destroyCropperController];
        [self destroyFilterController];
        
        [self createResultController];
        [self openResultController];
    } else if (index == 5)  {
        [self onExit:nil];
    }
    
    if(index != 3)  {
        [self centerImageBlockView];
    }
}

-(BOOL) isArrayImagesFull:(NSArray*)array   {
    BOOL ret = YES;
    for(UIImage *image in array)    {
        if(image.size.width == 0)
            ret = NO;
    }
    return ret;
}

#pragma mark - camera methods
-(void) createCameraController
{
    photoViewController = [[MRPhotoViewController alloc] init];
    photoViewController.delegate = self;
}

-(void) openCameraController
{
    photoViewController.view.frame = self.view.frame;
    [self.view insertSubview:photoViewController.view belowSubview:[self.view viewWithTag:10]];
    [self addChildViewController:photoViewController];
    [photoViewController didMoveToParentViewController:self];
    
    [photoViewController showAllContext];
    [self imageBlockClickedByIndex:0];
}

-(void) destroyCameraController
{
    [photoViewController didMoveToParentViewController:nil];
    [[photoViewController view] removeFromSuperview];
    [photoViewController removeFromParentViewController];
    //[photoViewController stop];
    
    [photoViewController hideAllContext];
}

-(void) photoSessionDidStart    {
    [UIView animateWithDuration:0.25f animations:^{
        imageBlockView.frame = CGRectMake( (CGRectGetWidth(self.view.bounds) - 600)/2, (CGRectGetHeight(self.view.bounds) - 120 - 5), 600, 120);
        imageBlockView.alpha = 1;
    }];
    
    [photoViewController showAllContext];
}

-(void) photoDidDone:(UIImage*)image
{
    NSInteger currentIndex = [imageBlockView selectItem];
    
    [photoArray replaceObjectAtIndex:currentIndex withObject:image];
    
    [imageBlockView setImage:image byIndex:currentIndex];
    [imageBlockView nextItem];
    
    if([self isArrayImagesFull:photoArray]) {
        [self.mainMenu willEnableButtonIndex:1 withImage:[UIImage imageNamed:@"200x-crop-1.png"]];
    }
}

#pragma mark - image block view methods
-(void) createImageBlockView
{
    imageBlockView = [[MRImageBlockView alloc] initWithFrame:CGRectMake( (CGRectGetWidth(self.view.bounds) - 600)/2, (CGRectGetHeight(self.view.bounds)), 600, 120)];
    imageBlockView.alpha = 0;
    imageBlockView.delegate = self;
    [self.view addSubview:imageBlockView];
}

-(void) centerImageBlockView    {
    [UIView animateWithDuration:0.25f animations:^{
        imageBlockView.frame = CGRectMake( (CGRectGetWidth(self.view.bounds) - 600)/2, (CGRectGetHeight(self.view.bounds) - 120 - 5), 600, 120);
    }];
}

-(void) imageBlockClickedByIndex:(NSInteger)index
{
    NSInteger currentIndex = [imageBlockView selectItem];
    
    if(photoForm)   {
        UIImage *currentImage = photoArray[currentIndex];
        [photoViewController showModalImage:currentImage];
    } else if(cutForm)  {
        UIImage *currentImage = photoArray[currentIndex];
        [cropperViewController setImageForCrop:currentImage];
    } else if(filterForm)   {
        UIImage *currentImage = photoCroppedArray[currentIndex];
        [filterViewController setImageForFilter:currentImage];
    }
}

#pragma mark - crop view methods
-(void) createCropController    {
    cropperViewController = [MRCropperViewController new];
    cropperViewController.delegate = self;
}

-(void) openCropperController   {
    cropperViewController.view.frame = self.view.frame;
    [self.view insertSubview:cropperViewController.view aboveSubview:[self.view viewWithTag:10]];
    [self addChildViewController:cropperViewController];
    [cropperViewController didMoveToParentViewController:self];
    
    [cropperViewController showAllContext];
    
    UIImage *currentImage = photoArray[0];
    [cropperViewController setImageForCrop:currentImage];
}

-(void) destroyCropperController    {
    [cropperViewController didMoveToParentViewController:nil];
    [[cropperViewController view] removeFromSuperview];
    [cropperViewController removeFromParentViewController];
    
    [cropperViewController hideAllContext];
}

-(void) cropDidDoneImage:(UIImage*)image
{
    NSLog(@"Crop image %@", NSStringFromCGSize(image.size));
    
    NSInteger currentIndex = [imageBlockView selectItem];
    [photoCroppedArray replaceObjectAtIndex:currentIndex withObject:image];
    
    [imageBlockView setImage:image byIndex:currentIndex];
    
    if([self isArrayImagesFull:photoCroppedArray]) {
        [self.mainMenu willEnableButtonIndex:2 withImage:[UIImage imageNamed:@"200x-filt-1.png"]];
    }
}

#pragma mark - filter controller methods
-(void) createFilterController  {
    filterViewController = [MRFilterViewController new];
    filterViewController.delegate = self;
}

-(void) openFilterController   {
    filterViewController.view.frame = self.view.frame;
    [self.view insertSubview:filterViewController.view aboveSubview:[self.view viewWithTag:10]];
    [self addChildViewController:filterViewController];
    [filterViewController didMoveToParentViewController:self];
    
    UIImage *currentImage = photoCroppedArray[0];
    [filterViewController setImageForFilter:currentImage];
}

-(void) destroyFilterController    {
    [filterViewController didMoveToParentViewController:nil];
    [[filterViewController view] removeFromSuperview];
    [filterViewController removeFromParentViewController];
}

-(void) filterShowSideBar   {
    [UIView animateWithDuration:0.25f animations:^{
        imageBlockView.frame = CGRectOffset(imageBlockView.frame, -75, 0);
    }];
}

-(void) filterDidDoneImage:(UIImage*)image  {
    NSInteger currentIndex = [imageBlockView selectItem];
    [photoFilteredArray replaceObjectAtIndex:currentIndex withObject:image];
    
    [imageBlockView setImage:image byIndex:currentIndex];
    
    if([self isArrayImagesFull:photoFilteredArray]) {
        [self.mainMenu willEnableButtonIndex:3 withImage:[UIImage imageNamed:@"200x-letter-1.png"]];
    }
}

#pragma mark - result stamp controller methods
-(void) createResultController  {
    resultStampViewController = [[MRResultStampViewController alloc] initWithStampImages:photoFilteredArray];
    resultStampViewController.delegate = self;
}

-(void) openResultController   {
    imageBlockView.hidden = YES;
    resultStampViewController.view.frame = self.view.frame;
    [self.view insertSubview:resultStampViewController.view aboveSubview:[self.view viewWithTag:10]];
    [self addChildViewController:resultStampViewController];
    [resultStampViewController didMoveToParentViewController:self];
}

-(void) destroyResultController    {
    imageBlockView.hidden = NO;
    [resultStampViewController didMoveToParentViewController:nil];
    [[resultStampViewController view] removeFromSuperview];
    [resultStampViewController removeFromParentViewController];
}

-(void) finishSuccessfulStampController {
    [self destroyResultController];
    
    StampSavedView *finishView = [[StampSavedView alloc] initWithFrame:self.view.frame];
    finishView.delegate = self;
    [finishView setDefault];
    
    if(IS_OS_7_OR_LATER)    {
        self.view = finishView;
    } else  {
        for(UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        
        [self.navigationController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        }];
    }
    
    [finishView animateView];
}

-(void) exitFromFinishView
{
    [self.navigationController.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

@end
