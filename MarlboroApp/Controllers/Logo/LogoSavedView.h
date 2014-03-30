//
//  LogoSavedView.h
//  MarlboroApp
//
//  Created by DenisDbv on 31.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "UIView+NibLoading.h"

@protocol LogoSavedViewDelegate <NSObject>
-(void) exitFromFinishView;
@end

@interface LogoSavedView : NibLoadedView

@property (nonatomic, strong) id <LogoSavedViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *finishTitle1;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle2;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle3;

-(void) setDefault;

-(void) animateView;

@end
