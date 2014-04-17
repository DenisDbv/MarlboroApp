//
//  MRImageBlockView.m
//  MarlboroApp
//
//  Created by DenisDbv on 16.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRImageBlockView.h"
#import "UIView+GestureBlocks.h"

#define IMAGE_NUMBER    4

@implementation MRImageBlockView
{
    NSMutableArray *images;
    NSInteger selectItem;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize  {
    NSInteger imageWidth = self.bounds.size.width/IMAGE_NUMBER;
    
    images = [[NSMutableArray alloc] initWithCapacity:IMAGE_NUMBER];
    
    for(int loop=0; loop < IMAGE_NUMBER; loop++)   {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person.jpg"]];
        imageView.tag = loop;
        imageView.frame = CGRectMake(loop*(imageWidth+3), 0, imageWidth, self.bounds.size.height);
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imageView];
        
        [images addObject:imageView];
        
        [imageView initialiseTapHandler:^(UIGestureRecognizer *sender) {
            [self onClickByImage:imageView.tag];
        } forTaps:1];
    }
    
    selectItem = 0;
    //self.backgroundColor = [UIColor redColor];
}

-(void) setImage:(UIImage*)image byIndex:(NSInteger)index   {
    if(index >= IMAGE_NUMBER) return;
    
    UIImageView *imageView = images[index];
    imageView.image = image;
}

-(NSInteger) selectItem {
    return selectItem;
}

-(void) nextItem    {
    selectItem++;
    if(selectItem >= IMAGE_NUMBER)  selectItem = 0;
}

-(void) onClickByImage:(NSInteger)index
{
    NSLog(@"%i", index);
    
    selectItem = index;
    
    if([self.delegate respondsToSelector:@selector(imageBlockClickedByIndex:)]) {
        [self.delegate imageBlockClickedByIndex:index];
    }
}

@end
