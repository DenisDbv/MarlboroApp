//
//  MRFilterViewController.h
//  MarlboroApp
//
//  Created by DenisDbv on 17.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRFilterViewControllerDelegate <NSObject>
-(void) filterShowSideBar;
-(void) filterDidDoneImage:(UIImage*)image;
@end

@interface MRFilterViewController : UIViewController

@property (nonatomic, weak) id <MRFilterViewControllerDelegate> delegate;

-(void) setImageForFilter:(UIImage*)image;

@end
