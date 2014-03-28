//
//  MRRegistrationViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRRegistrationViewController.h"
#import "MRRegistrationItemView.h"

#import <MZFormSheetController/MZFormSheetController.h>

@interface MRRegistrationViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation MRRegistrationViewController
{
    NSArray *fieldsArray;
    MRRegistrationItemView *nameField;
    MRRegistrationItemView *secondNameField;
    MRRegistrationItemView *sexField;
    MRRegistrationItemView *phoneField;
    MRRegistrationItemView *emailField;
    MRRegistrationItemView *dateBirthField;
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
    
    [self configureItems];
    
    [self showExitButton];
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onExit:) name:MROnExitClickNotification object:nil];
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
}

- (void)onExit:(NSNotification*)notification
{
    [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect rect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat kbHeight = [self.view convertRect:rect fromView:nil].size.height;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    
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

@end
