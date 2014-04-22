//
//  MRImageBlockView.m
//  MarlboroApp
//
//  Created by DenisDbv on 16.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRImageBlockView.h"
#import "UIView+GestureBlocks.h"

#import <QuartzCore/QuartzCore.h>

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
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blank-photo.png"]];
        imageView.tag = loop;
        imageView.frame = CGRectMake(loop*(imageWidth+3), 0, imageWidth, self.bounds.size.height);
        [imageView setContentMode:UIViewContentModeScaleToFill];
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0].CGColor;
        [self addSubview:imageView];
        
        [images addObject:imageView];
        
        [imageView initialiseTapHandler:^(UIGestureRecognizer *sender) {
            [self onClickByImage:imageView.tag];
        } forTaps:1];
    }
    
    selectItem = 0;
    [self selectImageIndex:selectItem];
    //self.backgroundColor = [UIColor redColor];
}

-(void) setImage:(UIImage*)image byIndex:(NSInteger)index   {
    if(index >= IMAGE_NUMBER) return;
    
    UIImageView *imageView = images[index];
    imageView.image = image;
    NSLog(@"%@", NSStringFromCGRect(imageView.frame));
}

-(NSInteger) selectItem {
    return selectItem;
}

-(void) nextItem    {
    [self deselectImageIndex:selectItem];
    selectItem++;
    if(selectItem >= IMAGE_NUMBER)  selectItem = 0;
    [self selectImageIndex:selectItem];
}

-(void) firstItem   {
    [self deselectImageIndex:selectItem];
    selectItem = 0;
    [self selectImageIndex:selectItem];
}

-(void) onClickByImage:(NSInteger)index
{
    NSLog(@"%i image by clicked", index);
    
    [self deselectImageIndex:selectItem];
    selectItem = index;
    [self selectImageIndex:selectItem];
    
    if([self.delegate respondsToSelector:@selector(imageBlockClickedByIndex:)]) {
        [self.delegate imageBlockClickedByIndex:index];
    }
}

-(void) selectImageIndex:(NSInteger)index   {
    UIImageView *imageView = images[index];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds];
    imageView.layer.masksToBounds = NO;
    imageView.layer.shadowColor = [UIColor colorWithRed:165.0/255.0 green:124.0/255.0 blue:48.0/255.0 alpha:1.0].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
    imageView.layer.shadowOpacity = 0.8f;
    imageView.layer.shadowPath = shadowPath.CGPath;
    
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0].CGColor;
}

-(void) deselectImageIndex:(NSInteger)index   {
    UIImageView *imageView = images[index];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds];
    imageView.layer.masksToBounds = NO;
    imageView.layer.shadowColor = [UIColor colorWithRed:165.0/255.0 green:124.0/255.0 blue:48.0/255.0 alpha:0.0].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
    imageView.layer.shadowOpacity = 0.0f;
    imageView.layer.shadowPath = shadowPath.CGPath;
    
    imageView.layer.borderWidth = 1.0;
    imageView.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:202.0/255.0 blue:121.0/255.0 alpha:1.0].CGColor;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
