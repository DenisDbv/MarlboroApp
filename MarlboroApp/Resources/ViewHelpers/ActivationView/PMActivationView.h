//
//  PMActivationView.h
//  ParlamentApp
//
//  Created by DenisDbv on 07.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    eBarcode = 0,
    eLogo,
    eStamp,
    ePrint
    
} ActivationIDs;

@class PMActivationView;

@protocol PMActivationViewDelegate <NSObject>
-(void) activationView:(PMActivationView*)activationView didSelectWithID:(ActivationIDs)ids;
@end

@interface PMActivationView : UIView

@property (nonatomic, strong) id<PMActivationViewDelegate> delegate;
@property (nonatomic, assign) ActivationIDs ids;

@property (nonatomic, strong) UIButton *activeButton;
@property (nonatomic, strong) UILabel *englishDesc;

-(id) initWithActivationID:(NSInteger)id withText:(BOOL)textShow;
-(void) disableActivation:(BOOL)isDisable;

@end
