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
#import "MRSenderChooser.h"

#import <MZFormSheetController/MZFormSheetController.h>
#import <TYMActivityIndicatorView/TYMActivityIndicatorView.h>
#import <SIAlertView/SIAlertView.h>

@interface MRBarcodeListViewController () <BarcodeSavedViewDelegate, PMMailManagerDelegate>
@property (nonatomic, strong) NSArray *barcodeImages;
@property (nonatomic, strong) NSArray *barcodeFontsImages;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@end

@implementation MRBarcodeListViewController
{
    NSString *dataBufferString;
    NSString *name;
    NSString *surName;
    NSString *phone;
    NSString *mode;
    NSString *nameWithSurname;
    
    UILabel *titleLabel;
    
    UIImage *barcode1;
    UIImage *barcode2;
    UIImage *barcode3;
    UIImage *barcode4;
    UIImage *barcode5;
    UIImage *barcode6;
    
    UIImage *barcodeFont1;
    UIImage *barcodeFont2;
    UIImage *barcodeFont3;
    UIImage *barcodeFont4;
    UIImage *barcodeFont5;
    UIImage *barcodeFont6;
    
    UIImageView *selectedBarcodeImage;
    BOOL isPresentFontsCarousel;
    BOOL isPresentImage;
    
    TYMActivityIndicatorView *activityIndicator;
    
    UIImage *selectedImageForMail;
    NSInteger selectedIndexForMail;
    
    BarcodeSavedView *finishView;
    PMMailManager *mailManager;
    BOOL isSending;
    
    MRSenderChooser *senderChooserView;
    NSInteger selectBarcodeIndex, selectBarcodeFontIndex;
}
@synthesize carousel, carouselFonts;
@synthesize barcodeImages, barcodeFontsImages;
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
    
    selectBarcodeIndex = 1;
    selectBarcodeFontIndex = 0;
    
    isPresentFontsCarousel = NO;
    isPresentImage = NO;
    saveButton.alpha = 0;
    isSending = NO;
    
    NSString *phoneScript = ([MRDataManager sharedInstance].phoneValue.length > 0) ? [MRDataManager sharedInstance].phoneValue : @"";
    NSString *nameScript = ([MRDataManager sharedInstance].nameValue.length > 0) ? [MRDataManager sharedInstance].nameValue : @"";
    NSString *surnameScript = ([MRDataManager sharedInstance].surnameValue.length > 0) ? [MRDataManager sharedInstance].surnameValue : @"";
    
    name = ([MRDataManager sharedInstance].firstNameSignString) ? [MRDataManager sharedInstance].firstNameSignString : nil;
    surName = ([MRDataManager sharedInstance].secondNameSignString) ? [MRDataManager sharedInstance].secondNameSignString : nil;
    phone = ([MRDataManager sharedInstance].phoneSignString) ? [MRDataManager sharedInstance].phoneSignString : nil;
    mode = ([MRDataManager sharedInstance].sloganSignString) ? @"EU" : nil;

    //dataBufferString = [nameScript stringByAppendingString:phoneScript];
    dataBufferString = [NSString stringWithFormat:@"%@%@%@", nameScript, surnameScript, phoneScript];
    
    nameWithSurname = [name stringByAppendingFormat:@" %@", surName];

    NSLog(@"Data for barcode (%@)", dataBufferString);
    NSLog(@"name=\'%@\' surname=\'%@\' phone=\'%@\' mode=\'%@\'", name, surName, phone, mode);
    
    barcode1 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:2 type:1];
    barcode2 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:2 type:2];
    barcode3 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:2 type:3];
    barcode4 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:2 type:4];
    barcode5 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:2 type:5];
    barcode6 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:2 type:6];
    
    barcodeImages = @[barcode1, barcode2, barcode3, barcode4, barcode5, barcode6];
    
    //carousel.scrollEnabled = NO;
    carousel.centerItemWhenSelected = NO;
    carousel.type = iCarouselTypeLinear;
    [carousel reloadData];
    
    carouselFonts.alpha = 0;
    carouselFonts.centerItemWhenSelected = NO;
    carouselFonts.type = iCarouselTypeLinear;
    
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
}

