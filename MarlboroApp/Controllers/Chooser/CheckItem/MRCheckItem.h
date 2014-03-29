//
//  MRCheckItem.h
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRRegistrationItemView.h"

@interface MRCheckItem : UIView <MRRegistrationItemViewDelegate>

@property (nonatomic, strong) id rootDelegate;

- (id)initWithTitle:(NSString*)title byKey:(NSString*)key withPlaceholder:(NSString*)placeholderText;

@end
