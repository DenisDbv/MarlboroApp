//
//  MRDataManager.m
//  MarlboroApp
//
//  Created by DenisDbv on 30.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "MRDataManager.h"

@interface MRDataManager()

@end

@implementation MRDataManager
{
    NSUserDefaults *userDefaults;
}
@synthesize nameRegValue, secondNameRegValue, sexRegValue, phoneRegValue, emailRegValue, birthRegValue;
@synthesize nameValue, phoneValue, sloganValue;
@synthesize nameSignValue, phoneSignValue, sloganSignValue;

+ (instancetype)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

-(id) init
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self setDefaultValue];
    
    return [super init];
}

-(void) setDefaultValue
{
    [userDefaults setValue:@"" forKey:NAME_REG_KEY];
    [userDefaults setValue:@"" forKey:SECONDNAME_REG_KEY];
    [userDefaults setValue:@"" forKey:SEX_REG_KEY];
    [userDefaults setValue:@"" forKey:PHONE_REG_KEY];
    [userDefaults setValue:@"denisdbv@gmail.com" forKey:EMAIL_REG_KEY];
    [userDefaults setValue:@"" forKey:BIRTH_REG_KEY];
    
    [userDefaults setValue:@"" forKey:FIO_KEY];
    [userDefaults setValue:@"" forKey:PHONE_KEY];
    [userDefaults setValue:@"" forKey:SLOGAN_KEY];
    
    [userDefaults setValue:@"" forKey:FIO_SIGN_KEY];
    [userDefaults setValue:@"" forKey:PHONE_SIGN_KEY];
    [userDefaults setValue:@"" forKey:SLOGAN_SIGN_KEY];
}

-(void) setDataValue:(id)dataValue forKey:(NSString*)key
{
    [userDefaults setValue:dataValue forKey:key];
}

-(void) setNameRegValue:(NSString *)nameRegValue {
    [userDefaults setValue:nameRegValue forKey:NAME_REG_KEY];
}
-(NSString*)nameRegValue    {
    return [userDefaults valueForKey:NAME_REG_KEY];
}

-(void) setSecondNameRegValue:(NSString *)secondNameRegValue    {
    [userDefaults setValue:secondNameRegValue forKey:SECONDNAME_REG_KEY];
}
-(NSString*)secondNameRegValue  {
    return [userDefaults valueForKey:SECONDNAME_REG_KEY];
}

-(void) setSexRegValue:(NSString *)sexRegValue  {
    [userDefaults setValue:sexRegValue forKey:SEX_REG_KEY];
}
-(NSString*)sexRegValue {
    return [userDefaults valueForKey:SEX_REG_KEY];
}

-(void) setPhoneRegValue:(NSString *)phoneRegValue  {
    [userDefaults setValue:phoneRegValue forKey:PHONE_REG_KEY];
}
-(NSString*)phoneRegValue   {
    return [userDefaults valueForKey:PHONE_REG_KEY];
}

-(void) setEmailRegValue:(NSString *)emailRegValue  {
    if(emailRegValue.length == 0)
        emailRegValue = @"denisdbv@gmail.com";
    [userDefaults setValue:emailRegValue forKey:EMAIL_REG_KEY];
}
-(NSString*) emailRegValue  {
    return [userDefaults valueForKey:EMAIL_REG_KEY];
}

-(void) setBirthRegValue:(NSString *)birthRegValue  {
    [userDefaults setValue:birthRegValue forKey:BIRTH_REG_KEY];
}
-(NSString*) birthRegValue  {
    return [userDefaults valueForKey:BIRTH_REG_KEY];
}

-(void) setNameValue:(NSString *)nameValue  {
    [userDefaults setValue:nameValue forKey:FIO_KEY];
}
-(NSString*) nameValue  {
    return [userDefaults valueForKey:FIO_KEY];
}

-(void) setPhoneValue:(NSString *)phoneValue    {
    [userDefaults setValue:phoneValue forKey:PHONE_KEY];
}
-(NSString*) phoneValue {
    return [userDefaults valueForKey:PHONE_KEY];
}

-(void) setSloganValue:(BOOL)sloganValue    {
    [userDefaults setValue:[NSNumber numberWithBool:sloganValue] forKey:SLOGAN_KEY];
}
-(BOOL) sloganValue {
    return [[userDefaults valueForKey:SLOGAN_KEY] boolValue];
}

-(void) setNameSignValue:(BOOL)nameSignValue    {
    [userDefaults setValue:[NSNumber numberWithBool:nameSignValue] forKey:FIO_SIGN_KEY];
}
-(BOOL)nameSignValue    {
    return [[userDefaults valueForKey:FIO_SIGN_KEY] boolValue];
}

-(void) setPhoneSignValue:(BOOL)phoneSignValue  {
    [userDefaults setValue:[NSNumber numberWithBool:phoneSignValue] forKey:PHONE_SIGN_KEY];
}
-(BOOL) phoneSignValue  {
    return [[userDefaults valueForKey:PHONE_SIGN_KEY] boolValue];
}

-(void) setSloganSignValue:(BOOL)sloganSignValue    {
    [userDefaults setValue:[NSNumber numberWithBool:sloganSignValue] forKey:SLOGAN_SIGN_KEY];
}
-(BOOL)sloganSignValue  {
    return [[userDefaults valueForKey:SLOGAN_SIGN_KEY] boolValue];
}

-(void) save
{
    [userDefaults synchronize];
}

@end