- (void)onExit:(NSNotification*)notification
{
    /*if(!isPresentImage) {
        [self hideAllContext];
        [self.navigationController popViewControllerAnimated:YES];
    } else  {
        [self backToChooseBarcode];
    }*/
    
    if(isPresentImage)  {
        if(isSending) {
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"ПРЕДУПРЕЖДЕНИЕ" andMessage:@"Отправка вашего штрих-кода будет отменена. Вы уверены?"];
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
            [self backToChooseBarcode];
        }
    } else if(isPresentFontsCarousel)   {
        [self showBarcodesTypeCarousel];
    } else  {
        [self hideAllContext];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if(carousel == self.carousel)
        return [barcodeImages count];
    else if(carousel == self.carouselFonts)
        return [barcodeFontsImages count];
    
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if(carousel == self.carousel)   {
        UIImage *barcodeImage = [barcodeImages objectAtIndex:index];
        view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(0, 0, 400.0, 400.0);
        [((UIButton*)view) setImage:barcodeImage forState:UIControlStateNormal];
        view.tag = index;
        [((UIButton*)view) addTarget:self action:@selector(onBarcodeClick:) forControlEvents:UIControlEventTouchUpInside];
    } else if(carousel == carouselFonts)    {
        UIImage *barcodeImage = [barcodeFontsImages objectAtIndex:index];
        view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(0, 0, 400.0, 400.0);
        [((UIButton*)view) setImage:barcodeImage forState:UIControlStateNormal];
        view.tag = index;
        [((UIButton*)view) addTarget:self action:@selector(onBarcodeFontClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return view;
}

-(void) onBarcodeClick:(UIButton*)button
{
    [UIView animateWithDuration:0.05 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             selectBarcodeIndex = button.tag+1;
                             
                             [self selectBarcodeType:button.tag+1];
                         }];
                     }];
}

-(void) onBarcodeFontClick:(UIButton*)button
{
    [UIView animateWithDuration:0.05 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             selectBarcodeFontIndex = button.tag;
                             selectedIndexForMail = button.tag;
                             [self presentSelectedImage:[barcodeFontsImages objectAtIndex:button.tag]];
                         }];
                     }];
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

-(void) selectBarcodeType:(NSInteger)index
{
    barcodeFont1 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:1 type:index];
    NSLog(@"1)%@", barcodeFont1);
    barcodeFont2 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:2 type:index];
    NSLog(@"2)%@", barcodeFont2);
    barcodeFont3 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:3 type:index];
    NSLog(@"3)%@", barcodeFont3);
    barcodeFont4 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:4 type:index];
    NSLog(@"4)%@", barcodeFont4);
    barcodeFont5 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:5 type:index];
    NSLog(@"5)%@", barcodeFont5);
    barcodeFont6 = [UIImage barcodeWithText:dataBufferString name:nameWithSurname phone:phone mode:mode fontType:6 type:index];
    NSLog(@"6)%@", barcodeFont6);
    
    barcodeFontsImages = @[barcodeFont1, barcodeFont2, barcodeFont3, barcodeFont4, barcodeFont5, barcodeFont6];
    
    [carouselFonts reloadData];
    [carouselFonts scrollToItemAtIndex:1 animated:NO];
    
    [self showFontsCarousel];
}

-(void) showFontsCarousel
{
    [UIView animateWithDuration:0.2 animations:^{
        carousel.alpha = 0;
        carouselFonts.alpha = 1;
    }];
    
    titleLabel.text = @"ВЫБЕРИТЕ ШРИФТ ДЛЯ БАРКОДА";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    isPresentFontsCarousel = YES;
}

-(void) showBarcodesTypeCarousel
{
    [UIView animateWithDuration:0.2 animations:^{
        carousel.alpha = 1;
        carouselFonts.alpha = 0;
    }];
    
    titleLabel.text = @"ВЫБЕРИТЕ ВАРИАНТ БАРКОДА";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    isPresentFontsCarousel = NO;
}

-(void) presentSelectedImage:(UIImage*)image
{
    selectedImageForMail = image;
    
    senderChooserView = [[MRSenderChooser alloc] initWithFrame:self.view.frame];
    senderChooserView.delegate = self;
    senderChooserView.alpha = 0;
    [senderChooserView initialize];
    
    [UIView animateWithDuration:0.2 animations:^{
        carousel.alpha = 0;
        carouselFonts.alpha = 0;
        titleLabel.alpha = 0;
        
        senderChooserView.alpha = 1;
    }];
    
    [self.view addSubview:senderChooserView];
}

