//
//  MRCropperViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 17.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRCropperViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCropperView.h"
#import "UIImage+Resize.h"

@interface MRCropperViewController ()
@property (nonatomic, retain) ImageCropperView *cropper;
@end

@implementation MRCropperViewController
{
    UIButton *cutButton;
}
@synthesize cropper;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setImageForCrop:(UIImage*)image {
    
    [cropper removeFromSuperview];
    cropper = nil;
    
    cropper = [[ImageCropperView alloc] initWithFrame:CGRectMake(332, 204, 360, 360)];
    cropper.layer.borderWidth = 1.0;
    cropper.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0].CGColor;
    [self.view addSubview:cropper];
    
    [cropper setup];
    cropper.image = image;
}

-(void) initCutButton
{
    if(cutButton == nil)    {
        UIImage *saveVoiceImage = [UIImage imageNamed:@"400-crop.png"];
        cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cutButton.userInteractionEnabled = YES;
        [cutButton addTarget:self action:@selector(onTakeCut:) forControlEvents:UIControlEventTouchUpInside];
        [cutButton setImage:saveVoiceImage forState:UIControlStateNormal];
        [cutButton setImage:saveVoiceImage forState:UIControlStateHighlighted];
        cutButton.frame = CGRectMake(self.view.bounds.size.width, self.view.center.y-saveVoiceImage.size.height/4, saveVoiceImage.size.width/2, saveVoiceImage.size.height/2);
        cutButton.alpha = 0;
        
        [self.view.superview insertSubview:cutButton aboveSubview:self.view.superview];
        
        [UIView animateWithDuration:0.25f animations:^{
            cutButton.frame = CGRectMake(self.view.bounds.size.width - saveVoiceImage.size.width/2 - 10, self.view.center.y-saveVoiceImage.size.height/4, saveVoiceImage.size.width/2, saveVoiceImage.size.height/2);
            cutButton.alpha = 1;
        }];
    }
}

-(void) removeCutButton
{
    [cutButton removeFromSuperview];
    cutButton = nil;
}

-(void) showAllContext  {
    [self initCutButton];
}

-(void) hideAllContext  {
    [self removeCutButton];
}

-(void) onTakeCut:(UIButton*)button
{
    [UIView animateWithDuration:0.05 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [cropper finishCropping];
                             
                             //720
                             UIImage *croppedImage = cropper.croppedImage;
                             if(croppedImage.size.width != croppedImage.size.height)    {
                                 croppedImage = [croppedImage croppedImage:CGRectMake(croppedImage.size.width/2 - 1440, croppedImage.size.height/2 - 1440, 1440, 1440)];
                                 NSLog(@"CROP!!!");
                             }
                             
                             UIImage *img = [croppedImage resizedImage:CGSizeMake(1440, 1440) interpolationQuality:kCGInterpolationHigh];
                             
                             if([self.delegate respondsToSelector:@selector(cropDidDoneImage:)]) {
                                 [self.delegate cropDidDoneImage:img];
                             }
                         }];
                     }];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
