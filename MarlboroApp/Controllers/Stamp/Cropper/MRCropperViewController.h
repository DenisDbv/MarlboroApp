//
//  MRCropperViewController.h
//  MarlboroApp
//
//  Created by DenisDbv on 17.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRCropperViewControllerDelegate <NSObject>
-(void) cropDidDoneImage:(UIImage*)image;
@end

@interface MRCropperViewController : UIViewController

@property (nonatomic, weak) id <MRCropperViewControllerDelegate> delegate;

-(void) showAllContext;
-(void) hideAllContext;

-(void) setImageForCrop:(UIImage*)image;

@end
