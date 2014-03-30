//
//  PMActivationView.m
//  ParlamentApp
//
//  Created by DenisDbv on 07.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMActivationView.h"
#import "UIView+GestureBlocks.h"

@implementation PMActivationView
{
    //ActivationIDs ids;
    BOOL _textShow;
    UIImageView *activationImageView;
}
@synthesize delegate;
@synthesize ids;
@synthesize activeButton, englishDesc;

-(id) initWithActivationID:(NSInteger)id withText:(BOOL)textShow
{
    self = [super initWithFrame:CGRectMake(0, 0, 170.0, 170.0)];
    if (self) {
        ids = id;
        _textShow = textShow;
        [self initializeActivation];
        [self hidden];
        
        //self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void) initializeActivation
{
    activationImageView = [[UIImageView alloc] initWithImage:[self imageActivation]];
    
    UIImage *settingImage = [self imageActivation];
    activeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [activeButton addTarget:self action:@selector(onActiveClick:) forControlEvents:UIControlEventTouchDown];
    [activeButton setImage:settingImage forState:UIControlStateNormal];
    [activeButton setImage:settingImage forState:UIControlStateHighlighted];
    activeButton.frame = CGRectMake(0, 0, settingImage.size.width, settingImage.size.height);
    [self addSubview:activeButton];
    
    if(_textShow)   {
        englishDesc = [[UILabel alloc] init];
        englishDesc.font = [UIFont fontWithName:@"OPTIAgency-Gothic" size:30.0];
        englishDesc.backgroundColor = [UIColor clearColor];
        englishDesc.textColor = DEFAULT_COLOR_SCHEME;
        englishDesc.textAlignment = NSTextAlignmentCenter;
        englishDesc.text = [self englishDescription];
        [englishDesc sizeToFit];
        englishDesc.frame = CGRectMake((self.frame.size.width-englishDesc.frame.size.width)/2,
                                       activationImageView.frame.size.height + 55,
                                       englishDesc.frame.size.width,
                                       englishDesc.frame.size.height);
        [self addSubview:englishDesc];
        
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                englishDesc.frame.origin.y+englishDesc.frame.size.height);
    }
    
    [activationImageView initialiseTapHandler:^(UIGestureRecognizer *sender) {
        [UIView animateWithDuration:0.05 animations:^{
            activationImageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.05f animations:^{
                                 activationImageView.transform = CGAffineTransformMakeScale(1, 1);
                             } completion:^(BOOL finished) {
                                 if( [delegate respondsToSelector:@selector(activationView:didSelectWithID:)] )
                                 {
                                     [delegate activationView:self didSelectWithID:ids];
                                 }
                             }];
                         }];
    } forTaps:1];
}

-(void) hidden
{
    activeButton.alpha = 0;
    englishDesc.alpha = 0;
}

-(void) onActiveClick:(UIButton*)activeBtn
{
    [UIView animateWithDuration:0.05 animations:^{
        activeBtn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             activeBtn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             if( [delegate respondsToSelector:@selector(activationView:didSelectWithID:)] )
                             {
                                 [delegate activationView:self didSelectWithID:ids];
                             }
                         }];
                     }];
}

-(UIImage*) imageActivation
{
    switch (ids) {
        case eBarcode:
            return [UIImage imageNamed:@"active_barcode.png"];
            break;
        case eLogo:
            return [UIImage imageNamed:@"active_logo.png"];
            break;
        case eStamp:
            return [UIImage imageNamed:@"active_stamp.png"];
            break;
        case ePrint:
            return [UIImage imageNamed:@"active_print.png"];
            break;
            
        default:
            break;
    }
    return nil;
}

-(NSString*) englishDescription
{
    switch (ids) {
        case eBarcode:
            return @"BARCODE";
            break;
        case eLogo:
            return @"LOGOTYPE";
            break;
        case eStamp:
            return @"POSTSTAMP";
            break;
        case ePrint:
            return @"PERSONAL STAMP";
            break;
            
        default:
            break;
    }
    return nil;
}

@end
