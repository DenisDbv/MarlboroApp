//
//  MRCheckItem.m
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRCheckItem.h"

#define DELTA_ANIM_OFFSET   10
#define TIMER_ANIM_DELAY 0.2

@implementation MRCheckItem
{
    UIImageView *checkImage;
    
    UIButton *checkButton;
    UILabel *titleLabel;
    
    NSString *_placeholderText;
}
@synthesize isCheck;
@synthesize fieldView;
@synthesize _key;

- (id)initWithTitle:(NSString*)title byKey:(NSString*)key withPlaceholder:(NSString*)placeholderText
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _key = key;
        [self initItemWithTitle:title :placeholderText];
    }
    return self;
}

-(void) initItemWithTitle:(NSString*)title :(NSString*)placeholderText
{
    _placeholderText = placeholderText;
    
    isCheck = NO;
    
    checkImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
    checkImage.hidden = YES;
    
    UIImage *checkFrameImage = [UIImage imageNamed:@"check_frame@2x.png"];
    checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(0, 0, checkFrameImage.size.width/2, checkFrameImage.size.height/2);
    checkButton.backgroundColor = [UIColor clearColor];
    [checkButton setImage:checkFrameImage forState:UIControlStateNormal];
    [checkButton setImage:checkFrameImage forState:UIControlStateHighlighted];
    [checkButton addTarget:self action:@selector(onCheck:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkButton];
    
    checkImage.center = checkButton.center;
    [checkButton addSubview:checkImage];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.alpha = 1;
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DEFAULT_COLOR_SCHEME;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(checkButton.bounds.size.width + 71,
                                  (checkButton.bounds.size.height - titleLabel.frame.size.height)/2,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    [self addSubview:titleLabel];
    
    fieldView = [[MRRegistrationItemView alloc] initWithPlaceholder:placeholderText];
    fieldView.delegate = self;
    fieldView.alpha = 0;
    fieldView.frame = CGRectOffset(fieldView.frame, titleLabel.frame.origin.x+DELTA_ANIM_OFFSET, 0);
    [self addSubview:fieldView];
    
    self.frame = CGRectMake(0, 0, titleLabel.frame.origin.x+titleLabel.frame.size.width, fieldView.bounds.size.height);
    
    checkButton.frame = CGRectMake(checkButton.frame.origin.x,
                                   (self.frame.size.height - checkButton.frame.size.height)/2,
                                   checkButton.frame.size.width, checkButton.frame.size.height);
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x,
                                   (self.frame.size.height - titleLabel.frame.size.height)/2,
                                   titleLabel.frame.size.width, titleLabel.frame.size.height);
}

-(void) onCheck:(UIButton*)button
{
    isCheck = !isCheck;
    
    [UIView animateWithDuration:0.03 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.03f animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [self showCheckImage];
                             [self showEditField];
                         }];
                     }];
}

-(void) simulateClickingByCheck {
    
    isCheck = !isCheck;
    
    if(isCheck)    {
        checkImage.hidden = NO;
        if(_placeholderText.length != 0)
            [fieldView selectField];
    } else {
        checkImage.hidden = YES;
        [fieldView deselectField];
        fieldView.titleField.text = @"";
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, titleLabel.frame.origin.x+titleLabel.frame.size.width, checkButton.bounds.size.height);
    [self showEditField];
}

-(void) showCheckImage
{
    if(isCheck)    {
        checkImage.hidden = NO;
        if(_placeholderText.length != 0)
            [fieldView selectField];
    } else {
        checkImage.hidden = YES;
        [fieldView deselectField];
        fieldView.titleField.text = @"";
    }
    
    if([self.rootDelegate respondsToSelector:@selector(didSelectCheckbox:withActive:)])
    {
        [self.rootDelegate didSelectCheckbox:self withActive:isCheck];
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, titleLabel.frame.origin.x+titleLabel.frame.size.width, checkButton.bounds.size.height);
}

-(void) showEditField
{
    if(_placeholderText.length == 0) return;
    
    if(isCheck) {
        [UIView animateWithDuration:TIMER_ANIM_DELAY animations:^{
            titleLabel.frame = CGRectOffset(titleLabel.frame, DELTA_ANIM_OFFSET, 0);
            titleLabel.alpha = 0;
        }];
        [UIView animateWithDuration:TIMER_ANIM_DELAY animations:^{
            fieldView.frame = CGRectOffset(fieldView.frame, -DELTA_ANIM_OFFSET, 0);
            fieldView.alpha = 1;
        }];
    } else  {
        [UIView animateWithDuration:TIMER_ANIM_DELAY animations:^{
            titleLabel.frame = CGRectOffset(titleLabel.frame, -DELTA_ANIM_OFFSET, 0);
            titleLabel.alpha = 1;
        }];
        [UIView animateWithDuration:TIMER_ANIM_DELAY animations:^{
            fieldView.frame = CGRectOffset(fieldView.frame, DELTA_ANIM_OFFSET, 0);
            fieldView.alpha = 0;
        }];
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fieldView.frame.origin.x+fieldView.frame.size.width, checkButton.bounds.size.height);
}

@end
