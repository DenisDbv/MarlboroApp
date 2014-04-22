//
//  MRResultStampViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 17.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRResultStampViewController.h"
#import "UIImage+BarcodeImage.h"
#import "PMMailManager.h"
#import "NSString+EngToRu.h"

#import <MZFormSheetController/MZFormSheetController.h>
#import <TYMActivityIndicatorView/TYMActivityIndicatorView.h>

@interface MRResultStampViewController () <PMMailManagerDelegate>
@property (nonatomic, strong) NSArray *stampArray;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@end

@implementation MRResultStampViewController
{
    PMMailManager *mailManager;
    TYMActivityIndicatorView *activityIndicator;
    
    UIImage *stampsImage;
}
@synthesize stampArray;
@synthesize saveButton;

-(id) initWithStampImages:(NSArray*)stampImagesArray    {
    self = [super initWithNibName:@"MRResultStampViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        stampArray = stampImagesArray;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *stampsView = [self create4Stamps];
    stampsImage = [self snapshotView:stampsView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:stampsImage];
    imageView.frame = CGRectMake((self.view.frame.size.width-stampsImage.size.width)/2,
                                 (self.view.frame.size.height-stampsImage.size.height)/2-40,
                                 stampsImage.size.width, stampsImage.size.height);
    [self.view addSubview:imageView];
    
    mailManager = [PMMailManager new];
    mailManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIView*) create4Stamps   {
    UIImage* mask4Stamps = [UIImage imageNamed:@"4stamps.png"];
    CGSize size4Stamps = mask4Stamps.size;
    
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size4Stamps.width, size4Stamps.height)];
    rootView.backgroundColor = [UIColor clearColor];
    
    UIImage* texture = [UIImage imageNamed:@"texture.png"];
    UIImage* scaledTexture = [UIImage imageWithImage:texture scaledToSize:size4Stamps];
    UIImage* image4Stamps = [UIImage maskImage:scaledTexture withMask:mask4Stamps];
    
    UIImageView *imageView4Stamps = [[UIImageView alloc] initWithImage:image4Stamps];
    imageView4Stamps.frame = CGRectMake(0, 0, size4Stamps.width, size4Stamps.height);
    [rootView addSubview:imageView4Stamps];
    
    UIImageView *photoView1 = [[UIImageView alloc] initWithImage:stampArray[0]];
    photoView1.frame = CGRectMake(51/2, 47/2, 365/2, 365/2);
    [rootView addSubview:photoView1];
    [rootView insertSubview:photoView1 belowSubview:rootView];
    
    UIImageView *photoView2 = [[UIImageView alloc] initWithImage:stampArray[1]];
    photoView2.frame = CGRectMake(499/2, 47/2, 365/2, 365/2);
    [rootView addSubview:photoView2];
    [rootView insertSubview:photoView2 belowSubview:rootView];
    
    UIImageView *photoView3 = [[UIImageView alloc] initWithImage:stampArray[2]];
    photoView3.frame = CGRectMake(51/2, 489/2, 365/2, 365/2);
    [rootView addSubview:photoView3];
    [rootView insertSubview:photoView3 belowSubview:rootView];
    
    UIImageView *photoView4 = [[UIImageView alloc] initWithImage:stampArray[3]];
    photoView4.frame = CGRectMake(499/2, 489/2, 365/2, 365/2);
    [rootView addSubview:photoView4];
    [rootView insertSubview:photoView4 belowSubview:rootView];
    
    UIImage *maskInnerFrame = [UIImage imageNamed:@"stamp_inner_frame.png"];
    UIImage* imageInnerFrame = [UIImage maskImage:scaledTexture withMask:maskInnerFrame];
    
    UIImageView *imageViewInnerFrame1 = [[UIImageView alloc] initWithImage:imageInnerFrame];
    imageViewInnerFrame1.frame = CGRectMake(51/2, 47/2, maskInnerFrame.size.width+1, maskInnerFrame.size.height+1);
    [rootView addSubview:imageViewInnerFrame1];
    
    UIImageView *imageViewInnerFrame2 = [[UIImageView alloc] initWithImage:imageInnerFrame];
    imageViewInnerFrame2.frame = CGRectMake(498/2, 47/2, maskInnerFrame.size.width+2, maskInnerFrame.size.height+1);
    [rootView addSubview:imageViewInnerFrame2];
    
    UIImageView *imageViewInnerFrame3 = [[UIImageView alloc] initWithImage:imageInnerFrame];
    imageViewInnerFrame3.frame = CGRectMake(51/2, 488/2, maskInnerFrame.size.width+1, maskInnerFrame.size.height+2);
    [rootView addSubview:imageViewInnerFrame3];
    
    UIImageView *imageViewInnerFrame4 = [[UIImageView alloc] initWithImage:imageInnerFrame];
    imageViewInnerFrame4.frame = CGRectMake(498/2, 488/2, maskInnerFrame.size.width+2, maskInnerFrame.size.height+2);
    [rootView addSubview:imageViewInnerFrame4];
    
    NSString *name = ([MRDataManager sharedInstance].nameValue.length != 0) ? [MRDataManager sharedInstance].nameValue : @"";
    NSString *surName = ([MRDataManager sharedInstance].surnameValue.length != 0) ? [MRDataManager sharedInstance].surnameValue : @"";
    NSString *phone = ([MRDataManager sharedInstance].phoneValue.length != 0) ? [MRDataManager sharedInstance].phoneValue : @"";
    NSString *nameSurname = [NSString stringWithFormat:@"%@ %@", name, surName];
    //nameSurname = @"АЛЕКСАНДРА КОНСТАНТИНОПОЛЬСКАЯ";
    //phone = @"8 906 381 6363";
    NSLog(@"%@", nameSurname);
    
    UILabel *fioLabel1 = [self createLabel];
    fioLabel1.text = nameSurname;
    [fioLabel1 sizeToFit];
    fioLabel1.frame = CGRectMake(0, -(fioLabel1.frame.size.height),
                                maskInnerFrame.size.width+1, fioLabel1.frame.size.height);
    [imageViewInnerFrame1 addSubview:fioLabel1];
    
    UILabel *fioLabel2 = [self createLabel];
    fioLabel2.text = nameSurname;
    [fioLabel2 sizeToFit];
    fioLabel2.frame = CGRectMake(0, -(fioLabel2.frame.size.height),
                                 maskInnerFrame.size.width+1, fioLabel2.frame.size.height);
    [imageViewInnerFrame2 addSubview:fioLabel2];
    
    UILabel *fioLabel3 = [self createLabel];
    fioLabel3.text = nameSurname;
    [fioLabel3 sizeToFit];
    fioLabel3.frame = CGRectMake(0, -(fioLabel3.frame.size.height),
                                 maskInnerFrame.size.width+1, fioLabel3.frame.size.height);
    [imageViewInnerFrame3 addSubview:fioLabel3];
    
    UILabel *fioLabel4 = [self createLabel];
    fioLabel4.text = nameSurname;
    [fioLabel4 sizeToFit];
    fioLabel4.frame = CGRectMake(0, -(fioLabel4.frame.size.height),
                                 maskInnerFrame.size.width+1, fioLabel4.frame.size.height);
    [imageViewInnerFrame4 addSubview:fioLabel4];
    
    UILabel *phoneLabel1 = [self createLabel];
    phoneLabel1.text = phone;
    [phoneLabel1 sizeToFit];
    phoneLabel1.frame = CGRectMake(0, maskInnerFrame.size.height+2,
                                 maskInnerFrame.size.width+1, phoneLabel1.frame.size.height);
    [imageViewInnerFrame1 addSubview:phoneLabel1];
    
    UILabel *phoneLabel2 = [self createLabel];
    phoneLabel2.text = phone;
    [phoneLabel2 sizeToFit];
    phoneLabel2.frame = CGRectMake(0, maskInnerFrame.size.height+2,
                                   maskInnerFrame.size.width+1, phoneLabel2.frame.size.height);
    [imageViewInnerFrame2 addSubview:phoneLabel2];
    
    UILabel *phoneLabel3 = [self createLabel];
    phoneLabel3.text = phone;
    [phoneLabel3 sizeToFit];
    phoneLabel3.frame = CGRectMake(0, maskInnerFrame.size.height+2,
                                   maskInnerFrame.size.width+1, phoneLabel3.frame.size.height);
    [imageViewInnerFrame3 addSubview:phoneLabel3];
    
    UILabel *phoneLabel4 = [self createLabel];
    phoneLabel4.text = phone;
    [phoneLabel4 sizeToFit];
    phoneLabel4.frame = CGRectMake(0, maskInnerFrame.size.height+2,
                                   maskInnerFrame.size.width+1, phoneLabel4.frame.size.height);
    [imageViewInnerFrame4 addSubview:phoneLabel4];
    
    UIImage *imageCorner = [UIImage imageNamed:@"stamp_corner.png"];
    scaledTexture = [UIImage imageWithImage:texture scaledToSize:imageCorner.size];
    UIImage *imageCorner2 = [UIImage maskImage:scaledTexture withMask:imageCorner];
    UIImageView *imageViewCorner = [[UIImageView alloc] initWithImage:imageCorner2];
    imageViewCorner.frame = CGRectMake(4, imageViewInnerFrame1.frame.size.height-imageCorner.size.height-4,
                                       imageViewInnerFrame1.frame.size.width-8, imageCorner.size.height);
    imageViewCorner.alpha = 0.9;
    [imageViewInnerFrame1 addSubview:imageViewCorner];
    
    imageCorner = [UIImage imageNamed:@"stamp_m.png"];
    scaledTexture = [UIImage imageWithImage:texture scaledToSize:imageCorner.size];
    imageCorner2 = [UIImage maskImage:scaledTexture withMask:imageCorner];
    UIImageView *imageViewM = [[UIImageView alloc] initWithImage:imageCorner2];
    imageViewM.frame = CGRectMake((imageViewInnerFrame4.frame.size.width-imageCorner.size.width)/2,
                                  imageViewInnerFrame4.frame.size.height-imageCorner.size.height-15,
                                       imageCorner.size.width, imageCorner.size.height);
    [imageViewInnerFrame4 addSubview:imageViewM];
    
    imageCorner = [self createBarcode];
    scaledTexture = [UIImage imageWithImage:texture scaledToSize:imageCorner.size];
    imageCorner2 = [UIImage maskImage:scaledTexture withMask:imageCorner];
    UIImageView *imageViewBarcode = [[UIImageView alloc] initWithImage:imageCorner2];
    imageViewBarcode.frame = CGRectMake(14, imageViewInnerFrame2.frame.size.height-32-14,
                                        imageViewInnerFrame2.frame.size.width-28, 32);
    [imageViewInnerFrame2 addSubview:imageViewBarcode];
    
    imageCorner = [self createLogo];
    scaledTexture = [UIImage imageWithImage:texture scaledToSize:imageCorner.size];
    imageCorner2 = [UIImage maskImage:scaledTexture withMask:imageCorner];
    UIImageView *imageViewLogo = [[UIImageView alloc] initWithImage:imageCorner2];
    imageViewLogo.frame = CGRectMake((imageViewInnerFrame3.frame.size.width-imageCorner.size.width/4)/2,
                                     imageViewInnerFrame3.frame.size.height-imageCorner.size.height/4+10,
                                        imageCorner.size.width/4, imageCorner.size.height/4);
    [imageViewInnerFrame3 addSubview:imageViewLogo];
    
    return rootView;
}

