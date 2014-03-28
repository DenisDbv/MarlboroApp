//
//  UIView+GestureBlocks.m
//  TheRiverApp
//
//  Created by DenisDbv on 02.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "UIView+GestureBlocks.h"

@implementation UIView (GestureBlocks)

@dynamic tapHandler;

- (void (^) (UIGestureRecognizer *sender))tapHandler {
	return (void (^) (UIGestureRecognizer *sender))objc_getAssociatedObject(self, @"tapHandler");
}

- (void)setTapHandler:(void (^) (UIGestureRecognizer *sender))block {
	objc_setAssociatedObject(self,@"tapHandler",block,OBJC_ASSOCIATION_RETAIN);
}

- (void (^) (UIGestureRecognizer *sender))swipeUpHandler {
	return (void (^) (UIGestureRecognizer *sender))objc_getAssociatedObject(self, @"swipeUpHandler");
}

- (void)setSwipeUpHandler:(void (^) (UIGestureRecognizer *sender))block {
	objc_setAssociatedObject(self,@"swipeUpHandler",block,OBJC_ASSOCIATION_RETAIN);
}

- (void (^) (UIGestureRecognizer *sender))swipeDownHandler {
	return (void (^) (UIGestureRecognizer *sender))objc_getAssociatedObject(self, @"swipeDownHandler");
}

- (void)setSwipeDownHandler:(void (^) (UIGestureRecognizer *sender))block {
	objc_setAssociatedObject(self,@"swipeDownHandler",block,OBJC_ASSOCIATION_RETAIN);
}

- (UITapGestureRecognizer*)initialiseTapHandler:(void (^) (UIGestureRecognizer *sender))block forTaps:(int)numberOfTaps
{
    [self setTapHandler:block];
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleTap:)];
    
    singleFingerDTap.numberOfTapsRequired = numberOfTaps;
    singleFingerDTap.numberOfTouchesRequired = 1;
    
    self.userInteractionEnabled = YES;
    self.superview.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:singleFingerDTap];
    
    return singleFingerDTap;
}

- (IBAction)handleTap:(UIGestureRecognizer *)sender {
    //NSLog(@"Called handletap");
    if (self.tapHandler != nil)
        self.tapHandler(sender);
}

- (void)initialiseSwipeUpHandler:(void (^) (UIGestureRecognizer *sender))block
{
    [self setSwipeUpHandler:block];
    
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    self.userInteractionEnabled = YES;
    self.superview.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:swipeUpGestureRecognizer];
}

- (IBAction)swipeUp:(UIGestureRecognizer *)sender
{
    if (self.swipeUpHandler != nil)
        self.swipeUpHandler(sender);
}

- (void)initialiseSwipeDownHandler:(void (^) (UIGestureRecognizer *sender))block
{
    [self setSwipeDownHandler:block];
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    self.userInteractionEnabled = YES;
    self.superview.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:swipeDownGestureRecognizer];
}

- (IBAction)swipeDown:(UIGestureRecognizer *)sender
{
    if (self.swipeDownHandler != nil)
        self.swipeDownHandler(sender);
}

@end
