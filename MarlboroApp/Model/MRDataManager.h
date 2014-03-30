//
//  MRDataManager.h
//  MarlboroApp
//
//  Created by DenisDbv on 30.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ABMultiton/ABMultitonProtocol.h>
#import <ABMultiton/ABMultiton.h>

//Registration person data
#define NAME_REG_KEY    @"nameRegKey"
#define SECONDNAME_REG_KEY  @"secondNameRegKey"
#define SEX_REG_KEY @"sexRegKey"
#define PHONE_REG_KEY   @"phoneRegKey"
#define EMAIL_REG_KEY   @"emailRegKey"
#define BIRTH_REG_KEY   @"birthRegKey"

//Person data
#define FIO_KEY     @"fioKey"
#define PHONE_KEY   @"phoneKey"
#define SLOGAN_KEY  @"sloganKey"

//Sign type
#define FIO_SIGN_KEY    @"fioSignKey"
#define PHONE_SIGN_KEY    @"phoneSignKey"
#define SLOGAN_SIGN_KEY    @"sloganSignKey"

@interface MRDataManager : NSObject <ABMultitonProtocol>

@property (nonatomic, weak) NSString *nameValue;
@property (nonatomic, weak) NSString *phoneValue;
@property (nonatomic) BOOL sloganValue;

@property (nonatomic) BOOL nameSignValue;
@property (nonatomic) BOOL phoneSignValue;
@property (nonatomic) BOOL sloganSignValue;

+ (instancetype)sharedInstance;
-(void) setDefaultValue;
-(void) setDataValue:(id)dataValue forKey:(NSString*)key;

-(void) save;

@end
