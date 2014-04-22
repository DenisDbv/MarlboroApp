//
//  MRPhotoViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 16.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRPhotoViewController.h"

#import <PBJVision/PBJVision.h>
#import <PBJVision/PBJVisionUtilities.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <GLKit/GLKit.h>
#import <CoreImage/CoreImage.h>

@interface MRPhotoViewController () <PBJVisionDelegate>

@end

@implementation MRPhotoViewController
{
    UIView *_previewView;
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    UIButton *captureButton;
    
    UIImageView *previewImageView;
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
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    [self initPreviewView];
    
    [self start];
}

-(void) viewDidAppear:(BOOL)animated
{
    
}

/*-(void) viewDidDisappear:(BOOL)animated
{
    [self stop];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) orientationChanged:(NSNotification *)note
{
    PBJVision *vision = [PBJVision sharedInstance];
    
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"left");
            [vision setCameraOrientation:PBJCameraOrientationLandscapeRight];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"right");
            [vision setCameraOrientation:PBJCameraOrientationLandscapeLeft];
            
            break;
            
        default:
            break;
    };
}

-(void) initPreviewView
{
    _previewView = [[UIView alloc] initWithFrame:CGRectZero];
    _previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    _previewView.frame = previewFrame;
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
}

-(void) start
{
    [self _resetCapture];
    [[PBJVision sharedInstance] startPreview];
}

-(void) stop
{
    [[PBJVision sharedInstance] stopPreview];
}

-(void) showAllContext
{
    _previewLayer.hidden = NO;
    [self initCaptureButton];
}

-(void) hideAllContext
{
    [self removeCaptureButton];
}

-(void) showModalImage:(UIImage*)image   {
    if(image.size.width == 0)   {
        [self showAllContext];
        
        [previewImageView removeFromSuperview];
        previewImageView = nil;
    } else  {
        _previewLayer.hidden = YES;
        [self hideAllContext];
        
        [previewImageView removeFromSuperview];
        previewImageView = nil;
        
        previewImageView = [[UIImageView alloc] initWithImage:image];
        previewImageView.frame = _previewView.frame;
        [previewImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_previewView addSubview:previewImageView];
    }
}

- (void)_resetCapture
{
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    
    if ([vision isCameraDeviceAvailable:PBJCameraDeviceBack]) {
        [vision setCameraDevice:PBJCameraDeviceBack];
    } else {
        [vision setCameraDevice:PBJCameraDeviceFront];
    }
    
    [vision setCameraMode:PBJCameraModePhoto];
    [vision setCameraOrientation:PBJCameraOrientationLandscapeRight];
    [vision setFocusMode:PBJFocusModeContinuousAutoFocus];
    [vision setOutputFormat:PBJOutputFormatSquare];
    [vision setVideoRenderingEnabled:YES];
}

-(void) initCaptureButton
{
    if(captureButton == nil)    {
        UIImage *saveVoiceImage = [UIImage imageNamed:@"400-shoot.png"];
        captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        captureButton.userInteractionEnabled = YES;
        [captureButton addTarget:self action:@selector(onTakeCapture:) forControlEvents:UIControlEventTouchUpInside];
        [captureButton setImage:saveVoiceImage forState:UIControlStateNormal];
        [captureButton setImage:saveVoiceImage forState:UIControlStateHighlighted];
        captureButton.frame = CGRectMake(self.view.bounds.size.width, self.view.center.y-saveVoiceImage.size.height/4, saveVoiceImage.size.width/2, saveVoiceImage.size.height/2);
        captureButton.alpha = 0;
        
        [self.view.superview insertSubview:captureButton aboveSubview:self.view.superview];
        
        [UIView animateWithDuration:0.25f animations:^{
            captureButton.frame = CGRectMake(self.view.bounds.size.width - saveVoiceImage.size.width/2 - 10, self.view.center.y-saveVoiceImage.size.height/4, saveVoiceImage.size.width/2, saveVoiceImage.size.height/2);
            captureButton.alpha = 1;
        }];
    }
}

-(void) removeCaptureButton
{
    [captureButton removeFromSuperview];
    captureButton = nil;
}

-(void) onTakeCapture:(UIButton*)button
{
    [UIView animateWithDuration:0.05 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [[PBJVision sharedInstance] capturePhoto];
                         }];
                     }];
}

#pragma mark - PBJVisionDelegate

- (void)visionSessionWillStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStart:(PBJVision *)vision
{
    if (![_previewView superview]) {
        [self.view addSubview:_previewView];
    }
    
    if([self.delegate respondsToSelector:@selector(photoSessionDidStart)]) {
        [self.delegate photoSessionDidStart];
    }
}

- (void)visionSessionDidStop:(PBJVision *)vision
{
    [self removeCaptureButton];
    [_previewView removeFromSuperview];
}

- (void)visionModeWillChange:(PBJVision *)vision
{
}

- (void)visionModeDidChange:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision didChangeCleanAperture:(CGRect)cleanAperture
{
}

- (void)visionWillStartFocus:(PBJVision *)vision
{
}

- (void)visionDidStopFocus:(PBJVision *)vision
{
    
}

- (void)visionWillCapturePhoto:(PBJVision *)vision
{
    NSLog(@"START");
}

- (void)visionDidCapturePhoto:(PBJVision *)vision
{
    NSLog(@"END");
    [[PBJVision sharedInstance] unfreezePreview];
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error
{
    UIImage *image = [photoDict objectForKey:PBJVisionPhotoImageKey];
    
    if([self.delegate respondsToSelector:@selector(photoDidDone:)]) {
        [self.delegate photoDidDone:image];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
