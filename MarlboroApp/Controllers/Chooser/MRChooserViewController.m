//
//  MRChooserViewController.m
//  MarlboroApp
//
//  Created by DenisDbv on 28.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRChooserViewController.h"
#import "MRCheckItem.h"

#import <MZFormSheetController/MZFormSheetController.h>

@interface MRChooserViewController ()

@end

@implementation MRChooserViewController
{
    NSString *_title;
    NSDictionary *_checkListArray;
    NSMutableArray *checkViewArray;
    
    UILabel *titleLabel;
}

//NSDictionary (key => checkbox name)
//save by pattern (key => bool value)
-(id) initWithTitle:(NSString*)title withCheckboxList:(NSDictionary*)checkListDictionary
{
    self = [super initWithNibName:@"MRChooserViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _title = title;
        _checkListArray = checkListDictionary;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    titleLabel = [[UILabel alloc] init];
    titleLabel.alpha = 1;
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DEFAULT_COLOR_SCHEME;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _title;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.bounds.size.width - titleLabel.frame.size.width)/2,
                                  185,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    [self.view addSubview:titleLabel];
    
    [self configureChecker];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onExit:) name:MROnExitClickNotification object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self showExitButton];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MROnExitClickNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onExit:(NSNotification*)notification
{
    [self.navigationController.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    if(self.view.frame.origin.y < 0) return;
    
    if(_checkListArray.count >= 3)  {
        [UIView animateWithDuration:0.3 animations:^{
            titleLabel.alpha = 0;
            
            CGRect rect = self.view.frame;
            rect.origin.y -= 200;
            self.view.frame = rect;
        }];
    } else  {
        [UIView animateWithDuration:0.3 animations:^{
            //titleLabel.alpha = 0;
            
            CGRect rect = self.view.frame;
            rect.origin.y -= 100;
            self.view.frame = rect;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    if(_checkListArray.count >= 3)  {
        [UIView animateWithDuration:0.3 animations:^{
            titleLabel.alpha = 1;
            
            CGRect rect = self.view.frame;
            rect.origin.y += 200;
            self.view.frame = rect;
        }];
    } else  {
        [UIView animateWithDuration:0.3 animations:^{
            //titleLabel.alpha = 0;
            
            CGRect rect = self.view.frame;
            rect.origin.y += 100;
            self.view.frame = rect;
        }];
    }
}

-(void) configureChecker
{
    checkViewArray = [[NSMutableArray alloc] init];
    NSInteger marginTop = titleLabel.frame.origin.y + titleLabel.frame.size.height + 70;
    
    __block int centerX = 0;
    __block int loop = 0;
    [_checkListArray enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary *objectItem = obj;
        
        MRCheckItem *checkItem = [[MRCheckItem alloc] initWithTitle:[objectItem valueForKey:@"titleKey"] byKey:key withPlaceholder:[objectItem valueForKey:@"placeholderKey"]];
        checkItem.rootDelegate = self;
        
        if(loop == 0)   {
            centerX = (self.view.bounds.size.width - checkItem.frame.size.width)/2;
        }
        
        checkItem.frame = CGRectOffset(checkItem.frame, centerX, (loop * (checkItem.frame.size.height+27)) + marginTop);
        [self.view addSubview:checkItem];
        [checkViewArray addObject:checkItem];
        
        loop++;
    }];
}

@end
