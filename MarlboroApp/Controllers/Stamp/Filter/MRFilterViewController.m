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
    
    GPUImagePicture *staticFilterPicture;
    
    CIImage *filteredImageData;
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
    
    [filterImagesArray insertObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", 1]] atIndex:0];
    [filterImagesArray insertObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", 1]] atIndex:0];
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
    
    if(index == 1)  {
        CIFilter *hatchedFilter;
        CIFilter *sepiaFilter;
        
        CIImage *rawImageData =[[CIImage alloc] initWithImage:originalImage];
        
        hatchedFilter = [CIFilter filterWithName:@"CIHatchedScreen"]; //CIDotScreen //CIHatchedScreen
        [hatchedFilter setDefaults];
        [hatchedFilter setValue:rawImageData forKey:@"inputImage"];
        [hatchedFilter setValue:[NSNumber numberWithFloat:15.00]
                    forKey:@"inputWidth"];
        [hatchedFilter setValue:[NSNumber numberWithFloat:10.00]
                    forKey:@"inputAngle"];
        [hatchedFilter setValue:[NSNumber numberWithFloat:0.30]
                    forKey:@"inputSharpness"];
        filteredImageData = [hatchedFilter valueForKey:@"outputImage"];
        
        sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
        [sepiaFilter setDefaults];
        [sepiaFilter setValue:filteredImageData forKey:@"inputImage"];
        [sepiaFilter setValue:[NSNumber numberWithFloat:0.8f] forKey:@"inputIntensity"];
        
        filteredImageData = [sepiaFilter outputImage];
        UIImage *image = [UIImage imageWithCIImage:filteredImageData];
        
        [filterImageView setImage:image];
        
        if([self.delegate respondsToSelector:@selector(filterDidDoneImage:)]) {
            [self.delegate filterDidDoneImage:image];
        }
        
    } else  if(index == 2)  {
        CIImage *inputImage = [[CIImage alloc] initWithImage: originalImage];
        
        CIImage *outputImage = [self oldPhoto:inputImage withAmount:0.5];
        
        UIImage *image = [UIImage imageWithCIImage:outputImage];
        
        [filterImageView setImage:image];
        
        if([self.delegate respondsToSelector:@selector(filterDidDoneImage:)]) {
            [self.delegate filterDidDoneImage:image];
        }
    } else  {
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
}

-(CIImage *)oldPhoto:(CIImage *)img withAmount:(float)intensity {
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    [sepia setValue:img forKey:kCIInputImageKey];
    [sepia setValue:@(intensity) forKey:@"inputIntensity"]; //1
    
    CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];  //2
    
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:random.outputImage forKey:kCIInputImageKey];
    [lighten setValue:@(1 - intensity) forKey:@"inputBrightness"];
    [lighten setValue:@0.0 forKey:@"inputSaturation"];  //3
    
    CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];  //4
    
    CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
    [composite setValue:croppedImage forKey:kCIInputBackgroundImageKey];  //5
    
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
    [vignette setValue:@(intensity * 2) forKey:@"inputIntensity"];
    [vignette setValue:@(intensity * 30) forKey:@"inputRadius"];  //6
    
    return vignette.outputImage; //7
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
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        staticPicture = [[GPUImagePicture alloc] initWithImage:originalImage
                                           smoothlyScaleOutput:YES];
    //});
}

-(void) setImageForFilter:(UIImage*)image   {
    originalImage = image;
    //originalImage = [self hatchedFilter];
    filterImageView.image = originalImage;
    
    if(originalImage.size.width == 0) return;
    
    [self captureImage];
    NSLog(@"-->%@", NSStringFromCGSize(originalImage.size));
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