-(void) onContinueAfterSenderChecker    {
    [senderChooserView removeFromSuperview];
    
     isPresentFontsCarousel = NO;
     isPresentImage = YES;
     
     titleLabel.text = @"ВАШ ВЫБОР";
     [titleLabel sizeToFit];
     titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
     185,
     titleLabel.frame.size.width,
     titleLabel.frame.size.height);
     
     selectedBarcodeImage = [[UIImageView alloc] initWithImage:selectedImageForMail];
     selectedBarcodeImage.alpha = 0;
     selectedBarcodeImage.frame = CGRectMake((self.view.bounds.size.width-selectedImageForMail.size.width)/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+50, selectedImageForMail.size.width, selectedImageForMail.size.height);
     selectedBarcodeImage.center = self.view.center;
     
     [self.view addSubview:selectedBarcodeImage];
     
     saveButton.frame = CGRectMake((self.view.bounds.size.width-saveButton.frame.size.width)/2,
     selectedBarcodeImage.frame.origin.y+selectedBarcodeImage.frame.size.height+50,
     saveButton.frame.size.width, saveButton.frame.size.height);
     
     [UIView animateWithDuration:0.2 animations:^{
         carousel.alpha = 0;
         carouselFonts.alpha = 0;
         //titleLabel.alpha = 0;
         
         titleLabel.alpha = 1;
         selectedBarcodeImage.alpha = 1;
         saveButton.alpha = 1;
     }];
}

-(void) onExitAfterSenderChecker    {
    [senderChooserView removeFromSuperview];
    
    [UIView animateWithDuration:0.2 animations:^{
        carousel.alpha = 0;
        carouselFonts.alpha = 1;
    }];
}

-(void) backToChooseBarcode
{
    isPresentImage = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        selectedBarcodeImage.alpha = 0;
        saveButton.alpha = 0;
    } completion:^(BOOL finished) {
        [selectedBarcodeImage removeFromSuperview];
    }];
    
    [self showFontsCarousel];
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

-(void) exitFromFinishView
{
    [self.navigationController.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
    }];
    
    [finishView removeFromSuperview];
    finishView = nil;
}

-(void) generateImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isSending = YES;
        
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
        
        UIGraphicsBeginImageContextWithOptions(barcodeImage.size, NO, 2.0);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, barcodeImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGRectMake(0, 0, barcodeImage.size.width, barcodeImage.size.height), barcodeImage.CGImage);
        CGContextTranslateCTM(context, 0, barcodeImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        UIImage *resultingImage2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //UIImageWriteToSavedPhotosAlbum(resultingImage2, nil, nil, nil);
        /*[mailManager sendMessageWithTitle:@"Barcode"
                                 subtitle:@"ЭТО ТВОЙ УНИКАЛЬНЫЙ ШТРИХ КОД!" // - ЦИФРОВОЙ ПРЕМИУС. ОБОИ ДЛЯ РАБОЧЕГО СТОЛА ВАШЕГО МОБИЛЬНОГО ТЕЛЕФОНА.
                                subtitle2:@"ОРИГИНАЛЬНОЕ ИЗОБРАЖЕНИЕ ШТРИХ КОДА ВЫСОКОГО КАЧЕСТВА ТЫ СМОЖЕШЬ НАЙТИ В ПРИЛОЖЕНИИ К ПИСЬМУ!"
                                     text:@" "
                                    image:resultingImage2
                                 rezImage:resultingImage
                                 filename:@"barcode.png"
                                  forName:[MRDataManager sharedInstance].nameRegValue];*/
        [mailManager sendDataToServer:eBarcode
                            withImage:resultingImage2
                         teplateIndex:selectBarcodeIndex
                            fontIndex:selectBarcodeFontIndex
                               withEu:[MRDataManager sharedInstance].sloganSignString
                                 text:@" "
                             subtitle:@"ЭТО ТВОЙ УНИКАЛЬНЫЙ ШТРИХ КОД!"
                            subtitle2:@"ОРИГИНАЛЬНОЕ ИЗОБРАЖЕНИЕ ШТРИХ КОДА ВЫСОКОГО КАЧЕСТВА ТЫ СМОЖЕШЬ НАЙТИ В ПРИЛОЖЕНИИ К ПИСЬМУ!"];
    });
}

-(void) mailSendSuccessfully    {
    isSending = NO;
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    finishView = [[BarcodeSavedView alloc] initWithFrame:self.view.frame];
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

@end
