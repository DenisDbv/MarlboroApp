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
#import <SIAlertView/SIAlertView.h>

@interface MRLogoListViewController () <LogoSavedViewDelegate, PMMailManagerDelegate>
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@end

@implementation MRLogoListViewController
{
    NSString *name, *surName, *patronymicName, *phone, *mode;
    NSString *nameAll;
    
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
    BOOL isSending;
    PMMailManager *mailManager;
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
    surName = ([MRDataManager sharedInstance].surnameValue.length == 0) ? @"" : [MRDataManager sharedInstance].surnameValue;
    patronymicName = ([MRDataManager sharedInstance].patronymicValue.length == 0) ? @"" : [MRDataManager sharedInstance].patronymicValue;
    phone = ([MRDataManager sharedInstance].phoneValue.length == 0) ? @"" : [MRDataManager sharedInstance].phoneValue;
    mode = ([MRDataManager sharedInstance].sloganValue) ? @"EU" : @"";
    NSLog(@"name=\'%@\' surname=\'%@\' patronymicName=\'%@\' phone=\'%@\' mode=\'%@\'", name, surName, patronymicName, phone, mode);
    //name = @"DENIS DUBOV ALEXANDROVICH";
    //phone = @"9063816363";
    //mode = @"EU";
    
    if(name.length == 0 || surName.length == 0 || patronymicName.length == 0)
        nameAll = @"";
    else
        nameAll = [surName stringByAppendingFormat:@" %@ %@", name, patronymicName];
    
    logoImage1 = [UIImage logoWithName:nameAll phone:phone mode:mode fontType:1 type:1];
    logoImage2 = [UIImage logoWithName:nameAll phone:phone mode:mode fontType:1 type:2];
    logoImage3 = [UIImage logoWithName:nameAll phone:phone mode:mode fontType:1 type:3];
    
    logoImagesArray = @[logoImage1, logoImage2, logoImage3];
    
    carouselLogoList.scrollEnabled = NO;
    carouselLogoFonts.scrollEnabled = NO;
    carouselLogoList.centerItemWhenSelected = NO;
    carouselLogoFonts.centerItemWhenSelected = NO;
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
    
    mailManager = [PMMailManager new];
    mailManager.delegate = self;
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
            if(isSending) {
                SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"ПРЕДУПРЕЖДЕНИЕ" andMessage:@"Отправка вашего логотипа будет отменена. Вы уверены?"];
                [alertView addButtonWithTitle:@"НЕТ"
                                         type:SIAlertViewButtonTypeDefault
                                      handler:^(SIAlertView *alert) {
                                          NSLog(@"Button1 Clicked");
                                      }];
                [alertView addButtonWithTitle:@"ДА"
                                         type:SIAlertViewButtonTypeDestructive
                                      handler:^(SIAlertView *alert) {
                                          if(mailManager != nil)  {
                                              [mailManager cancellAll];
                                              mailManager.delegate = nil;
                                              mailManager = nil;
                                              [self mailSendFailed];
                                              
                                              mailManager = [PMMailManager new];
                                              mailManager.delegate = self;
                                          }
                                      }];
                alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
                [alertView show];
            } else  {
                [self hidePresentLogoImage];
            }
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
        view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(0, 0, 300.0, 300.0);
        [((UIButton*)view) setImage:logoImage forState:UIControlStateNormal];
        view.tag = index;
        [((UIButton*)view) addTarget:self action:@selector(onLogoListClick:) forControlEvents:UIControlEventTouchUpInside];
    } else if(carousel == carouselLogoFonts)    {
        UIImage *logoImage = [logoImageFontsArray objectAtIndex:index];
        view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(0, 0, 300.0, 300.0);
        [((UIButton*)view) setImage:logoImage forState:UIControlStateNormal];
        view.tag = index;
        [((UIButton*)view) addTarget:self action:@selector(onLogoFontsClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return view;
}

-(void) onLogoListClick:(UIButton*)button
{
    [UIView animateWithDuration:0.05 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [self presentSelectedLogoType:button.tag+1];
                         }];
                     }];
}

-(void) onLogoFontsClick:(UIButton*)button
{
    [UIView animateWithDuration:0.05 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [self presentSelectedLogoFontImage:[logoImageFontsArray objectAtIndex:button.tag]];
                         }];
                     }];
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
        case iCarouselOptionVisibleItems:
        {
            return 3;
        }
        case iCarouselOptionCount:
        {
            return 3;
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
    logoImageFont1 = [UIImage logoWithName:nameAll phone:phone mode:mode fontType:1 type:typeIndex];
    logoImageFont2 = [UIImage logoWithName:nameAll phone:phone mode:mode fontType:2 type:typeIndex];
    logoImageFont3 = [UIImage logoWithName:nameAll phone:phone mode:mode fontType:3 type:typeIndex];
    
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
    //UIImageWriteToSavedPhotosAlbum(logoImage, nil, nil, nil);
    
    isPresentLogoImage = YES;
    
    titleLabel.text = @"ВАШ ВАРИАНТ";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  100,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    
    selectedLogoImage = [[UIImageView alloc] initWithImage:logoImage];
    selectedLogoImage.frame = CGRectMake((self.view.bounds.size.width-400)/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+40, 400, 400);
    selectedLogoImage.contentMode = UIViewContentModeScaleAspectFill;
    selectedLogoImage.alpha = 0;
    [self.view addSubview:selectedLogoImage];
    
    saveButton.frame = CGRectMake((self.view.bounds.size.width-saveButton.frame.size.width)/2,
                                  selectedLogoImage.frame.origin.y+selectedLogoImage.frame.size.height+50,
                                  saveButton.frame.size.width, saveButton.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        carouselLogoFonts.alpha = 0;
        //titleLabel.alpha = 0;
        
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
    
    titleLabel.text = @"ВЫБЕРИТЕ ШРИФТ ДЛЯ ЛОГОТИПА";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
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
        isSending = YES;
        
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
        
        UIGraphicsBeginImageContextWithOptions(logoImage.size, NO, 2.0);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, logoImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGRectMake(0, 0, logoImage.size.width, logoImage.size.height), logoImage.CGImage);
        CGContextTranslateCTM(context, 0, logoImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        UIImage *resultingImage2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [mailManager sendMessageWithTitle:@"Логотип"
                                 subtitle:@"ЭТО ТВОЙ УНИКАЛЬНЫЙ ЛОГОТИП!" // - ЦИФРОВОЙ ПРЕМИУС. ОБОИ ДЛЯ РАБОЧЕГО СТОЛА ВАШЕГО МОБИЛЬНОГО ТЕЛЕФОНА.
                                subtitle2:@"ОРИГИНАЛЬНОЕ ИЗОБРАЖЕНИЕ ЛОГОТИПА ВЫСОКОГО КАЧЕСТВА ТЫ СМОЖЕШЬ НАЙТИ В ПРИЛОЖЕНИИ К ПИСЬМУ!"
                                     text:@""
                                    image:resultingImage2
                                 rezImage:resultingImage
                                 filename:@"logo.png"
                                  forName:[MRDataManager sharedInstance].nameRegValue];
    });
}

-(void) mailSendSuccessfully    {
    isSending = NO;
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    LogoSavedView *finishView = [[LogoSavedView alloc] initWithFrame:self.view.frame];
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

-(void) mailSendFailed  {
    isSending = NO;
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
