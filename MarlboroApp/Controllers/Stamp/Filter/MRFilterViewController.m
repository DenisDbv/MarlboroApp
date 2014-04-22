//
//  MRFilterViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 17.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRFilterViewController.h"
#import "GrayscaleContrastFilter.h"

#import "RNFrostedSidebar.h"
#import "GPUImage.h"

@interface MRFilterViewController () <RNFrostedSidebarDelegate>
@property (nonatomic, strong) RNFrostedSidebar *calloutSidebar;

@property (nonatomic, strong) IBOutlet UIView *filterContext;
@property (nonatomic, strong) IBOutlet UIImageView *filterImageView;
@end

@implementation MRFilterViewController
{
    NSMutableArray *filterImagesArray;
    
    UIImage *originalImage;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImagePicture *staticPicture;
}
@synthesize calloutSidebar;
@synthesize filterContext;
@synthesize filterImageView;

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
    
    [self loadFilterImages];
}

-(void) viewWillAppear:(BOOL)animated   {
    [calloutSidebar dismissAnimated:NO];
}

-(void) viewDidAppear:(BOOL)animated    {
    [self initSidebar];
    [calloutSidebar showInViewController:self animated:YES];
    //NSLog(@"%@", NSStringFromCGRect(calloutSidebar.contentView.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) initSidebar   {
    NSArray *colors = @[
               [UIColor colorWithRed:165.0/255.0 green:124.0/255.0 blue:48.0/255.0 alpha:1.0],
               [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0],
               [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0],
               [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0],
               [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0],
               [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0],
               [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0],
               [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0],
               [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0],
               [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0],
               ];
    
    calloutSidebar = [[RNFrostedSidebar alloc] initWithImages:filterImagesArray selectedIndices:[NSMutableIndexSet indexSetWithIndex:0] borderColors:colors];
    calloutSidebar.showFromRight = YES;
    calloutSidebar.isSingleSelect = YES;
    calloutSidebar.delegate = self;
}

-(void) loadFilterImages    {
    filterImagesArray = [NSMutableArray new];
    for(int i = 0; i < 10; i++) {
        [filterImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]]];
    }
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didShowOnScreenAnimated:(BOOL)animatedYesOrNo   {
    [self.view insertSubview:filterContext aboveSubview:self.view];
    /*for(UIView *view in self.view.subviews) {
        NSLog(@"%@", view);
    }*/
}

- (void)sidebar:(RNFrostedSidebar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo  {
    if([self.delegate respondsToSelector:@selector(filterShowSideBar)]) {
        [self.delegate filterShowSideBar];
    }
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    if(originalImage.size.width == 0) return;
    
    [self removeAllTargets];
    [self setFilter:index];
    
    [staticPicture addTarget:filter];
    [staticPicture processImage];
    
    UIImage *image = [filter imageFromCurrentlyProcessedOutputWithOrientation:UIImageOrientationUp];
    
    [filterImageView setImage:image];
    
    if([self.delegate respondsToSelector:@selector(filterDidDoneImage:)]) {
        [self.delegate filterDidDoneImage:image];
    }
}

-(void) setFilter:(int) index {
    switch (index) {
        case 1:{
            filter = [[GPUImageContrastFilter alloc] init];
            [(GPUImageContrastFilter *) filter setContrast:1.75];
        } break;
        case 2: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess"];
        } break;
        case 3: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"02"];
        } break;
        case 4: {
            filter = [[GrayscaleContrastFilter alloc] init];
        } break;
        case 5: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17"];
        } break;
        case 6: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
        } break;
        case 7: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red"];
        } break;
        case 8: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06"];
        } break;
        case 9: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green"];
        } break;
        default:
            filter = [[GPUImageFilter alloc] init];
            break;
    }
}

-(void) removeAllTargets
{
    [staticPicture removeAllTargets];
    [filter removeAllTargets];
}

-(void) captureImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        staticPicture = [[GPUImagePicture alloc] initWithImage:originalImage
                                           smoothlyScaleOutput:YES];
    });
}

-(void) setImageForFilter:(UIImage*)image   {
    originalImage = image;
    filterImageView.image = originalImage;
    
    if(originalImage.size.width == 0) return;
    
    [self captureImage];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
