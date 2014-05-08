//
//  MRSenderChooser.m
//  MarlboroApp
//
//  Created by DenisDbv on 29.04.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRSenderChooser.h"
#import "MRCheckItem.h"

@implementation MRSenderChooser
{
    UILabel *titleLabel;
    NSMutableArray *checkViewArray;
}
@synthesize continueButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) initialize  {
    [MRDataManager sharedInstance].sendToEmailKey = NO;
    [MRDataManager sharedInstance].sendToPrintKey = NO;
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"exit.png"];
    [exitButton addTarget:self action:@selector(onExit:) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setImage:buttonImage forState:UIControlStateNormal];
    [exitButton setImage:buttonImage forState:UIControlStateHighlighted];
    exitButton.frame = CGRectMake(10, 10, buttonImage.size.width, buttonImage.size.height);
    [self addSubview:exitButton];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.alpha = 1;
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DEFAULT_COLOR_SCHEME;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"ВЫБОР ПУНКТА НАЗНАЧЕНИЯ";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    [self addSubview:titleLabel];
    
    [self configureChecker];
}

-(void) configureChecker
{
    checkViewArray = [[NSMutableArray alloc] init];
    
    MRCheckItem *checkItem = [[MRCheckItem alloc] initWithTitle:@"ОТПРАВИТЬ НА ПОЧТУ" byKey:@"" withPlaceholder:@""];
    checkItem.rootDelegate = self;
    checkItem.indexItem = 1;
    [checkViewArray addObject:checkItem];
    MRCheckItem *checkItem2 = [[MRCheckItem alloc] initWithTitle:@"ОТПРАВИТЬ НА ПЕЧАТЬ" byKey:@"" withPlaceholder:@""];
    checkItem2.rootDelegate = self;
    checkItem2.indexItem = 2;
    [checkViewArray addObject:checkItem2];
    
    NSInteger marginTop = titleLabel.frame.origin.y + titleLabel.frame.size.height + ((checkViewArray.count>3)?30:70);
    
    __block int centerX = 0;
    __block int loop = 0;
    for(MRCheckItem *checkItem in checkViewArray)   {
        if(loop == 0)   {
            centerX = (self.bounds.size.width - checkItem.frame.size.width)/2;
        }
        
        checkItem.frame = CGRectOffset(checkItem.frame, centerX, (loop * (checkItem.frame.size.height+15)) + marginTop);
        [self addSubview:checkItem];
        
        loop++;
    }
    
    checkItem = [checkViewArray lastObject];
    continueButton.frame = CGRectMake((self.bounds.size.width - continueButton.frame.size.width)/2,
                                      checkItem.frame.origin.y+checkItem.frame.size.height+((checkViewArray.count>3)?30:70),
                                      continueButton.frame.size.width, continueButton.frame.size.height);
}

-(void) didSelectCheckbox:(MRCheckItem*)item withActive:(BOOL)active
{
    NSLog(@"%i) %i", item.indexItem, active);
    
    if(item.indexItem == 1) {
        [MRDataManager sharedInstance].sendToEmailKey = active;
    } else  {
        [MRDataManager sharedInstance].sendToPrintKey = active;
    }
    [[MRDataManager sharedInstance] save];
}

-(void) onExit:(UIButton*)sender    {
    if([self.delegate respondsToSelector:@selector(onExitAfterSenderChecker)])  {
        [self.delegate onExitAfterSenderChecker];
    }
}

- (IBAction)onContinue:(id)sender
{
    if([MRDataManager sharedInstance].sendToEmailKey == YES || [MRDataManager sharedInstance].sendToPrintKey == YES)    {
        if([self.delegate respondsToSelector:@selector(onContinueAfterSenderChecker)])  {
            [self.delegate onContinueAfterSenderChecker];
        }
    }
}

@end
