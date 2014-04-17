//
//  MRGameViewController.h
//  MarlboroApp
//
//  Created by DenisDbv on 15.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRParentViewController.h"
#import "PMActivationView.h"

@interface MRGameViewController : MRParentViewController

- (id)initWithActiveID:(ActivationIDs)activeID;

@property (nonatomic) BOOL isExit;

@end
