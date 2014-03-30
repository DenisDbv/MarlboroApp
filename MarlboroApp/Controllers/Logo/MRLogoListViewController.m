//
//  MRLogoListViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 31.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRLogoListViewController.h"
#import "UIImage+LogoImage.h"
#import "UIView+GestureBlocks.h"
#import "LogoSavedView.h"
#import "PMMailManager.h"

#import <MZFormSheetController/MZFormSheetController.h>
#import <TYMActivityIndicatorView/TYMActivityIndicatorView.h>

@interface MRLogoListViewController () <LogoSavedViewDelegate, PMMailManagerDelegate>
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@end

@implementation MRLogoListViewController
{
    NSString *name, *phone, *mode;
    
    UIImage *logoImage1;
    UIImage *logoImage2;
    UIImage *logoImage3;
    NSArray *logoImagesArray;
    
    UIImage *logoImageFont1;
    UIImage *logoImageFont2;
    UIImage *logoImageFont3;
    NSArray *logoImageFontsArray;
    
    UILabel *titleLabel;
    
    BOOL isPresentFontsCarousel;
    BOOL isPresentLogoImage;
    
    UIImageView *selectedLogoImage;
    
    TYMActivityIndicatorView *activityIndicator;
}
@synthesize carouselLogoList, carouselLogoFonts;
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
    
    isPresentFontsCarousel = NO;
    isPresentLogoImage = NO;
    
    saveButton.alpha = 0;
    
    name = ([MRDataManager sharedInstance].nameValue.length == 0) ? @"" : [MRDataManager sharedInstance].nameValue;
    phone = ([MRDataManager sharedInstance].phoneValue.length == 0) ? @"" : [MRDataManager sharedInstance].phoneValue;
    mode = ([MRDataManager sharedInstance].sloganValue) ? @"EU" : @"";
    NSLog(@"name=%@ phone=%@ mode=%@", name, phone, mode);
    //name = @"DENIS DUBOV ALEXANDROVICH";
    //phone = @"9063816363";
    //mode = @"EU";
    
    logoImage1 = [UIImage logoWithName:name phone:phone mode:mode fontType:1 type:1];
    logoImage2 = [UIImage logoWithName:name phone:phone mode:mode fontType:1 type:2];
    logoImage3 = [UIImage logoWithName:name phone:phone mode:mode fontType:1 type:3];
    
    logoImagesArray = @[logoImage1, logoImage2, logoImage3];
    
    carouselLogoList.type = iCarouselTypeLinear;
    carouselLogoFonts.type = iCarouselTypeLinear;
    [carouselLogoList reloadData];
    [carouselLogoList scrollToItemAtIndex:1 animated:NO];
    
    carouselLogoFonts.alpha = 0;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.alpha = 1;
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DEFAULT_COLOR_SCHEME;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"ВЫБЕРИТЕ ВАРИАНТ ЛОГОТИПА";
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
    // Dispose of any resources that can be recreated.
}

- (void)onExit:(NSNotification*)notification
{
    if(!isPresentFontsCarousel) {
        [self hideAllContext];
        [self.navigationController popViewControllerAnimated:YES];
    } else  {
        if(!isPresentLogoImage) {
            [self showLogoCarousel];
        } else  {
            [self hidePresentLogoImage];
        }
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if(carousel == carouselLogoList)    {
        return [logoImagesArray count];
    } else if(carousel == carouselLogoFonts)    {
        return [logoImageFontsArray count];
    }
    
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if(carousel == carouselLogoList)    {
        UIImage *logoImage = [logoImagesArray objectAtIndex:index];
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 300.0)];
        ((UIImageView *)view).image = logoImage;
        view.contentMode = UIViewContentModeScaleAspectFill;
        [view initialiseTapHandler:^(UIGestureRecognizer *sender) {
            [UIView animateWithDuration:0.05 animations:^{
                view.transform = CGAffineTransformMakeScale(0.90, 0.90);
            }
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.05f animations:^{
                                     view.transform = CGAffineTransformMakeScale(1, 1);
                                 } completion:^(BOOL finished) {
                                        [self presentSelectedLogoType:index+1];
                                 }];
                             }];
        } forTaps:1];
    } else if(carousel == carouselLogoFonts)    {
        UIImage *logoImage = [logoImageFontsArray objectAtIndex:index];
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 300.0)];
        ((UIImageView *)view).image = logoImage;
        view.contentMode = UIViewContentModeScaleAspectFill;
        [view initialiseTapHandler:^(UIGestureRecognizer *sender) {
            [UIView animateWithDuration:0.05 animations:^{
                view.transform = CGAffineTransformMakeScale(0.90, 0.90);
            }
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.05f animations:^{
                                     view.transform = CGAffineTransformMakeScale(1, 1);
                                 } completion:^(BOOL finished) {
                                     [self presentSelectedLogoFontImage:((UIImageView*)view).image];
                                 }];
                             }];
        } forTaps:1];
    }
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
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
            return value * 1.15f;
        }
        case iCarouselOptionFadeMax:
        {
            if (_carousel.type == iCarouselTypeCustom)
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
    NSLog(@"%i", index);
}

