//
//  UIImage+LogoImage.m
//  LogoImage
//
//  Created by Admin on 3/30/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "UIImage+LogoImage.h"

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
static BOOL showBorder = NO;

@implementation UIImage (LogoImage)

+(UIImage*) logoWithName:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode fontType:(int)fontType type:(int)type
{
    // check params
    if (name.length == 0 && phone.length == 0 && mode.length == 0) return nil;
    if (type < 1 || type > 3) return nil;
    if (fontType < 1 || fontType > 3) return nil;
    
    NSArray *nameArr;
    if (name.length != 0){
        nameArr = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (nameArr.count < 3) return nil;
        NSString* name1 = nameArr[0];
        NSString* name2 = nameArr[1];
        NSString* name3 = nameArr[2];
        if (name1.length == 0 || name2.length == 0 || name3.length == 0) return nil;
    }
    
    UIImage* mask;
    if (type == 1) mask = [UIImage logo1WithName:name phone:phone mode:mode fontType:fontType];
    if (type == 2) mask = [UIImage logo2WithName:name phone:phone mode:mode fontType:fontType];
    if (type == 3) mask = [UIImage logo3WithName:name phone:phone mode:mode fontType:fontType];
    
    if (mask == nil) return nil;
    
    // mask image
    UIImage* texture = [UIImage imageNamed:@"texture.png"];
    UIImage* scaledTexture = [UIImage imageWithImage:texture scaledToSize:mask.size];
    UIImage* image = [UIImage maskImage:scaledTexture withMask:mask];
    
    return image;
}

+(float)widthOfText:(NSString*)text withFont:(UIFont*)font
{
    float textWidth = 0;
    for (int index = 0; index < [text length]; index++)
    {
        NSRange range = {index, 1};
        NSString* letter = [text substringWithRange:range];
        CGSize charSize = [letter sizeWithFont:font];
        textWidth += charSize.width;
    }
    return textWidth;
}

+ (UIImage*) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask
{
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference
                                               scale:mask.scale
                                         orientation:mask.imageOrientation];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

+(void) drawStringAtContext:(CGContextRef)context
                      string:(NSString*)text
                        font:(UIFont*)font
                     atAngle:(float) angle
                  withRadius:(float) radius
                     reverse:(BOOL)reverse
{
    float textWidth = [UIImage widthOfText:text withFont:font];
    
    float textAngle = textWidth / radius;
    
    if (reverse){
        angle += textAngle / 2;
    }else{
        angle -= textAngle / 2;
    }
    
//    float x1 = radius * cos(angle);
//    float y1 = radius * sin(angle);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, x1, y1);
//    float x2 = radius * cos(angle+textAngle);
//    float y2 = radius * sin(angle+textAngle);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, x2, y2);
//    CGContextStrokePath(context);
    
    for (int index = 0; index < [text length]; index++)
    {
        NSRange range = {index, 1};
        NSString* letter = [text substringWithRange:range];
        CGSize charSize = [letter sizeWithFont:font];
        
        float letterAngle = charSize.width / radius;
        
        if (reverse){
            angle -= letterAngle/2;
        }else{
            angle += letterAngle/2;
        }
        
        float x = radius * cos(angle);
        float y = radius * sin(angle);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, x, y);

        if (reverse){
            CGContextRotateCTM(context, angle-M_PI_2);
            CGPoint pt = CGPointMake(-charSize.width/2, 0);
            //CGContextStrokeRect(context, (CGRect){.origin = pt, .size = charSize});
            [letter drawAtPoint:pt withFont:font];
            angle -= letterAngle/2;
        }else{
            CGContextRotateCTM(context, angle+M_PI_2);
            CGPoint pt = CGPointMake(-charSize.width/2, -charSize.height);
            //CGContextStrokeRect(context, (CGRect){.origin = pt, .size = charSize});
            [letter drawAtPoint:pt withFont:font];
            angle += letterAngle/2;
        }
        
        CGContextRestoreGState(context);
    }
}

