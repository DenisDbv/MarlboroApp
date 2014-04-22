//
//  StampSavedView.h
//  MarlboroApp
//
//  Created by DenisDbv on 18.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "UIView+NibLoading.h"

@protocol StampSavedViewDelegate <NSObject>
-(void) exitFromFinishView;
@end

@interface StampSavedView : NibLoadedView

@property (nonatomic, strong) id <StampSavedViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *finishTitle1;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle2;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle3;

-(void) setDefault;

-(void) animateView;

@end