-(void) presentSelectedLogoType:(NSInteger)typeIndex
{
    logoImageFont1 = [UIImage logoWithName:name phone:phone mode:mode fontType:1 type:typeIndex];
    logoImageFont2 = [UIImage logoWithName:name phone:phone mode:mode fontType:2 type:typeIndex];
    logoImageFont3 = [UIImage logoWithName:name phone:phone mode:mode fontType:3 type:typeIndex];
    
    logoImageFontsArray = @[logoImageFont1, logoImageFont2, logoImageFont3];
    
    [carouselLogoFonts reloadData];
    [carouselLogoFonts scrollToItemAtIndex:1 animated:NO];
    
    [self showFontsCarousel];
}

-(void) showFontsCarousel
{
    [UIView animateWithDuration:0.2 animations:^{
        carouselLogoList.alpha = 0;
        carouselLogoFonts.alpha = 1;
    }];
    
    titleLabel.text = @"ВЫБЕРИТЕ ШРИФТ ДЛЯ ЛОГОТИПА";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    isPresentFontsCarousel = YES;
}

-(void) showLogoCarousel
{
    [UIView animateWithDuration:0.2 animations:^{
        carouselLogoList.alpha = 1;
        carouselLogoFonts.alpha = 0;
    }];
    
    titleLabel.text = @"ВЫБЕРИТЕ ВАРИАНТ ЛОГОТИПА";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    isPresentFontsCarousel = NO;
}

-(void) presentSelectedLogoFontImage:(UIImage*)logoImage
{
    isPresentLogoImage = YES;
    
    selectedLogoImage = [[UIImageView alloc] initWithImage:logoImage];
    selectedLogoImage.frame = CGRectMake((self.view.bounds.size.width-400)/2, (self.view.bounds.size.height-400)/2-80, 400, 400);
    selectedLogoImage.contentMode = UIViewContentModeScaleAspectFill;
    selectedLogoImage.alpha = 0;
    [self.view addSubview:selectedLogoImage];
    
    saveButton.frame = CGRectMake((self.view.bounds.size.width-saveButton.frame.size.width)/2,
                                  selectedLogoImage.frame.origin.y+selectedLogoImage.frame.size.height+50,
                                  saveButton.frame.size.width, saveButton.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        carouselLogoFonts.alpha = 0;
        titleLabel.alpha = 0;
        
        selectedLogoImage.alpha = 1;
        saveButton.alpha = 1;
    }];
}

-(void) hidePresentLogoImage
{
    isPresentLogoImage = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        carouselLogoFonts.alpha = 1;
        titleLabel.alpha = 1;
        
        selectedLogoImage.alpha = 0;
        saveButton.alpha = 0;
    }];
}

-(IBAction)onSave:(UIButton*)button
{
    [UIView animateWithDuration:0.05 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                            __weak id wself = self;
                            dispatch_async( dispatch_get_main_queue(), ^{
                                [saveButton setImage:[UIImage imageNamed:@"field_background.png"] forState:UIControlStateNormal];
                                
                                activityIndicator = [[TYMActivityIndicatorView alloc] initWithActivityIndicatorStyle:TYMActivityIndicatorViewStyleNormal];
                                activityIndicator.center = saveButton.center;
                                [self.view addSubview:activityIndicator];
                                [activityIndicator startAnimating];
                            });
                            
                            //saveButton.alpha = 0;
                            saveButton.enabled = NO;
                            
                            [self generateImage];
                         }];
                     }];
}

-(void) generateImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        UIImage *backgroundImage = [UIImage imageNamed:@"result_background.png"];
        UIImage *logoImage = selectedLogoImage.image;
        
        CGRect backgroundRect = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        CGRect figureRect = CGRectMake((backgroundRect.size.width - logoImage.size.width)/2, (backgroundImage.size.height-logoImage.size.height)/2, logoImage.size.width, logoImage.size.height);
        
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 2.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, backgroundRect, backgroundImage.CGImage);
        CGContextDrawImage(context, figureRect, logoImage.CGImage);
        
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //UIImageWriteToSavedPhotosAlbum(resultingImage, nil, nil, nil);
        
        PMMailManager *mailManager = [PMMailManager new];
        mailManager.delegate = self;
        [mailManager sendMessageWithTitle:@"Логотип" text:@"Ваш личный логотип." image:resultingImage filename:@"logo.png"];
    });
}

-(void) mailSendSuccessfully    {
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    LogoSavedView *finishView = [[LogoSavedView alloc] initWithFrame:self.view.frame];
    finishView.delegate = self;
    [finishView setDefault];
    self.view = finishView;
    
    [finishView animateView];
}

-(void) mailSendFailed  {
    [saveButton setImage:[UIImage imageNamed:@"save_btn_large.png"] forState:UIControlStateNormal];
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    //saveButton.alpha = 1;
    
    saveButton.enabled = YES;
}

-(void) exitFromFinishView
{
    [self.navigationController.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

@end