+(UIImage*) logo1WithName:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode fontType:(int)fontType
{
    UIFont* font;
    if (fontType == 1) font = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:34];
    if (fontType == 2) font = [UIFont fontWithName:@"FuturaDemiC" size:34];
    if (fontType == 3) font = [UIFont fontWithName:@"Roboto-Thin" size:34];
    
    UIFont* bigFont;
    if (fontType == 1) bigFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:90];
    if (fontType == 2) bigFont = [UIFont fontWithName:@"FuturaDemiC" size:90];
    if (fontType == 3) bigFont = [UIFont fontWithName:@"Roboto-Thin" size:90];
    
    UIFont* modeFont;
    if (fontType == 1) modeFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:20];
    if (fontType == 2) modeFont = [UIFont fontWithName:@"FuturaDemiC" size:20];
    if (fontType == 3) modeFont = [UIFont fontWithName:@"Roboto-Thin" size:20];
    
    float radius1;
    float radius2;
    if (IS_OS_7_OR_LATER){
        if (fontType == 1) { radius1 = 215; radius2 = 221; }
        if (fontType == 2) { radius1 = 215; radius2 = 215; }
        if (fontType == 3) { radius1 = 215; radius2 = 214; }
    }else{
        if (fontType == 1) { radius1 = 209; radius2 = 222; }
        if (fontType == 2) { radius1 = 212; radius2 = 216; }
        if (fontType == 3) { radius1 = 215; radius2 = 214; }
    }

    
    
    NSString* fio;
    NSString* letter1;
    NSString* letter2;
    NSString* letter3;
    if (name.length != 0){
        NSArray* arr = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        fio = [[arr[0] stringByAppendingString:@" "] stringByAppendingString:arr[1]];
        fio = [@"\u2022 " stringByAppendingString:fio];
        fio = [fio stringByAppendingString:@" \u2022"];
        letter1 = [arr[0] substringToIndex:1];
        letter2 = [arr[1] substringToIndex:1];
        letter3 = [arr[2] substringToIndex:1];
    }
    
    UIImage* logoBack = [UIImage imageNamed:@"logo1.png"];
    
    // create image
    CGSize imageSize = logoBack.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    [[UIColor blackColor] set];
    if (showBorder) CGContextStrokeRect(context, (CGRect){.size = imageSize});
    
    
    // draw logo back
    [logoBack drawInRect:(CGRect){.size = imageSize}];
    
    float ofs = 110;
    float ofsy = 0;
    if (!IS_OS_7_OR_LATER && fontType == 1) ofsy = 20;
    
    // draw M
    CGSize letterSize = [@"M" sizeWithFont:bigFont];
    CGPoint pos = CGPointMake(imageSize.width/2-letterSize.width/2, imageSize.height/2-letterSize.height/2-ofs+ofsy);
    [@"M" drawAtPoint:pos withFont:bigFont];
    
    
    // draw letters
    if (name.length != 0){
        CGSize letter1Size = [letter1 sizeWithFont:bigFont];
        CGPoint pos1 = CGPointMake(imageSize.width/2-letter1Size.width/2-ofs, imageSize.height/2-letter1Size.height/2+ofsy);
        [letter1 drawAtPoint:pos1 withFont:bigFont];
        
        CGSize letter2Size = [letter2 sizeWithFont:bigFont];
        CGPoint pos2 = CGPointMake(imageSize.width/2-letter2Size.width/2, imageSize.height/2-letter2Size.height/2+ofs+ofsy);
        [letter2 drawAtPoint:pos2 withFont:bigFont];
        
        CGSize letter3Size = [letter3 sizeWithFont:bigFont];
        CGPoint pos3 = CGPointMake(imageSize.width/2-letter3Size.width/2+ofs, imageSize.height/2-letter3Size.height/2+ofsy);
        [letter3 drawAtPoint:pos3 withFont:bigFont];
        
        /*CGSize letter2Size = [letter2 sizeWithFont:bigFont];
        CGPoint pos2 = CGPointMake(imageSize.width/2-letter2Size.width/2+ofs, imageSize.height/2-letter2Size.height/2+ofsy);
        [letter2 drawAtPoint:pos2 withFont:bigFont];
        
        CGSize letter3Size = [letter3 sizeWithFont:bigFont];
        CGPoint pos3 = CGPointMake(imageSize.width/2-letter3Size.width/2, imageSize.height/2-letter3Size.height/2+ofs+ofsy);
        [letter3 drawAtPoint:pos3 withFont:bigFont];*/
    }
    
    // draw mode
    if (mode.length != 0){
        CGSize modeSize = [mode sizeWithFont:modeFont];
        CGPoint modePos = CGPointMake(imageSize.width/2-modeSize.width/2, imageSize.height/2-modeSize.height/2+180);
        [mode drawAtPoint:modePos withFont:modeFont];
    }
    
    // translate center
    CGContextTranslateCTM(context, imageSize.width/2, imageSize.height/2);
    
    // draw text
    if (name.length != 0){
        [UIImage drawStringAtContext:context string:fio font:font atAngle:-90*(M_PI/180) withRadius:radius1 reverse:NO];
    }
    
    // draw phone
    if (phone.length != 0){
        [UIImage drawStringAtContext:context string:phone font:font atAngle:90*(M_PI/180) withRadius:radius2 reverse:YES];
    }
    
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*) logo2WithName:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode fontType:(int)fontType
{
    UIFont* font;
    if (fontType == 1) font = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:34];
    if (fontType == 2) font = [UIFont fontWithName:@"FuturaDemiC" size:34];
    if (fontType == 3) font = [UIFont fontWithName:@"Roboto-Thin" size:34];
    
    UIFont* bigFont;
    if (fontType == 1) bigFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:90];
    if (fontType == 2) bigFont = [UIFont fontWithName:@"FuturaDemiC" size:90];
    if (fontType == 3) bigFont = [UIFont fontWithName:@"Roboto-Thin" size:90];
    
    UIFont* modeFont;
    if (fontType == 1) modeFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:20];
    if (fontType == 2) modeFont = [UIFont fontWithName:@"FuturaDemiC" size:20];
    if (fontType == 3) modeFont = [UIFont fontWithName:@"Roboto-Thin" size:20];
    
    float radius1;
    float radius2;
    if (IS_OS_7_OR_LATER){
        if (fontType == 1) { radius1 = 252; radius2 = 256; }
        if (fontType == 2) { radius1 = 252; radius2 = 252; }
        if (fontType == 3) { radius1 = 250; radius2 = 250; }
    }else{
        if (fontType == 1) { radius1 = 246; radius2 = 258; }
        if (fontType == 2) { radius1 = 249; radius2 = 252; }
        if (fontType == 3) { radius1 = 250; radius2 = 249; }
    }
    
    
    NSString* fio;
    NSString* letter1;
    NSString* letter2;
    NSString* letter3;
    if (name.length != 0){
        NSArray* arr = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        fio = [[arr[0] stringByAppendingString:@" "] stringByAppendingString:arr[1]];
        letter1 = [arr[0] substringToIndex:1];
        letter2 = [arr[1] substringToIndex:1];
        letter3 = [arr[2] substringToIndex:1];
    }
    
    NSString* star = @" \u2605 ";
    float starWidth = [UIImage widthOfText:star withFont:font];
    
    
    UIImage* logoBack = [UIImage imageNamed:@"logo2.png"];
    CGSize logoSize = logoBack.size;
    
    // create image
    float extra = 40;
    CGSize imageSize = CGSizeMake(logoSize.width+extra*2, logoSize.height+extra*2);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    [[UIColor blackColor] set];
    if (showBorder) CGContextStrokeRect(context, (CGRect){.size = imageSize});
    
    
    // draw logo back
    CGPoint logoPos = CGPointMake((imageSize.width-logoSize.width)/2, (imageSize.height - logoSize.height)/2);
    [logoBack drawInRect:(CGRect){.origin = logoPos, .size = logoSize}];
    
    float ofs = 120;
    float ofsy = 0;
    if (!IS_OS_7_OR_LATER && fontType == 1) ofsy = 20;
    if (!IS_OS_7_OR_LATER && fontType == 2) ofsy = 5;
    
    [[UIColor whiteColor] set];
    
    // draw M
    CGSize letterSize = [@"M" sizeWithFont:bigFont];
    CGPoint pos = CGPointMake(imageSize.width/2-letterSize.width/2, imageSize.height/2-letterSize.height/2-ofs+ofsy);
    [@"M" drawAtPoint:pos withFont:bigFont];
    
    
    // draw letters
    if (name.length != 0){
        CGSize letter1Size = [letter1 sizeWithFont:bigFont];
        CGPoint pos1 = CGPointMake(imageSize.width/2-letter1Size.width/2-ofs, imageSize.height/2-letter1Size.height/2+ofsy);
        [letter1 drawAtPoint:pos1 withFont:bigFont];
        
        CGSize letter2Size = [letter2 sizeWithFont:bigFont];
        CGPoint pos2 = CGPointMake(imageSize.width/2-letter2Size.width/2, imageSize.height/2-letter2Size.height/2+ofs+ofsy);
        [letter2 drawAtPoint:pos2 withFont:bigFont];
        
        CGSize letter3Size = [letter3 sizeWithFont:bigFont];
        CGPoint pos3 = CGPointMake(imageSize.width/2-letter3Size.width/2+ofs, imageSize.height/2-letter3Size.height/2+ofsy);
        [letter3 drawAtPoint:pos3 withFont:bigFont];
        
        /*CGSize letter2Size = [letter2 sizeWithFont:bigFont];
        CGPoint pos2 = CGPointMake(imageSize.width/2-letter2Size.width/2+ofs, imageSize.height/2-letter2Size.height/2+ofsy);
        [letter2 drawAtPoint:pos2 withFont:bigFont];
        
        CGSize letter3Size = [letter3 sizeWithFont:bigFont];
        CGPoint pos3 = CGPointMake(imageSize.width/2-letter3Size.width/2, imageSize.height/2-letter3Size.height/2+ofs+ofsy);
        [letter3 drawAtPoint:pos3 withFont:bigFont];*/
    }
    
    [[UIColor blackColor] set];
    
    // translate center
    CGContextTranslateCTM(context, imageSize.width/2, imageSize.height/2);

    
    if (fio.length != 0 && phone.length != 0 && mode.length != 0){
        float fioWidth = [UIImage widthOfText:fio withFont:font];
        float phoneWidth = [UIImage widthOfText:phone withFont:font];
        float modeWidth = [UIImage widthOfText:mode withFont:font];
        
        float radius = 250;
        float totalWidth = fioWidth + phoneWidth + modeWidth + 3*starWidth;
        float perimeter = radius*2*M_PI;
        
        float delta = (perimeter - totalWidth)/6;
        float star1Ofs = modeWidth/2+delta+starWidth/2;
        float fioOfs = star1Ofs + starWidth/2+delta+fioWidth/2;
        float star2Ofs = fioOfs + fioWidth/2+delta+starWidth/2;
        float phoneOfs = star2Ofs + starWidth/2+delta + phoneWidth/2;
        float star3Ofs = phoneOfs + phoneWidth/2+delta+starWidth/2;
        
        float modeAngle = 90*M_PI/180;
        float star1Angle = star1Ofs/radius + modeAngle;
        float fioAngle = fioOfs/radius + modeAngle;
        float star2Angle = star2Ofs/radius + modeAngle;
        float phoneAngle = phoneOfs/radius + modeAngle;
        float star3Angle = star3Ofs/radius + modeAngle;
        
        [UIImage drawStringAtContext:context string:mode font:font atAngle:modeAngle withRadius:radius2 reverse:YES];
        [UIImage drawStringAtContext:context string:star font:font atAngle:star1Angle withRadius:radius1 reverse:NO];
        [UIImage drawStringAtContext:context string:fio font:font atAngle:fioAngle withRadius:radius1 reverse:NO];
        [UIImage drawStringAtContext:context string:star font:font atAngle:star2Angle withRadius:radius1 reverse:NO];
        [UIImage drawStringAtContext:context string:phone font:font atAngle:phoneAngle withRadius:radius1 reverse:NO];
        [UIImage drawStringAtContext:context string:star font:font atAngle:star3Angle withRadius:radius1 reverse:NO];
    }
    // only fio
    else if (fio.length != 0 && phone.length == 0 && mode.length == 0){
        NSString* text = [[star stringByAppendingString:fio] stringByAppendingString:star];
        [UIImage drawStringAtContext:context string:text font:font atAngle:-90*(M_PI/180) withRadius:radius1 reverse:NO];
    }
    // only phone
    else if (fio.length == 0 && phone.length != 0 && mode.length == 0){
        NSString* text = [[star stringByAppendingString:phone] stringByAppendingString:star];
        [UIImage drawStringAtContext:context string:text font:font atAngle:-90*(M_PI/180) withRadius:radius1 reverse:NO];
    }
    // only mode
    else if (fio.length == 0 && phone.length == 0 && mode.length != 0){
        NSString* text = [[star stringByAppendingString:mode] stringByAppendingString:star];
        [UIImage drawStringAtContext:context string:text font:font atAngle:90*(M_PI/180) withRadius:radius2 reverse:YES];
    }
    // two sections
    else{
        NSString* top = (fio.length == 0) ? phone : fio;
        NSString* bottom = (mode.length == 0) ? phone : mode;

        float topWidth = [UIImage widthOfText:top withFont:font];
        float bottomWidth = [UIImage widthOfText:bottom withFont:font];
        
        float radius = 250;
        float totalWidth = topWidth + bottomWidth + 2*starWidth;
        float perimeter = radius*2*M_PI;
        
        float delta = (perimeter - totalWidth)/4;
        
        float topAngle = -90*M_PI/180;
        float bottomAngle = 90*M_PI/180;
        float star1Angle = (bottomWidth/2+delta+starWidth/2)/radius + bottomAngle;
        float star2Angle = -(bottomWidth/2+delta+starWidth/2)/radius + bottomAngle;
        
        [UIImage drawStringAtContext:context string:bottom font:font atAngle:bottomAngle withRadius:radius2 reverse:YES];
        [UIImage drawStringAtContext:context string:top font:font atAngle:topAngle withRadius:radius1 reverse:NO];
        [UIImage drawStringAtContext:context string:star font:font atAngle:star1Angle withRadius:radius1 reverse:NO];
        [UIImage drawStringAtContext:context string:star font:font atAngle:star2Angle withRadius:radius1 reverse:NO];
    }
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*) logo3WithName:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode fontType:(int)fontType
{
    UIFont* font;
    if (fontType == 1) font = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:34];
    if (fontType == 2) font = [UIFont fontWithName:@"FuturaDemiC" size:34];
    if (fontType == 3) font = [UIFont fontWithName:@"Roboto-Thin" size:34];
    
    UIFont* bigFont;
    if (fontType == 1) bigFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:90];
    if (fontType == 2) bigFont = [UIFont fontWithName:@"FuturaDemiC" size:90];
    if (fontType == 3) bigFont = [UIFont fontWithName:@"Roboto-Thin" size:90];
    
    UIFont* modeFont;
    if (fontType == 1) modeFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:20];
    if (fontType == 2) modeFont = [UIFont fontWithName:@"FuturaDemiC" size:20];
    if (fontType == 3) modeFont = [UIFont fontWithName:@"Roboto-Thin" size:20];
    
    UIFont* phoneFont;
    if (fontType == 1) phoneFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:35];
    if (fontType == 2) phoneFont = [UIFont fontWithName:@"FuturaDemiC" size:35];
    if (fontType == 3) phoneFont = [UIFont fontWithName:@"Roboto-Thin" size:35];

    
    float radius1;
    float radius2;
    if (IS_OS_7_OR_LATER){
        if (fontType == 1) { radius1 = 240-22-2; radius2 = 242-22+3; }
        if (fontType == 2) { radius1 = 240-24; radius2 = 240-24; }
        if (fontType == 3) { radius1 = 237-24; radius2 = 237-24; }
    }else{
        if (fontType == 1) { radius1 = 234-22-1; radius2 = 242-22+3; }
        if (fontType == 2) { radius1 = 237-22-2; radius2 = 239-22; }
        if (fontType == 3) { radius1 = 237-22; radius2 = 236-22; }
    }
    
    NSString* fio;
    NSString* letters;
    if (name.length != 0){
        NSArray* arr = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        fio = [[arr[0] stringByAppendingString:@" "] stringByAppendingString:arr[1]];
        NSString* letter1 = [arr[0] substringToIndex:1];
        NSString* letter2 = [arr[1] substringToIndex:1];
        NSString* letter3 = [arr[2] substringToIndex:1];
        letters = [[[[letter1 stringByAppendingString:@" "]stringByAppendingString:letter2]stringByAppendingString:@" "]stringByAppendingString:letter3];
    }
    
    NSString* dot = @"\u2022";
    float dotWidth = [dot sizeWithFont:font].width;
    NSString* space = @" ";
    float spaceWidth = [space sizeWithFont:font].width;

    
    UIImage* logoBack = [UIImage imageNamed:@"logo3.png"];
    CGSize logoSize = logoBack.size;
    
    // create image
    float extra = 0;
    CGSize imageSize = CGSizeMake(logoSize.width+extra*2, logoSize.height+extra*2);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    [[UIColor blackColor] set];
    if (showBorder) CGContextStrokeRect(context, (CGRect){.size = imageSize});
    
    
    // draw logo back
    CGPoint logoPos = CGPointMake((imageSize.width-logoSize.width)/2, (imageSize.height - logoSize.height)/2+55);
    [logoBack drawInRect:(CGRect){.origin = logoPos, .size = logoSize}];
    
    
    float ofsy = 0;
    if (!IS_OS_7_OR_LATER && fontType == 1) ofsy = 20;
    if (!IS_OS_7_OR_LATER && fontType == 2) ofsy = 8;
    if (fontType == 3) ofsy = 5;
    
    
    [[UIColor whiteColor] set];

    // draw letters
    if (name.length != 0){
        CGSize letterSize = [letters sizeWithFont:bigFont];
        CGPoint pos = CGPointMake(imageSize.width/2-letterSize.width/2, imageSize.height/2-letterSize.height+72+ofsy);
        [letters drawAtPoint:pos withFont:bigFont];
    }
    
    
    [[UIColor blackColor] set];
    
    
    // draw phone
    if (phone.length != 0){
        CGSize phoneSize = [phone sizeWithFont:phoneFont];
        CGPoint pos = CGPointMake(imageSize.width/2-phoneSize.width/2, imageSize.height/2-phoneSize.height/2-60);
        [phone drawAtPoint:pos withFont:phoneFont];
    }
    
    
    // draw M
    CGSize letterSize = [@"M" sizeWithFont:bigFont];
    CGPoint pos = CGPointMake(imageSize.width/2-letterSize.width/2, imageSize.height/2-letterSize.height-100+ofsy);
    [@"M" drawAtPoint:pos withFont:bigFont];
    
    
    // draw mode
    if (mode.length != 0){
        CGSize modeSize = [mode sizeWithFont:modeFont];
        CGPoint modePos = CGPointMake(imageSize.width/2-modeSize.width/2, imageSize.height/2+80);
        [mode drawAtPoint:modePos withFont:modeFont];
    }
    
    
    // translate center
    CGContextTranslateCTM(context, imageSize.width/2, imageSize.height/2);
    
    // draw text
    if (fio.length != 0){
        [UIImage drawStringAtContext:context string:fio font:font atAngle:90*(M_PI/180) withRadius:radius2 reverse:YES];
    }
    
    // draw phone
    if (phone.length != 0){
        [UIImage drawStringAtContext:context string:phone font:font atAngle:-90*(M_PI/180) withRadius:radius1 reverse:NO];
    }
    
    
    // draw dots
    if (fio.length != 0 && phone.length != 0){
        float nameWidth = [UIImage widthOfText:fio withFont:font];
        float phoneWidth = [UIImage  widthOfText:phone withFont:font];
        
        float radius = radius1;
        float perimeter = radius*2*M_PI;
        float emptyWidth = (perimeter - (nameWidth+phoneWidth))/2;
        if (emptyWidth > 0){
            
            NSString* dotsText = space;
            float dotsWidth = spaceWidth;
            while (dotsWidth + dotWidth + spaceWidth <= emptyWidth) {
                dotsWidth += dotWidth + spaceWidth;
                dotsText = [[dotsText stringByAppendingString:dot] stringByAppendingString:space];
            }
            
            if (dotsText.length > 2){
                float dot1Angle = 90*M_PI/180 + (nameWidth/2+emptyWidth/2)/radius;
                float dot2Angle = 90*M_PI/180 - (nameWidth/2+emptyWidth/2)/radius;
                
                [UIImage drawStringAtContext:context string:dotsText font:font atAngle:dot1Angle withRadius:radius1 reverse:NO];
                [UIImage drawStringAtContext:context string:dotsText font:font atAngle:dot2Angle withRadius:radius1 reverse:NO];
            }
        }
    }
    
    if (fio.length != 0 && phone.length == 0){
        float nameWidth = [UIImage widthOfText:fio withFont:font];
        
        float radius = radius1;
        float perimeter = radius*2*M_PI;
        float emptyWidth = perimeter - nameWidth;
        if (emptyWidth > 0){
            
            NSString* dotsText = space;
            float dotsWidth = spaceWidth;
            while (dotsWidth + dotWidth + spaceWidth <= emptyWidth) {
                dotsWidth += dotWidth + spaceWidth;
                dotsText = [[dotsText stringByAppendingString:dot] stringByAppendingString:space];
            }
            
            if (dotsText.length > 2){
                [UIImage drawStringAtContext:context string:dotsText font:font atAngle:-90*(M_PI/180) withRadius:radius1 reverse:NO];
            }
        }
    }
    
    if (fio.length == 0 && phone.length != 0){
        float phoneWidth = [UIImage  widthOfText:phone withFont:font];
        
        float radius = radius2;
        float perimeter = radius*2*M_PI;
        float emptyWidth = perimeter - phoneWidth;
        if (emptyWidth > 0){
            
            NSString* dotsText = space;
            float dotsWidth = spaceWidth;
            while (dotsWidth + dotWidth + spaceWidth <= emptyWidth) {
                dotsWidth += dotWidth + spaceWidth;
                dotsText = [[dotsText stringByAppendingString:dot] stringByAppendingString:space];
            }
            
            if (dotsText.length > 2){
                [UIImage drawStringAtContext:context string:dotsText font:font atAngle:90*(M_PI/180) withRadius:radius2 reverse:YES];
            }
        }
    }
    
    if (fio.length == 0 && phone.length == 0){
        float radius = radius2;
        float emptyWidth = radius*2*M_PI;
        if (emptyWidth > 0){
            
            NSString* dotsText = space;
            float dotsWidth = spaceWidth;
            while (dotsWidth + dotWidth + spaceWidth <= emptyWidth) {
                dotsWidth += dotWidth + spaceWidth;
                dotsText = [[dotsText stringByAppendingString:dot] stringByAppendingString:space];
            }

            [UIImage drawStringAtContext:context string:dotsText font:font atAngle:-90*(M_PI/180) withRadius:radius1 reverse:NO];
            
            if (fontType == 1)
                [UIImage drawStringAtContext:context string:dot font:font atAngle:90*(M_PI/180) withRadius:radius2 reverse:YES];
        }
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

