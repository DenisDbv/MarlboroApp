//
//  MRLogoListViewController.h
//  MarlboroApp
//
//  Created by DenisDbv on 31.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRParentViewController.h"
#import <iCarousel/iCarousel.h>

@interface MRLogoListViewController : MRParentViewController

@property (nonatomic, strong) IBOutlet iCarousel *carouselLogoList;
@property (nonatomic, strong) IBOutlet iCarousel *carouselLogoFonts;

@end
