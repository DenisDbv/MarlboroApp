//
//  MRResultStampViewController.h
//  MarlboroApp
//
//  Created by DenisDbv on 17.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRResultStampViewControllerDelegate <NSObject>
-(void) finishSuccessfulStampController;
@end

@interface MRResultStampViewController : UIViewController

@property (nonatomic, weak) id <MRResultStampViewControllerDelegate> delegate;

-(id) initWithStampImages:(NSArray*)stampImagesArray;

@end
