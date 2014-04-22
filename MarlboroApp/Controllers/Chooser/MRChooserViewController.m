//
//  MRChooserViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRChooserViewController.h"
#import "MRCheckItem.h"
#import "MRBarcodeListViewController.h"
#import "MRLogoListViewController.h"
#import "MRStampRootViewController.h"

#import <MZFormSheetController/MZFormSheetController.h>

@interface MRChooserViewController () <MRCheckItemDelegate>
@property (nonatomic, strong) IBOutlet UIButton *continueButton;
@end

@implementation MRChooserViewController
{
    ActivationIDs _activeID;
    
    NSString *_title;
    NSDictionary *_checkListArray;
    NSMutableArray *checkViewArray;
    
    UILabel *titleLabel;
    
    BOOL isShowContinueBtn;
    NSInteger selectedCheckItem;
}
@synthesize continueButton;

//NSDictionary (key => checkbox name)
//save by pattern (key => bool value)
-(id) initWithTitle:(NSString*)title withCheckboxList:(NSDictionary*)checkListDictionary :(ActivationIDs)activeID
{
    self = [super initWithNibName:@"MRChooserViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _title = title;
        _checkListArray = checkListDictionary;
        
        _activeID = activeID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    continueButton.alpha = 0;
    isShowContinueBtn = NO;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.alpha = 1;
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DEFAULT_COLOR_SCHEME;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _title;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    [self.view addSubview:titleLabel];
    
    [self configureChecker];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self showAllContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onExit:) name:MROnExitClickNotification object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self showExitButton];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MROnExitClickNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onExit:(NSNotification*)notification
{
    if(_activeID == eBarcode || _activeID == eLogo) {
        
        if(IS_OS_7_OR_LATER)   {
            [self.navigationController.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
        } else {
            [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                //formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
            }];
        }
    } else  {
        [self hideAllContext];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) didSelectCheckbox:(MRCheckItem*)item withActive:(BOOL)active
{
    BOOL ret = NO;
    for(MRCheckItem *item in checkViewArray)
    {
        if(item.isCheck == YES) {
            ret = YES;
            break;
        }
    }
    
    isShowContinueBtn = ret;
    [self updateContinueButton];
}

-(void) updateContinueButton
{
    if(isShowContinueBtn && self.view.frame.origin.y >= 0)  {
        continueButton.alpha = 1;
    } else  {
        continueButton.alpha = 0;
    }
    
    /*if(isShowContinueBtn && checkViewArray.count > 3)   {
        CGRect rect = continueButton.frame;
        rect.origin.y = (self.view.bounds.size.height - continueButton.frame.size.height - 10);
        continueButton.frame = rect;
    }*/
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    if(self.view.frame.origin.y < 0) return;
    
    if(_checkListArray.count >= 3)  {
        [UIView animateWithDuration:0.3 animations:^{
            titleLabel.alpha = 0;
            
            CGRect rect = self.view.frame;
            rect.origin.y -= 170;
            self.view.frame = rect;
        }];
    } else  {
        [UIView animateWithDuration:0.3 animations:^{
            //titleLabel.alpha = 0;
            
            CGRect rect = self.view.frame;
            rect.origin.y -= 100;
            self.view.frame = rect;
        }];
    }
    
    [self updateContinueButton];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    if(_checkListArray.count >= 3)  {
        [UIView animateWithDuration:0.3 animations:^{
            titleLabel.alpha = 1;
            
            CGRect rect = self.view.frame;
            rect.origin.y += 170;
            self.view.frame = rect;
        }];
    } else  {
        [UIView animateWithDuration:0.3 animations:^{
            //titleLabel.alpha = 0;
            
            CGRect rect = self.view.frame;
            rect.origin.y += 100;
            self.view.frame = rect;
        }];
    }
    
    [self updateContinueButton];
}

-(void) configureChecker
{
    checkViewArray = [[NSMutableArray alloc] init];
    
    [_checkListArray enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary *objectItem = obj;
        
        MRCheckItem *checkItem = [[MRCheckItem alloc] initWithTitle:[objectItem valueForKey:@"titleKey"] byKey:key withPlaceholder:[objectItem valueForKey:@"placeholderKey"]];
        checkItem.rootDelegate = self;
        checkItem.indexItem = [[objectItem valueForKey:@"indexKey"] integerValue];
        
        [checkViewArray addObject:checkItem];
    }];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"indexItem" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [checkViewArray sortedArrayUsingDescriptors:sortDescriptors];
    
    checkViewArray = [[NSMutableArray alloc] initWithArray:sortedArray];
    
    if(checkViewArray.count > 3)    {
        titleLabel.frame = CGRectOffset(titleLabel.frame, 0, -70);
    }
    
    NSInteger marginTop = titleLabel.frame.origin.y + titleLabel.frame.size.height + ((checkViewArray.count>3)?30:70);
    
    __block int centerX = 0;
    __block int loop = 0;
    for(MRCheckItem *checkItem in checkViewArray)   {
        if(loop == 0)   {
            centerX = (self.view.bounds.size.width - checkItem.frame.size.width)/2;
        }
        
        checkItem.frame = CGRectOffset(checkItem.frame, centerX, (loop * (checkItem.frame.size.height+15)) + marginTop);
        [self.view addSubview:checkItem];
        
        loop++;
    }
    
    MRCheckItem *checkItem = [checkViewArray lastObject];
    continueButton.frame = CGRectMake((self.view.bounds.size.width - continueButton.frame.size.width)/2,
                                      checkItem.frame.origin.y+checkItem.frame.size.height+((checkViewArray.count>3)?30:70),
                                      continueButton.frame.size.width, continueButton.frame.size.height);
}

