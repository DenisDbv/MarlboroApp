//
//  MRImageBlockView.h
//  MarlboroApp
//
//  Created by DenisDbv on 16.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRImageBlockViewDelegate <NSObject>
-(void) imageBlockClickedByIndex:(NSInteger)index;
@end

@interface MRImageBlockView : UIView

@property (nonatomic, weak) id <MRImageBlockViewDelegate> delegate;

-(void) setImage:(UIImage*)image byIndex:(NSInteger)index;
-(NSInteger) selectItem;
-(void) nextItem;
-(void) firstItem;

@end
