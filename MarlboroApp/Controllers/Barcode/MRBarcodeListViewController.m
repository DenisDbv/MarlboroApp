//
//  MRBarcodeListViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 30.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRBarcodeListViewController.h"
#import "UIImage+BarcodeImage.h"
#import "UIView+GestureBlocks.h"
#import "BarcodeSavedView.h"
#import "PMMailManager.h"

#import <MZFormSheetController/MZFormSheetController.h>

@interface MRBarcodeListViewController () <BarcodeSavedViewDelegate, PMMailManagerDelegate>
@property (nonatomic, strong) NSArray *barcodeImages;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@end

@implementation MRBarcodeListViewController
{
    UILabel *titleLabel;
    
    UIImage *barcode1;
    UIImage *barcode2;
    UIImage *barcode3;
    UIImage *barcode4;
    UIImage *barcode5;
    UIImage *barcode6;
    
    UIImageView *selectedBarcodeImage;
    BOOL isPresentImage;
}
@synthesize carousel;
@synthesize barcodeImages;
@synthesize saveButton;

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
    
    isPresentImage = NO;
    saveButton.alpha = 0;
    
    NSString *dataBufferString = [[MRDataManager sharedInstance].nameValue stringByAppendingString:[MRDataManager sharedInstance].phoneValue];
    NSString *name = ([MRDataManager sharedInstance].nameSignValue) ? [MRDataManager sharedInstance].nameValue : nil;
    NSString *phone = ([MRDataManager sharedInstance].phoneSignValue) ? [MRDataManager sharedInstance].phoneValue : nil;
    NSString *mode = ([MRDataManager sharedInstance].sloganSignValue) ? @"EU" : nil;
    
    NSLog(@"Data for barcode (%@)", dataBufferString);
    NSLog(@"name=%@ phone=%@ mode=%@", name, phone, mode);
    
    barcode1 = [UIImage barcodeWithText:dataBufferString name:name phone:phone mode:mode type:1];
    barcode2 = [UIImage barcodeWithText:dataBufferString name:name phone:phone mode:mode type:2];
    barcode3 = [UIImage barcodeWithText:dataBufferString name:name phone:phone mode:mode type:3];
    barcode4 = [UIImage barcodeWithText:dataBufferString name:name phone:phone mode:mode type:4];
    barcode5 = [UIImage barcodeWithText:dataBufferString name:name phone:phone mode:mode type:5];
    barcode6 = [UIImage barcodeWithText:dataBufferString name:name phone:phone mode:mode type:6];
    
    barcodeImages = @[barcode1, barcode2, barcode3, barcode4, barcode5, barcode6];
    
    carousel.type = iCarouselTypeLinear;
    [carousel reloadData];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.alpha = 1;
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DEFAULT_COLOR_SCHEME;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"ВЫБЕРИТЕ ВАРИАНТ БАРКОДА";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    [self.view addSubview:titleLabel];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self showAllContext];
    [self showExitButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onExit:) name:MROnExitClickNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MROnExitClickNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onExit:(NSNotification*)notification
{
    if(!isPresentImage) {
        [self hideAllContext];
        [self.navigationController popViewControllerAnimated:YES];
    } else  {
        [self backToChooseBarcode];
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [barcodeImages count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //if(view == nil) {
        UIImage *barcodeImage = [barcodeImages objectAtIndex:index];
        //NSLog(@"%@", NSStringFromCGSize(barcodeImage.size));
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400.0, 400.0)];
        ((UIImageView *)view).image = barcodeImage;
        view.contentMode = UIViewContentModeCenter;
        
        [view initialiseTapHandler:^(UIGestureRecognizer *sender) {
            [self presentSelectedImage:((UIImageView*)sender.view).image];
        } forTaps:1];
    //}
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}

-(void) presentSelectedImage:(UIImage*)image
{
    isPresentImage = YES;
    
    selectedBarcodeImage = [[UIImageView alloc] initWithImage:image];
    selectedBarcodeImage.alpha = 0;
    selectedBarcodeImage.center = self.view.center;
    [self.view addSubview:selectedBarcodeImage];
    
    saveButton.frame = CGRectMake((self.view.bounds.size.width-saveButton.frame.size.width)/2,
                                  selectedBarcodeImage.frame.origin.y+selectedBarcodeImage.frame.size.height+50,
                                  saveButton.frame.size.width, saveButton.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        carousel.alpha = 0;
        titleLabel.alpha = 0;
        
        selectedBarcodeImage.alpha = 1;
        saveButton.alpha = 1;
    }];
}

-(void) backToChooseBarcode
{
    isPresentImage = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        carousel.alpha = 1;
        titleLabel.alpha = 1;
        
        selectedBarcodeImage.alpha = 0;
        saveButton.alpha = 0;
    } completion:^(BOOL finished) {
        [selectedBarcodeImage removeFromSuperview];
    }];
}

-(IBAction)onSave:(id)sender
{
    saveButton.enabled = NO;
    
    [self generateImage];
}

-(void) exitFromFinishView
{
    [self.navigationController.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
     //
    }];
}

-(void) generateImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        UIImage *backgroundImage = [UIImage imageNamed:@"result_background.png"];
        UIImage *barcodeImage = selectedBarcodeImage.image;
        
        CGRect backgroundRect = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        CGRect figureRect = CGRectMake((backgroundRect.size.width - barcodeImage.size.width)/2, (backgroundImage.size.height-barcodeImage.size.height)/2, barcodeImage.size.width, barcodeImage.size.height);
        
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 2.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, backgroundRect, backgroundImage.CGImage);
        CGContextDrawImage(context, figureRect, barcodeImage.CGImage);
        
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(resultingImage, nil, nil, nil);
        
        //__weak id wself = self;
        //dispatch_sync( dispatch_get_main_queue(), ^{
        //    [self.view addSubview:[[UIImageView alloc] initWithImage:resultingImage] ];
        //});
        
        PMMailManager *mailManager = [PMMailManager new];
        mailManager.delegate = self;
        [mailManager sendMessageWithTitle:@"Barcode" text:@"Ваш личный код." image:resultingImage filename:@"barcode.png"];
    });
}

-(void) mailSendSuccessfully    {
    BarcodeSavedView *finishView = [[BarcodeSavedView alloc] initWithFrame:self.view.frame];
    finishView.delegate = self;
    [finishView setDefault];
    self.view = finishView;
    
    [finishView animateView];
}

-(void) mailSendFailed  {
    saveButton.enabled = YES;
}

@end
