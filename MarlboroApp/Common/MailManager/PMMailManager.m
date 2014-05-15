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
#import <Reachability/Reachability.h>

#import "SKPSMTPMessage.h"

@interface PMMailManager() <UIApplicationDelegate, SKPSMTPMessageDelegate>
@property (nonatomic, strong) SKPSMTPMessage *smtpMsg;
@end

@implementation PMMailManager
{
    BOOL isSending;
    BOOL isCancel;
    BOOL isMailClient;
}
@synthesize smtpMsg;

-(id) init  {
    
    if (self = [super init]) {
        isSending = NO;
        isCancel = NO;
        isMailClient = NO;
    }
    
    return self;
}

-(BOOL) isSending
{
    return isSending;
}

-(BOOL) isMailClient
{
    return isMailClient;
}

-(void) sendMessageWithTitle:(NSString*)title
                    subtitle:(NSString*)subtitle
                    subtitle2:(NSString*)subtitle2
                      text:(NSString*)text
                     image:(UIImage*)image
                    rezImage:(UIImage*)rezImage
                  filename:(NSString*)filename
                     forName:(NSString*)name
{
    NSString *serverURL;
    serverURL = @"http://brandmill.ru/sendmarlboro/index.php";
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.brandmill.ru"];
    if(reach.currentReachabilityStatus == NotReachable)    {
        NSLog(@"Denis server access denied!");
        serverURL = @"http://rockwoolpromo.ru/sendmarlboro/index.php";
    }
    
    NSString *imageString;
    NSString *imageRezString;
    NSString *emailRegValue = ([MRDataManager sharedInstance].emailRegValue.length > 0) ? [MRDataManager sharedInstance].emailRegValue : @"";
    if(name.length == 0) name = @" ";
    
    if(image != nil ) {//&& rezImage != nil)    {
        NSData *imageData = UIImagePNGRepresentation(image);
        imageString = [NSString stringWithFormat:@"%@", [imageData encodeBase64ForData]];
        
        //NSData *imageData2 = UIImagePNGRepresentation(rezImage);
        //imageRezString = [NSString stringWithFormat:@"%@", [imageData2 encodeBase64ForData]];
    } else  {
        imageString = @"";
        //imageRezString = @"";
        filename = @"";
    }
    
    NSDictionary *parameters = @{@"subject":@"Agent M-Port",
                                 @"subtitle":subtitle,
                                 @"subtitle2":subtitle2,
                                 @"emailTo": emailRegValue,
                                 @"name": name,
                                 @"title": title,
                                 @"text": text,
                                 @"image": imageString,
                                 //@"bigimage": @"", //imageRezString,
                                 @"filename": filename};
    
    isSending = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:serverURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseString: %@", responseString);
        
        NSLog(@"Mail was send!");
        
        //if(responseString.length < 10000)
        //    NSLog(@"responseString: %@", responseString);
        //else
            //NSLog(@"responseString: %@", [responseString substringToIndex:10000] );
        isSending = NO;
        if([self.delegate respondsToSelector:@selector(mailSendSuccessfully)])
        {
            [self.delegate mailSendSuccessfully];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@ (%@)", error, operation.responseString);
        
        isSending = NO;
        if([self.delegate respondsToSelector:@selector(mailSendFailed)])
        {
            [self.delegate mailSendFailed];
        }
    }];
}

