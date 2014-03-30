//
//  MRRegistrationViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRRegistrationViewController.h"
#import "MRRegistrationItemView.h"
#import "MRChooserViewController.h"

#import <MZFormSheetController/MZFormSheetController.h>

@interface MRRegistrationViewController () <MRRegistrationItemViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;
@end

@implementation MRRegistrationViewController
{
    ActivationIDs _activeID;
    
    NSArray *fieldsArray;
    MRRegistrationItemView *nameField;
    MRRegistrationItemView *secondNameField;
    MRRegistrationItemView *sexField;
    MRRegistrationItemView *phoneField;
    MRRegistrationItemView *emailField;
    MRRegistrationItemView *dateBirthField;
    
    MRRegistrationItemView *selectedField;
}

- (id)initWithActiveID:(ActivationIDs)activeID
{
    self = [super initWithNibName:@"MRRegistrationViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _activeID = activeID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MRDataManager sharedInstance] setDefaultValue];
    
    selectedField = nil;
    
    [self configureItems];
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
    [self showRegFields];
    
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
    // Dispose of any resources that can be recreated.
}

-(void) configureItems
{
    nameField = [[MRRegistrationItemView alloc] initWithPlaceholder:@"ИМЯ"];
    secondNameField = [[MRRegistrationItemView alloc] initWithPlaceholder:@"ФАМИЛИЯ"];
    sexField = [[MRRegistrationItemView alloc] initWithPlaceholder:@"ПОЛ"];
    phoneField = [[MRRegistrationItemView alloc] initWithPlaceholder:@"ТЕЛЕФОН"];
    emailField = [[MRRegistrationItemView alloc] initWithPlaceholder:@"E-MAIL"];
    dateBirthField = [[MRRegistrationItemView alloc] initWithPlaceholder:@"ДАТА РОЖДЕНИЯ"];
    fieldsArray = @[nameField, secondNameField, sexField, phoneField, emailField, dateBirthField];
    
    for(MRRegistrationItemView *fieldView in fieldsArray)   {
        fieldView.delegate = self;
    }
}

-(void) showRegFields
{
    int loop = 1;
    for(UIView *view in fieldsArray)    {
        NSLog(@"%i", loop);
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = CGRectMake((self.tableView.frame.size.width-view.frame.size.width)/2, 0, view.frame.size.width, view.frame.size.height);
            view.alpha = 1;
        }];
        loop++;
    }
}

- (void)onExit:(NSNotification*)notification
{
    [self.navigationController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect rect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat kbHeight = [self.view convertRect:rect fromView:nil].size.height;
    
    CGRect tableViewRect = self.tableView.frame;
    
    if(selectedField == emailField || selectedField == dateBirthField)  {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(tableViewRect.origin.x, -105.0, tableViewRect.size.width, tableViewRect.size.height);
            nameField.alpha = 0;
            secondNameField.alpha = 0;
            emailField.alpha = 1;
            dateBirthField.alpha = 1;
        }];
    } else  {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(tableViewRect.origin.x, 35.0, tableViewRect.size.width, tableViewRect.size.height);
            emailField.alpha = 0;
            dateBirthField.alpha = 0;
            nameField.alpha = 1;
            secondNameField.alpha = 1;
        }];
    }
    
    self.continueButton.hidden = YES;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGRect tableViewRect = self.tableView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(tableViewRect.origin.x, 72.0, tableViewRect.size.width, tableViewRect.size.height);
        nameField.alpha = 1;
        secondNameField.alpha = 1;
        emailField.alpha = 1;
        dateBirthField.alpha = 1;
    }];
    
    self.continueButton.hidden = NO;
}

#pragma mark - Field Delegate
-(void) didSelectField:(MRRegistrationItemView*)fieldView
{
    selectedField = fieldView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return fieldsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 156.0/2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemCellIdentifier = @"MRRegistrationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    MRRegistrationItemView *field = [fieldsArray objectAtIndex:indexPath.section];
    
    field.frame = CGRectMake((self.tableView.frame.size.width-field.frame.size.width)/2, 0, field.frame.size.width, field.frame.size.height);
    if(indexPath.section % 2 == 0)   {
        field.frame = CGRectOffset(field.frame, -20, 0);
    } else  {
        field.frame = CGRectOffset(field.frame, 20, 0);
    }
    field.alpha = 0;
    
    [cell addSubview:field];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0F];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0F];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (IBAction)onContinue:(id)sender
{
    [self hideAllContext];
    
    MRChooserViewController *chooserViewController;
    
    if(_activeID == eBarcode)   {
        NSDictionary *nameDictionary = @{@"titleKey": @"ПО ИМЕНИ", @"placeholderKey": @"ВВЕДИТЕ ИМЯ"};
        NSDictionary *phoneDictionary = @{@"titleKey": @"ПО ТЕЛЕФОНУ", @"placeholderKey": @"ВВЕДИТЕ ТЕЛЕФОН"};
        NSDictionary *barcodeDictionary = @{FIO_KEY: nameDictionary, PHONE_KEY: phoneDictionary};
        
        chooserViewController = [[MRChooserViewController alloc] initWithTitle:@"ВЫБЕРИТЕ ДАННЫЕ ДЛЯ ГЕНЕРАЦИИ БАРКОДА" withCheckboxList:barcodeDictionary :_activeID];
        
    } else if(_activeID == eLogo) {
        NSDictionary *nameDictionary = @{@"titleKey": @"ИМЯ", @"placeholderKey": @"ВВЕДИТЕ ИМЯ"};
        NSDictionary *phoneDictionary = @{@"titleKey": @"ТЕЛЕФОН", @"placeholderKey": @"ВВЕДИТЕ ТЕЛЕФОН"};
        NSDictionary *sloganDictionary = @{@"titleKey": @"СЛОГАН: EU", @"placeholderKey": @""};
        NSDictionary *logoDictionary = @{FIO_KEY: nameDictionary, PHONE_KEY: phoneDictionary, SLOGAN_KEY:sloganDictionary};
        
        chooserViewController = [[MRChooserViewController alloc] initWithTitle:@"ВЫБЕРИТЕ ТИП ПОДПИСИ ПОД ЛОГОТИПОМ" withCheckboxList:logoDictionary :_activeID];
    }
    
    [self.navigationController pushViewController:chooserViewController animated:YES];
}

@end
