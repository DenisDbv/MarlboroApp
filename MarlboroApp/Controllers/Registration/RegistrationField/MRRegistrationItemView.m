//
//  MRRegistrationItemView.m
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRRegistrationItemView.h"

@interface MRRegistrationItemView()
@property (nonatomic, strong) UITextField *titleField;
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
}

@end
