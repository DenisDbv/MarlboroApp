//
//  PMMailManager.m
//  ParlamentApp
//
//  Created by DenisDbv on 17.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMMailManager.h"
#import "NSData+Base64Additions.h"

#import <CFNetwork/CFNetwork.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface PMMailManager() <UIApplicationDelegate>

@end

@implementation PMMailManager


-(id) init  {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void) sendMessageWithTitle:(NSString*)title
                      text:(NSString*)text
                     image:(UIImage*)image
                  filename:(NSString*)filename
{
    NSString *imageString;
    
    if(image != nil)    {
        NSData *imageData = UIImagePNGRepresentation(image);
        imageString = [NSString stringWithFormat:@"%@", [imageData encodeBase64ForData]];
    } else  {
        imageString = @"";
        filename = @"";
    }
    
    NSDictionary *parameters = @{@"emailTo": [MRDataManager sharedInstance].emailRegValue,
                                 @"title": title,
                                 @"text": text,
                                 @"image": imageString,
                                 @"filename": filename};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://brandmill.ru/sendparliament/index.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        //if(responseString.length < 10000)
        //    NSLog(@"responseString: %@", responseString);
        //else
        //    NSLog(@"responseString: %@", [responseString substringToIndex:10000] );
        
        if([self.delegate respondsToSelector:@selector(mailSendSuccessfully)])
        {
            [self.delegate mailSendSuccessfully];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ (%@)", error, operation.responseString);
        
        if([self.delegate respondsToSelector:@selector(mailSendFailed)])
        {
            [self.delegate mailSendFailed];
        }
    }];
}

@end
