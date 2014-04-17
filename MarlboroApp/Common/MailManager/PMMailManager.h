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

-(BOOL) isSending;

-(void) sendMessageWithTitle:(NSString*)title
                    subtitle:(NSString*)subtitle
                   subtitle2:(NSString*)subtitle2
                        text:(NSString*)text
                       image:(UIImage*)image
                    rezImage:(UIImage*)rezImage
                    filename:(NSString*)filename
                     forName:(NSString*)name;

-(void) cancellAll;
-(BOOL) isMailClient;

-(void) sendMessageMyMail:(NSString*)text
                    image:(UIImage*)image;

@end
