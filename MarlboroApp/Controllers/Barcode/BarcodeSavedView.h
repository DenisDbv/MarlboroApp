//
//  BarcodeSavedView.h
//  MarlboroApp
//
//  Created by DenisDbv on 30.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "UIView+NibLoading.h"

@protocol BarcodeSavedViewDelegate <NSObject>
-(void) exitFromFinishView;
@end

@interface BarcodeSavedView : NibLoadedView

@property (nonatomic, strong) id <BarcodeSavedViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *finishTitle1;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle2;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle3;

-(void) setDefault;

-(void) animateView;

@end