-(UIImage*) snapshotView:(UIView*)subView   {
    UIGraphicsBeginImageContextWithOptions(subView.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [subView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

-(UILabel*) createLabel {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"FuturaBookC" size:8.0];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(UIImage*) createBarcode   {
    NSString *name = ([MRDataManager sharedInstance].nameValue.length != 0) ? [MRDataManager sharedInstance].nameValue : @" ";
    NSString *surName = ([MRDataManager sharedInstance].surnameValue.length != 0) ? [MRDataManager sharedInstance].surnameValue : @" ";
    NSString *phone = ([MRDataManager sharedInstance].phoneValue.length != 0) ? [MRDataManager sharedInstance].phoneValue : @" ";
    NSString *nameSurname = [NSString stringWithFormat:@"%@ %@", name, surName];
    
    nameSurname = [nameSurname convertFromRuToEng];
    
    //nameSurname = @"АЛЕКСАНДРА КОНСТАНТИНОПОЛЬСКАЯ";
    //phone = @"8 906 381 6363";
    
    NSString *barcodeText = nameSurname;
    if(name.length == 0 && surName.length == 0)
        barcodeText = phone;
    
    CGSize barSize = CGSizeMake(317, 65);
    UIImage* barcode = [UIImage barcodeImage:barcodeText size:barSize];
    if (barcode == nil) return nil;
    barSize = barcode.size;
    
    // create image
    CGSize imageSize = CGSizeMake(barSize.width, barSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    // draw barcode
    [barcode drawInRect:(CGRect){.size = barSize}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage*) createLogo  {
    
    UIFont* bigFont = [UIFont fontWithName:@"FuturaDemiC" size:90];
    
    NSString *name = ([MRDataManager sharedInstance].nameValue.length != 0) ? [MRDataManager sharedInstance].nameValue : @" ";
    NSString *surName = ([MRDataManager sharedInstance].surnameValue.length != 0) ? [MRDataManager sharedInstance].surnameValue : @" ";
    NSString *patrName = ([MRDataManager sharedInstance].patronymicValue.length != 0) ? [MRDataManager sharedInstance].patronymicValue : @" ";
    
    //name = @"АЛЕКСАНДРА";
    //surName = @"КОНСТАНТИНОПОЛЬСКАЯ";
    //patrName = @"ВЛАДИМИРОВНА";
    NSString* letter1 = [name substringToIndex:1];
    NSString* letter2 = [surName substringToIndex:1];
    NSString* letter3 = [patrName substringToIndex:1];
    UIImage* logoBack = [UIImage imageNamed:@"logo1.png"];
    
    // create image
    CGSize imageSize = logoBack.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    [[UIColor blackColor] set];
    
    // draw logo back
    [logoBack drawInRect:(CGRect){.size = imageSize}];
    
    float ofs = 110;
    float ofsy = 0;
    //if (!IS_OS_7_OR_LATER && fontType == 1) ofsy = 20;
    
    // draw M
    CGSize letterSize = [@"M" sizeWithFont:bigFont];
    CGPoint pos = CGPointMake(imageSize.width/2-letterSize.width/2, imageSize.height/2-letterSize.height/2-ofs+ofsy);
    [@"M" drawAtPoint:pos withFont:bigFont];
    
    // draw letters
    if (name.length != 0){
        CGSize letter1Size = [letter1 sizeWithFont:bigFont];
        CGPoint pos1 = CGPointMake(imageSize.width/2-letter1Size.width/2-ofs, imageSize.height/2-letter1Size.height/2+ofsy);
        [letter1 drawAtPoint:pos1 withFont:bigFont];
        
        CGSize letter2Size = [letter2 sizeWithFont:bigFont];
        CGPoint pos2 = CGPointMake(imageSize.width/2-letter2Size.width/2, imageSize.height/2-letter2Size.height/2+ofs+ofsy);
        [letter2 drawAtPoint:pos2 withFont:bigFont];
        
        CGSize letter3Size = [letter3 sizeWithFont:bigFont];
        CGPoint pos3 = CGPointMake(imageSize.width/2-letter3Size.width/2+ofs, imageSize.height/2-letter3Size.height/2+ofsy);
        [letter3 drawAtPoint:pos3 withFont:bigFont];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(IBAction)onSave:(UIButton*)button
{
    //__weak id wself = self;
    //dispatch_async( dispatch_get_main_queue(), ^{
    [saveButton setImage:[UIImage imageNamed:@"field_background.png"] forState:UIControlStateNormal];
    [saveButton setImage:[UIImage imageNamed:@"field_background.png"] forState:UIControlStateHighlighted];
    [saveButton setImage:[UIImage imageNamed:@"field_background.png"] forState:UIControlStateDisabled];
    
    activityIndicator = [[TYMActivityIndicatorView alloc] initWithActivityIndicatorStyle:TYMActivityIndicatorViewStyleNormal];
    activityIndicator.center = saveButton.center;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    //});
    
    //saveButton.alpha = 0;
    saveButton.enabled = NO;
    
    [mailManager sendMessageWithTitle:@"Марка"
                             subtitle:@"ЭТО ТВОИ УНИКАЛЬНЫЕ МАРКИ!" // - ЦИФРОВОЙ ПРЕМИУС. ОБОИ ДЛЯ РАБОЧЕГО СТОЛА ВАШЕГО МОБИЛЬНОГО ТЕЛЕФОНА.
                            subtitle2:@"ОРИГИНАЛЬНОЕ ИЗОБРАЖЕНИЕ МАРКИ ВЫСОКОГО КАЧЕСТВА ТЫ СМОЖЕШЬ НАЙТИ В ПРИЛОЖЕНИИ К ПИСЬМУ!"
                                 text:@""
                                image:stampsImage
                             rezImage:stampsImage
                             filename:@"stamps.png"
                              forName:[MRDataManager sharedInstance].nameRegValue];
}

-(void) mailSendSuccessfully    {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    if([self.delegate respondsToSelector:@selector(finishSuccessfulStampController)]) {
        [self.delegate finishSuccessfulStampController];
    }
}

-(void) mailSendFailed  {
    [saveButton setImage:[UIImage imageNamed:@"save_btn_large.png"] forState:UIControlStateNormal];
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    saveButton.enabled = YES;
}

@end