-(void) sendDataToServer:(ActivationIDs)activationID
               withImage:(UIImage*)image
            teplateIndex:(NSInteger)templateIndex
               fontIndex:(NSInteger)fontIndex
                  withEu:(BOOL)withEu
                    text:(NSString*)text
                subtitle:(NSString*)subtitle
               subtitle2:(NSString*)subtitle2   {
    
    NSString *serverURL;
    serverURL = @"http://185.26.112.87/index.php";
    
    NSString *cmd = (activationID == eBarcode) ? @"barcode" :@"logo";
    NSString *filename = (activationID == eBarcode) ? @"barcode.png" :@"logo.png";
    NSString *name = [MRDataManager sharedInstance].nameValue;
    NSString *lastName = [MRDataManager sharedInstance].surnameValue;
    NSString *midName = [MRDataManager sharedInstance].patronymicValue;
    NSString *phone = [MRDataManager sharedInstance].phoneValue;
    NSString *emailRegValue = ([MRDataManager sharedInstance].emailRegValue.length > 0) ? [MRDataManager sharedInstance].emailRegValue : @"";
    
    NSString *commentRegValue = ([MRDataManager sharedInstance].commentRegValue.length > 0) ? [MRDataManager sharedInstance].commentRegValue : @"";
    NSInteger suvenirIndex = 0;
    if([MRDataManager sharedInstance].tshirtSignKey == YES)    {
        suvenirIndex = 0;
    } else  if([MRDataManager sharedInstance].lighterSignKey == YES) {
        suvenirIndex = 1;
    } else if([MRDataManager sharedInstance].flashCardSignKey == YES)  {
        suvenirIndex = 2;
    }
    
    NSInteger print = 0;
    if([MRDataManager sharedInstance].sendToEmailKey == YES && [MRDataManager sharedInstance].sendToPrintKey == YES)    {
        print = 2;
    } else  {
        if([MRDataManager sharedInstance].sendToEmailKey == YES)
            print = 0;
        else
            print = 1;
    }
    
    NSString *imageString;
    if(image != nil ) {//&& rezImage != nil)    {
        NSData *imageData = UIImagePNGRepresentation(image);
        imageString = [NSString stringWithFormat:@"%@", [imageData encodeBase64ForData]];
    } else  {
        imageString = @"";
    }
    
    NSDictionary *parameters = @{@"subject":@"Agent M-Port",
                                 @"image":imageString,
                                 @"email":emailRegValue,
                                 @"cmd":cmd,
                                 @"template":[NSNumber numberWithInteger:templateIndex],
                                 @"font":[NSNumber numberWithInteger:fontIndex],
                                 @"name":name,
                                 @"lastName":lastName,
                                 @"midName":midName,
                                 @"phone":phone,
                                 @"eu":[NSNumber numberWithBool:withEu],
                                 @"print":[NSNumber numberWithInteger:print],
                                 @"filename":filename,
                                 @"text": text,
                                 @"subtitle":subtitle,
                                 @"subtitle2":subtitle2,
                                 @"bangle":commentRegValue,
                                 @"souvenir":[NSNumber numberWithInteger:suvenirIndex]};
    
    if(activationID == eBarcode)    {
        parameters = @{@"subject":@"Agent M-Port",
                       @"image":imageString,
                       @"email":emailRegValue,
                       @"cmd":cmd,
                       @"template":[NSNumber numberWithInteger:templateIndex],
                       @"font":[NSNumber numberWithInteger:fontIndex],
                       @"name":name,
                       @"lastName":lastName,
                       @"phone":phone,
                       @"text_flag":[NSNumber numberWithBool:[MRDataManager sharedInstance].nameSignValue],
                       @"phoneFlag":[NSNumber numberWithBool:[MRDataManager sharedInstance].phoneSignValue],
                       @"eu":[NSNumber numberWithBool:withEu],
                       @"print":[NSNumber numberWithInteger:print],
                       @"filename":filename,
                       @"text": text,
                       @"subtitle":subtitle,
                       @"subtitle2":subtitle2,
                       @"bangle":commentRegValue,
                       @"souvenir":[NSNumber numberWithInteger:suvenirIndex]};
    }
    
    isSending = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:serverURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseString: %@", responseString);
        
        isSending = NO;
        if([self.delegate respondsToSelector:@selector(mailSendSuccessfully)])
        {
            [self.delegate mailSendSuccessfully];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ (%@)", error, operation.responseString);
        
        isSending = NO;
        if([self.delegate respondsToSelector:@selector(mailSendFailed)])
        {
            [self.delegate mailSendFailed];
        }
    }];
}

-(void) cancellAll
{
    isCancel = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    
    NSLog(@"Operations count: %i", [manager.operationQueue operationCount]);
}

-(void) sendMessageMyMail:(NSString*)text
                    image:(UIImage*)image
{
    NSString *emailRegValue = ([MRDataManager sharedInstance].emailRegValue.length > 0) ? [MRDataManager sharedInstance].emailRegValue : @"";
    
    //[04.04.14, 19:11:01] Alexander Radchenko: malborotesting@gmail.com
    //[04.04.14, 19:11:06] Alexander Radchenko: gfhjkmlkzntcnf
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        smtpMsg = [[SKPSMTPMessage alloc] init];
        smtpMsg.fromEmail = @"art.individuality@gmail.com";
        smtpMsg.toEmail = emailRegValue;
        smtpMsg.bccEmail = @"";
        smtpMsg.relayHost = @"smtp.gmail.com";
        smtpMsg.requiresAuth = YES;
        if (smtpMsg.requiresAuth) {
            smtpMsg.login = @"art.individuality@gmail.com";
            smtpMsg.pass = @"QazWsx1234";
        }
        smtpMsg.wantsSecure = YES;
        smtpMsg.subject = @"Активация от M.GO.Design";
        smtpMsg.delegate = self;
        
        NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"text/plain",kSKPSMTPPartContentTypeKey,
                                   text,kSKPSMTPPartMessageKey,@"8bit",
                                   kSKPSMTPPartContentTransferEncodingKey,nil];
        
        NSData *vcfData = UIImagePNGRepresentation(image);
        NSString *contentTypeString = [NSString stringWithFormat:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@\"", @"file.png"];
        NSString *contentDispositionString = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@\"", @"file.png"];
        
        NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:
                                 contentTypeString,kSKPSMTPPartContentTypeKey,
                                 contentDispositionString,kSKPSMTPPartContentDispositionKey,
                                 [vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,
                                 @"base64",kSKPSMTPPartContentTransferEncodingKey, nil];
        
        smtpMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,nil];
        [smtpMsg send];
    });
}

- (void)messageSent:(SKPSMTPMessage *)message
{
    if(isCancel) return;
    NSLog(@"Mail was send!");
    
    if([self.delegate respondsToSelector:@selector(mailSendSuccessfully)])
    {
        [self.delegate mailSendSuccessfully];
    }
    
    smtpMsg = nil;
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    if(isCancel) return;
    NSLog(@"Mail was failed. delegate - error(%d): %@", [error code], [error localizedDescription]);
    
    if([self.delegate respondsToSelector:@selector(mailSendFailed)])
    {
        [self.delegate mailSendFailed];
    }
    
    smtpMsg = nil;
}

@end
