//
//  Global.h
//  ParlamentApp
//
//  Created by DenisDbv on 07.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#ifndef ParlamentApp_Global_h
#define ParlamentApp_Global_h

#import "MRAppDelegate.h"

#define AppDelegateInstance() (MRAppDelegate *)[[UIApplication sharedApplication] delegate]

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define DEFAULT_COLOR_SCHEME [UIColor colorWithRed:233.0/255.0 green:210.0/255.0 blue:167.0/255.0 alpha:1.0]

#endif
