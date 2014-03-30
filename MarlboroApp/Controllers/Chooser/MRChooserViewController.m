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
        [self.navigationController.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            //
        }];
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
    NSLog(@"%i and %f", isShowContinueBtn, self.view.frame.origin.y);
    
    if(isShowContinueBtn && self.view.frame.origin.y >= 0)  {
        continueButton.alpha = 1;
    } else  {
        continueButton.alpha = 0;
    }
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    if(self.view.frame.origin.y < 0) return;
    
    if(_checkListArray.count >= 3)  {
        [UIView animateWithDuration:0.3 animations:^{
            titleLabel.alpha = 0;
            
            CGRect rect = self.view.frame;
            rect.origin.y -= 200;
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
            rect.origin.y += 200;
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
    
    
    NSInteger marginTop = titleLabel.frame.origin.y + titleLabel.frame.size.height + 70;
    
    __block int centerX = 0;
    __block int loop = 0;
    for(MRCheckItem *checkItem in checkViewArray)   {
        if(loop == 0)   {
            centerX = (self.view.bounds.size.width - checkItem.frame.size.width)/2;
        }
        
        checkItem.frame = CGRectOffset(checkItem.frame, centerX, (loop * (checkItem.frame.size.height+27)) + marginTop);
        [self.view addSubview:checkItem];
        
        loop++;
    }
    
    MRCheckItem *checkItem = [checkViewArray lastObject];
    continueButton.frame = CGRectMake((self.view.bounds.size.width - continueButton.frame.size.width)/2,
                                      checkItem.frame.origin.y+checkItem.frame.size.height+70,
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
}

-(void) saveData
{
    for( MRCheckItem *checkItem in checkViewArray )
    {
        if([checkItem._key isEqualToString:FIO_KEY])    {
            [[MRDataManager sharedInstance] setNameValue:checkItem.fieldView.titleField.text];
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
    BOOL ret1 = YES;
    BOOL ret2 = YES;
    
    if([[MRDataManager sharedInstance] nameValue].length == 0)
        ret1 = NO;
    
    if([[MRDataManager sharedInstance] phoneValue].length == 0)
        ret2 = NO;
    
    return (!ret1 && !ret2) ? NO : YES;
}

@end
