//
//  MRPhotoViewController.h
//  MarlboroApp
//
//  Created by DenisDbv on 16.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRPhotoViewControllerDelegate <NSObject>
-(void) photoDidDone:(UIImage*)image;
@end

@interface MRPhotoViewController : UIViewController

@property (nonatomic, weak) id <MRPhotoViewControllerDelegate> delegate;

-(void) start;
-(void) stop;

-(void) showAllContext;
-(void) hideAllContext;

-(void) showModalImage:(UIImage*)image;

@end
