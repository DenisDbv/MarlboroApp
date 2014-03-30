//
//  MRRegistrationItemView.h
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCustomKeyboard.h"

@class MRRegistrationItemView;

@protocol MRRegistrationItemViewDelegate <NSObject>
-(void) didSelectField:(MRRegistrationItemView*)fieldView;
-(void) didEndSelectField:(MRRegistrationItemView*)fieldView;
@end

@interface MRRegistrationItemView : UIView

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) id <MRRegistrationItemViewDelegate> delegate;

- (id)initWithPlaceholder:(NSString*)text;
- (id)initWithPlaceholder:(NSString*)text withKeyboardLangType:(LanguageType)langType;

-(void) selectField;
-(void) deselectField;

@end
