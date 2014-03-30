//
//  NSString+EngToRu.m
//  MarlboroApp
//
//  Created by DenisDbv on 30.03.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "NSString+EngToRu.h"

@implementation NSString (EngToRu)

-(NSString*) convertFromRuToEng
{
    NSDictionary *dict = @{@"А":@"A",
                           @"Б":@"B",
                           @"В":@"V",
                           @"Г":@"G",
                           @"Д":@"D",
                           @"Е":@"E",
                           @"Ё":@"E",
                           @"Ж":@"Z",
                           @"З":@"Z",
                           @"И":@"I",
                           @"К":@"K",
                           @"Л":@"L",
                           @"М":@"M",
                           @"Н":@"N",
                           @"О":@"O",
                           @"П":@"P",
                           @"Р":@"R",
                           @"С":@"S",
                           @"Т":@"T",
                           @"У":@"U",
                           @"Ф":@"F",
                           @"Х":@"H",
                           @"Ц":@"C",
                           @"Ч":@"CH",
                           @"Ш":@"SH",
                           @"Щ":@"SH",
                           @"И":@"I",
                           @"Й":@"I",
                           @"Ь":@"",
                           @"Ъ":@"",
                           @"Э":@"E",
                           @"Ю":@"YU",
                           @"Я":@"YA"};
    
    __block NSMutableString *resultString = [NSMutableString string];
    [self enumerateCharactersWithBlock:^(unichar a, NSUInteger index, BOOL *ret) {
        NSString* s = [NSString stringWithCharacters:&a length:1];
        
        NSString *appStr = [dict valueForKey:s];
        if(appStr == nil) appStr = s;
        
        [resultString appendString:appStr];
    }];
    
    NSLog(@"Convert ru to eng: %@", resultString);
    return resultString;
}

-(void)enumerateCharactersWithBlock:(void (^)(unichar, NSUInteger, BOOL *))block
{
    const NSInteger bufferSize = 16;
    const NSInteger length = [self length];
    unichar buffer[bufferSize];
    NSInteger bufferLoops = (length - 1) / bufferSize + 1;
    BOOL stop = NO;
    for (int i = 0; i < bufferLoops; i++) {
        NSInteger bufferOffset = i * bufferSize;
        NSInteger charsInBuffer = MIN(length - bufferOffset, bufferSize);
        [self getCharacters:buffer range:NSMakeRange(bufferOffset, charsInBuffer)];
        for (int j = 0; j < charsInBuffer; j++) {
            block(buffer[j], j + bufferOffset, &stop);
            if (stop) {
                return;
            }
        }
    }
}

@end
