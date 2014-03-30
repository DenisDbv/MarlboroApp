//
//  PMTimeManager.h
//  ParlamentApp
//
//  Created by DenisDbv on 22.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    tNone = 0,
    tMorning,
    tDinner,
    tEvening,
    tNight
    
} TimeArea;

@interface PMTimeManager : NSObject

-(NSString*) titleTimeArea;
-(TimeArea) timeArea;
-(NSString*) timeAreaName:(TimeArea)timeArea;

@end