- (IBAction)onContinue:(id)sender
{
    [self saveData];
    if(![self dataAccessTrue]) return;
    
    [self hideAllContext];
    
    if(_activeID == eBarcode)   {
        
        //NSLog(@"%@ %@ %i", [[MRDataManager sharedInstance] nameValue], [[MRDataManager sharedInstance] phoneValue], [[MRDataManager sharedInstance] sloganValue]);
        
        MRChooserViewController *chooserViewController;
        NSDictionary *nameDictionary = @{@"titleKey": @"ИМЯ ФАМИЛИЯ", @"placeholderKey": @"", @"indexKey":[NSNumber numberWithInteger:1]};
        NSDictionary *phoneDictionary = @{@"titleKey": @"ТЕЛЕФОН", @"placeholderKey": @"", @"indexKey":[NSNumber numberWithInteger:2]};
        NSDictionary *modeDictionary = @{@"titleKey": @"СЛОГАН: EU", @"placeholderKey": @"", @"indexKey":[NSNumber numberWithInteger:3]};
        NSDictionary *barcodeDictionary = @{FIO_SIGN_KEY: nameDictionary, PHONE_SIGN_KEY: phoneDictionary, SLOGAN_SIGN_KEY:modeDictionary};
        
        chooserViewController = [[MRChooserViewController alloc] initWithTitle:@"ВЫБЕРИТЕ ТИП ПОДПИСИ ПОД БАРКОДОМ" withCheckboxList:barcodeDictionary :eBarcodeSign];
        [self.navigationController pushViewController:chooserViewController animated:YES];
    } else if (_activeID == eBarcodeSign)   {
        //NSLog(@"%i %i %i", [[MRDataManager sharedInstance] nameSignValue], [[MRDataManager sharedInstance] phoneSignValue], [[MRDataManager sharedInstance] sloganSignValue]);
        MRBarcodeListViewController *barcodeListVC = [[MRBarcodeListViewController alloc] initWithNibName:@"MRBarcodeListViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:barcodeListVC animated:YES];
    }
    else if(_activeID == eLogo) {
        MRLogoListViewController *logoListVC = [[MRLogoListViewController alloc] initWithNibName:@"MRLogoListViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:logoListVC animated:YES];
    }
    else if(_activeID == eStamp) {
        MRStampRootViewController *stampController = [[MRStampRootViewController alloc] init];
        [self.navigationController pushViewController:stampController animated:YES];
    }
}

-(void) saveData
{
    for( MRCheckItem *checkItem in checkViewArray )
    {
        if([checkItem._key isEqualToString:NAME_KEY])    {
            [[MRDataManager sharedInstance] setNameValue:checkItem.fieldView.titleField.text];
        } else if([checkItem._key isEqualToString:SURNAME_KEY]) {
            [[MRDataManager sharedInstance] setSurnameValue:checkItem.fieldView.titleField.text];
        } else if([checkItem._key isEqualToString:PATRONYMIC_KEY]) {
            [[MRDataManager sharedInstance] setPatronymicValue:checkItem.fieldView.titleField.text];
        } else if([checkItem._key isEqualToString:PHONE_KEY]) {
            [[MRDataManager sharedInstance] setPhoneValue:checkItem.fieldView.titleField.text];
        } else if([checkItem._key isEqualToString:SLOGAN_KEY]) {
            [[MRDataManager sharedInstance] setSloganValue:checkItem.isCheck];
        }
        else if([checkItem._key isEqualToString:FIO_SIGN_KEY])   {
            [[MRDataManager sharedInstance] setNameSignValue:checkItem.isCheck];
        } else if([checkItem._key isEqualToString:PHONE_SIGN_KEY]) {
            [[MRDataManager sharedInstance] setPhoneSignValue:checkItem.isCheck];
        } else if([checkItem._key isEqualToString:SLOGAN_SIGN_KEY]) {
            [[MRDataManager sharedInstance] setSloganSignValue:checkItem.isCheck];
        }
    }
    
    [[MRDataManager sharedInstance] save];
}

-(BOOL) dataAccessTrue
{
    if(_activeID == eLogo) {
        
        if([MRDataManager sharedInstance].nameValue.length > 0 ||
           [MRDataManager sharedInstance].surnameValue.length > 0 ||
           [MRDataManager sharedInstance].patronymicValue.length > 0) {
            if( ([MRDataManager sharedInstance].nameValue.length <= 0) )    {
                MRCheckItem *checkItem = [checkViewArray objectAtIndex:0];
                [self shakeIt:checkItem withDelta:-2.0];
                return NO;
            }
            if( ([MRDataManager sharedInstance].surnameValue.length <= 0) )    {
                MRCheckItem *checkItem = [checkViewArray objectAtIndex:1];
                [self shakeIt:checkItem withDelta:-2.0];
                return NO;
            }
            if( ([MRDataManager sharedInstance].patronymicValue.length <= 0) )    {
                MRCheckItem *checkItem = [checkViewArray objectAtIndex:2];
                [self shakeIt:checkItem withDelta:-2.0];
                return NO;
            }
        }
    }
    
    BOOL ret1 = YES;
    BOOL ret2 = YES;
    BOOL ret3 = YES;
    
    if([[MRDataManager sharedInstance] nameValue].length == 0)
        ret1 = NO;
    
    if([[MRDataManager sharedInstance] phoneValue].length == 0)
        ret2 = NO;
    
    if([MRDataManager sharedInstance].sloganValue == NO)
        ret3 = NO;
    
    return (!ret1 && !ret2 && !ret3) ? NO : YES;
}

-(void) shakeIt:(UIView*)view withDelta:(CGFloat)delta
{
    CAKeyframeAnimation *anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ];
    anim.values = [ NSArray arrayWithObjects:
                   [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(delta, 0.0f, 0.0f) ],
                   [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-delta, 0.0f, 0.0f) ],
                   nil ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 8.0f ;
    anim.duration = 0.03f ;
    
    [view.layer addAnimation:anim forKey:nil ];
}

@end
