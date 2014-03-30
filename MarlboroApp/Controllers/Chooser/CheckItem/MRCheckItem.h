//
//  MRCheckItem.h
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRRegistrationItemView.h"

@class MRCheckItem;

@protocol MRCheckItemDelegate <NSObject>
-(void) didSelectCheckbox:(MRCheckItem*)item withActive:(BOOL)active;
@end

@interface MRCheckItem : UIView <MRRegistrationItemViewDelegate>

@property (nonatomic, strong) id rootDelegate;
@property (nonatomic, strong) MRRegistrationItemView *fieldView;
@property (nonatomic, strong) NSString *_key;
@property (nonatomic) BOOL isCheck;

@property (nonatomic) NSInteger indexItem;

- (id)initWithTitle:(NSString*)title byKey:(NSString*)key withPlaceholder:(NSString*)placeholderText;

@end
