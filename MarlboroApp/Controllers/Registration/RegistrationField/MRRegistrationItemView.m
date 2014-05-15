//
//  MRRegistrationItemView.m
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRRegistrationItemView.h"

@interface MRRegistrationItemView() <UITextFieldDelegate>

@end

@implementation MRRegistrationItemView
{
    NSString *_placeholderText;
}
@synthesize titleField;

- (id)initWithPlaceholder:(NSString*)text
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _placeholderText = text;
        
        [self initField];
    }
    return self;
}

- (id)initWithPlaceholder:(NSString*)text withKeyboardLangType:(LanguageType)langType
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _placeholderText = text;
        
        [self initField];
        
        PMCustomKeyboard *customKeyboard = [[PMCustomKeyboard alloc] initWithLanguageType:langType];
        [customKeyboard setTextView:titleField];
    }
    return self;
}

-(void) initField
{
    UIImage *backgroundImage = [UIImage imageNamed:@"field_background.png"];
    self.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    [self addSubview:[[UIImageView alloc] initWithImage:backgroundImage]];
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 3.0, self.frame.size.width, self.frame.size.height)];
    titleField.placeholder = _placeholderText;
    UIColor *color = [UIColor colorWithRed:4.0/255.0 green:101.0/255.0 blue:153.0/255.0 alpha:1.0];
    titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_placeholderText attributes:@{NSForegroundColorAttributeName: color}];
    titleField.font = [UIFont fontWithName:@"MyriadPro-Cond" size:33.0];
    titleField.textColor = DEFAULT_COLOR_SCHEME;
    titleField.backgroundColor = [UIColor clearColor];
    titleField.textAlignment = NSTextAlignmentCenter;
    titleField.delegate = self;
    [self addSubview:titleField];
    
    if(!IS_OS_7_OR_LATER)   {
        titleField.frame = CGRectMake(0, (self.frame.size.height-35)/2, self.frame.size.width, 35);
    }
    
    PMCustomKeyboard *customKeyboard = [[PMCustomKeyboard alloc] init];
    [customKeyboard setTextView:titleField];
}

-(void) textUpdated:(NSNotification *)notification {
    UITextField * textfield = (UITextField*)notification.object;
    NSString * text = textfield.text;
    
    NSArray *array = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    textfield.text = array[0];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textUpdated:)
                                                 name: UITextFieldTextDidChangeNotification
                                               object:textField];
    
    if([self.delegate respondsToSelector:@selector(didSelectField:)])
    {
        [self.delegate didSelectField:self];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
    
    if([self.delegate respondsToSelector:@selector(didEndSelectField:)])
    {
        [self.delegate didEndSelectField:self];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL _isAllowed = YES;
    
    NSString *tempString = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //NSLog(@"%@", tempString);
    if ([textField.text isEqualToString:tempString] || [tempString length] > 5)
    {
        _isAllowed =  NO;
    }
    
    return   _isAllowed;
}

-(void) selectField
{
    [titleField becomeFirstResponder];
}

-(void) deselectField
{
    [titleField resignFirstResponder];
}

@end
