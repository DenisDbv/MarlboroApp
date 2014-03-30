//
//  PMMailManager.h
//  ParlamentApp
//
//  Created by DenisDbv on 17.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMMailManagerDelegate <NSObject>
-(void) mailSendSuccessfully;
-(void) mailSendFailed;
@end

@interface PMMailManager : NSObject

@property (nonatomic, strong) id <PMMailManagerDelegate> delegate;

-(void) sendMessageWithTitle:(NSString*)title
                         text:(NSString*)text
                        image:(UIImage*)image
                     filename:(NSString*)filename;

@end
