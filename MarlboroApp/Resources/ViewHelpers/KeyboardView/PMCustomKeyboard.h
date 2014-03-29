//
//  PMCustomKeyboard.h
//  ParlamentApp
//
//  Created by DenisDbv on 12.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PMCustomKeyboard : UIView <UIInputViewAudioFeedback>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *characterKeys;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberKeys;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *languageButton;
@property (strong, nonatomic) IBOutlet UIButton *upDownButton;
@property (strong) id<UITextInput> textView;

@property (nonatomic, assign) BOOL isRu;
@property (nonatomic, assign) BOOL isUP;

- (IBAction)deletePressed:(id)sender;
- (IBAction)languagePressed:(id)sender;
- (IBAction)upDownPressed:(id)sender;

@end
