//
//  UIImage+BarcodeImage.m
//  Barcode
//
//  Created by Admin on 3/29/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "UIImage+BarcodeImage.h"
#import "ZXingObjC.h"
#import "NSString+EngToRu.h"

@implementation UIImage (BarcodeImage)

+(UIImage*) barcodeWithText:(NSString*)text name:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode type:(int)type
{
    // check params
    if(text.length == 0) return nil;
    //if (name.length == 0 && phone.length == 0) return nil;
    if (type < 1 || type > 6) return nil;
    //if (mode.length == 0) return nil;
    
    text = [text convertFromRuToEng];
    
    if (name == nil) name = @"";
    if (phone == nil) phone = @"";
    if (mode == nil) mode = @"";
    
    UIImage* mask;
    if (type == 1) mask = [UIImage barcode1WithText:text name:name phone:phone mode:mode];
    if (type == 2) mask = [UIImage barcode2WithText:text name:name phone:phone mode:mode];
    if (type == 3) mask = [UIImage barcode3WithText:text name:name phone:phone mode:mode];
    if (type == 4) mask = [UIImage barcode4WithText:text name:name phone:phone mode:mode];
    if (type == 5) mask = [UIImage barcode5WithText:text name:name phone:phone mode:mode];
    if (type == 6) mask = [UIImage barcode6WithText:text name:name phone:phone mode:mode];
    
    if (mask == nil) return nil;
    
    // mask image
    UIImage* texture = [UIImage imageNamed:@"texture.png"];
    UIImage* scaledTexture = [UIImage imageWithImage:texture scaledToSize:mask.size];
    UIImage* image = [UIImage maskImage:scaledTexture withMask:mask];
    
    return image;
}

+(UIImage*) barcodeImage:(NSString*)text size:(CGSize)size
{
    BOOL isRetina = [UIScreen mainScreen].scale == 2.0;
    int w = size.width;
    int h = size.height;
    
    NSError* error = nil;
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:text
                                  format:kBarcodeFormatCode128
                                   width:w
                                  height:h
                                   error:&error];
    if (result) {
        NSArray* arr = result.enclosingRectangle;
        //NSLog(@"%@ %@ %@ %@", arr[0], arr[1], arr[2], arr[3]);
        CGRect rect = CGRectMake([arr[0] integerValue], [arr[1] integerValue],
                                 [arr[2] integerValue], [arr[3] integerValue]);
        
        ZXImage* zxImage = [ZXImage imageWithMatrix:result];
        
        CGImageRef croppedRef = CGImageCreateWithImageInRect(zxImage.cgimage, rect);
        UIImage* image = [UIImage imageWithCGImage:croppedRef];
        UIImage* img = isRetina ? [UIImage imageWithImage:image scaledToSize:rect.size] : image;
        CGImageRelease(croppedRef);
        
        return img;
    }else{
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
}

+(UIImage*) retinaImage:(UIImage *)image
{
    CGSize newSize = CGSizeMake(image.size.width/2, image.size.height/2);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

+(UIImage*) barcode1WithText:(NSString*)text name:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode
{
    CGSize barSize = CGSizeMake(420, 200);
    
    // create barcode
    UIImage* barcode = [UIImage barcodeImage:text size:barSize];
    if (barcode == nil) return nil;
    barSize = barcode.size;
    
    // split name
    NSArray *array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* line1 = array.count > 0 ? array[0] : @"";
    NSString* line2 = array.count > 1 ? array[1] : @"";
    
    // fonts
    UIFont* nameFont = [UIFont fontWithName:@"Roboto-Thin" size:26];
    UIFont* phoneFont = [UIFont fontWithName:@"Roboto-Thin" size:26];
    UIFont* madeFont = [UIFont fontWithName:@"Roboto-Thin" size:20];
    
    // text sizes
    CGSize phoneSize = phone.length == 0 ? CGSizeMake(0, 0) : [phone sizeWithFont:phoneFont];
    CGSize line1Size = line1.length == 0 ? CGSizeMake(0, 0) : [line1 sizeWithFont:nameFont];
    CGSize line2Size = line2.length == 0 ? CGSizeMake(0, 0) : [line2 sizeWithFont:nameFont];
    CGSize madeSize = [mode sizeWithFont:madeFont];
    
    
    // create image
    CGSize imageSize = CGSizeMake(barSize.width, barSize.height+phoneSize.height+madeSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    // draw barcode
    [barcode drawInRect:(CGRect){.size = barSize}];
    
    
    // draw name
    if (line1.length > 0 || line2.length > 0)
    {
        CGSize sz = CGSizeMake(MAX(line1Size.width, line2Size.width), line1Size.height+line2Size.height);
        
        // erase area
        CGPoint pos = CGPointMake((barSize.width-sz.width)/2, (barSize.height-sz.height)/2);
        [[UIColor whiteColor] set];
        CGContextFillRect(context, (CGRect){.origin = pos, .size = sz});
        
        // draw text
        [[UIColor blackColor] set];
        
        if (line1.length > 0){
            [line1 drawInRect:CGRectMake(pos.x, pos.y, sz.width, sz.height)
                     withFont:nameFont
                lineBreakMode:UILineBreakModeClip
                    alignment:UITextAlignmentCenter];
        }
        
        if (line2.length > 0){
            [line2 drawInRect:CGRectMake(pos.x, pos.y+line1Size.height, sz.width, sz.height)
                     withFont:nameFont
                lineBreakMode:UILineBreakModeClip
                    alignment:UITextAlignmentCenter];
        }
    }
    
    // draw phone
    [[UIColor blackColor] set];
    if (phone.length > 0){
        CGPoint pos = CGPointMake((barSize.width-phoneSize.width)/2, barSize.height);
        [phone drawAtPoint:pos withFont:phoneFont];
    }
    
    // draw madeIn
    CGPoint pos = CGPointMake((barSize.width-madeSize.width)/2, barSize.height+phoneSize.height);
    [mode drawAtPoint:pos withFont:madeFont];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage*) barcode2WithText:(NSString*)text name:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode
{
    CGSize barSize = CGSizeMake(420, 180);
    
    // create barcode
    UIImage* barcode = [UIImage barcodeImage:text size:barSize];
    if (barcode == nil) return nil;
    barSize = barcode.size;
    
    // split name
    NSArray *array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* line1 = array.count > 0 ? array[0] : @"";
    NSString* line2 = array.count > 1 ? array[1] : @"";
    
    // fonts
    UIFont* nameFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:30];
    UIFont* phoneFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:18];
    UIFont* madeFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:18];
    
    // text sizes
    CGSize phoneSize = phone.length == 0 ? CGSizeMake(0, 0) : [phone sizeWithFont:phoneFont];
    CGSize line1Size = line1.length == 0 ? CGSizeMake(0, 0) : [line1 sizeWithFont:nameFont];
    CGSize line2Size = line2.length == 0 ? CGSizeMake(0, 0) : [line2 sizeWithFont:nameFont];
    CGSize madeSize = [mode sizeWithFont:madeFont];
    
    
    // create image
    CGSize imageSize = CGSizeMake(barSize.width, barSize.height+madeSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    // draw barcode
    [barcode drawInRect:(CGRect){.origin.y = madeSize.height, .size = barSize}];
    
    
    // draw name
    if (line1.length > 0)
    {
        CGPoint pos = CGPointMake(0, imageSize.height-line2Size.height-line1Size.height);
        // erase area
        [[UIColor whiteColor] set];
        CGContextFillRect(context, (CGRect){.origin = pos, .size = line1Size});
        
        // draw text
        [[UIColor blackColor] set];
        [line1 drawAtPoint:pos withFont:nameFont];
    }
    
    if (line2.length > 0)
    {
        CGPoint pos = CGPointMake(0, imageSize.height-line2Size.height);
        // erase area
        [[UIColor whiteColor] set];
        CGContextFillRect(context, (CGRect){.origin = pos, .size = line2Size});
        
        // draw text
        [[UIColor blackColor] set];
        [line2 drawAtPoint:pos withFont:nameFont];
    }
    
    // draw phone
    [[UIColor blackColor] set];
    if (phone.length > 0){
        [phone drawAtPoint:CGPointMake(0, 0) withFont:phoneFont];
    }
    
    // draw madeIn
    [mode drawAtPoint:CGPointMake(imageSize.width - madeSize.width, 0) withFont:madeFont];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage*) barcode3WithText:(NSString*)text name:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode
{
    CGSize barSize = CGSizeMake(420, 160);
    
    // create barcode
    UIImage* barcode = [UIImage barcodeImage:text size:barSize];
    if (barcode == nil) return nil;
    barSize = barcode.size;
    
    // split name
    NSArray *array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* line1 = array.count > 0 ? array[0] : @"";
    NSString* line2 = array.count > 1 ? array[1] : @"";
    
    // fonts
    UIFont* nameFont = [UIFont fontWithName:@"FuturaDemiC" size:30];
    UIFont* phoneFont = [UIFont fontWithName:@"FuturaDemiC" size:30];
    UIFont* madeFont = [UIFont fontWithName:@"FuturaDemiC" size:16];
    
    // text sizes
    CGSize phoneSize = phone.length == 0 ? CGSizeMake(0, 0) : [phone sizeWithFont:phoneFont];
    CGSize line1Size = line1.length == 0 ? CGSizeMake(0, 0) : [line1 sizeWithFont:nameFont];
    CGSize line2Size = line2.length == 0 ? CGSizeMake(0, 0) : [line2 sizeWithFont:nameFont];
    CGSize madeSize = [mode sizeWithFont:madeFont];
    
    
    // create image
    CGSize imageSize = CGSizeMake(barSize.width, barSize.height+madeSize.height+line2Size.height+phoneSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    // draw barcode
    [barcode drawInRect:(CGRect){.origin.y = madeSize.height, .size = barSize}];
    
    
    // draw name
    if (line1.length > 0)
    {
        CGPoint pos = CGPointMake((imageSize.width-line1Size.width)/2, barSize.height+madeSize.height-line1Size.height);
        
        [[UIColor whiteColor] set];
        CGContextFillRect(context, (CGRect){.origin = pos, .size = line1Size});
        
        [[UIColor blackColor] set];
        [line1 drawAtPoint:pos withFont:nameFont];
    }
    
    if (line2.length > 0)
    {
        CGPoint pos = CGPointMake((imageSize.width-line2Size.width)/2, barSize.height+madeSize.height);
        [[UIColor blackColor] set];
        [line2 drawAtPoint:pos withFont:nameFont];
    }
    
    // draw phone
    if (phone.length > 0){
        CGPoint pos = CGPointMake((imageSize.width-phoneSize.width)/2, imageSize.height-phoneSize.height);
        [[UIColor blackColor] set];
        [phone drawAtPoint:pos withFont:phoneFont];
    }
    
    // draw madeIn
    [mode drawAtPoint:CGPointMake((imageSize.width-madeSize.width)/2, 0) withFont:madeFont];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage*) barcode4WithText:(NSString*)text name:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode
{
    CGSize barSize = CGSizeMake(420, 160);
    
    // create barcode
    UIImage* barcode = [UIImage barcodeImage:text size:barSize];
    if (barcode == nil) return nil;
    barSize = barcode.size;
    
    // split name
    NSArray *array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* line1 = array.count > 0 ? array[0] : @"";
    NSString* line2 = array.count > 1 ? array[1] : @"";
    
    // fonts
    UIFont* nameFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:24];
    UIFont* phoneFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:24];
    UIFont* madeFont = [UIFont fontWithName:@"PFAgoraSlabPro-Black" size:16];
    
    // text sizes
    CGSize phoneSize = phone.length == 0 ? CGSizeMake(0, 0) : [phone sizeWithFont:phoneFont];
    CGSize line1Size = line1.length == 0 ? CGSizeMake(0, 0) : [line1 sizeWithFont:nameFont];
    CGSize line2Size = line2.length == 0 ? CGSizeMake(0, 0) : [line2 sizeWithFont:nameFont];
    CGSize madeSize = [mode sizeWithFont:madeFont];
    
    
    // create image
    CGSize imageSize = CGSizeMake(barSize.width, barSize.height+madeSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    // draw barcode
    [barcode drawInRect:(CGRect){.size = barSize}];
    
    
    float commonHeight = line1Size.height + line2Size.height+phoneSize.height;
    float ofs = (barSize.height - commonHeight)/2;
    
    // draw name
    if (line1.length > 0)
    {
        CGPoint pos = CGPointMake((imageSize.width-line1Size.width)/2, ofs);
        
        [[UIColor whiteColor] set];
        CGContextFillRect(context, (CGRect){.origin = pos, .size = line1Size});
        
        [[UIColor blackColor] set];
        [line1 drawAtPoint:pos withFont:nameFont];
    }
    
    if (line2.length > 0)
    {
        CGPoint pos = CGPointMake((imageSize.width-line2Size.width)/2, ofs+line1Size.height);
        
        [[UIColor whiteColor] set];
        CGContextFillRect(context, (CGRect){.origin = pos, .size = line2Size});
        
        [[UIColor blackColor] set];
        [line2 drawAtPoint:pos withFont:nameFont];
    }
    
    // draw phone
    if (phone.length > 0)
    {
        CGPoint pos = CGPointMake((imageSize.width-phoneSize.width)/2, ofs+line1Size.height+line2Size.height);
        
        [[UIColor whiteColor] set];
        CGContextFillRect(context, (CGRect){.origin = pos, .size = phoneSize});
        
        [[UIColor blackColor] set];
        [phone drawAtPoint:pos withFont:phoneFont];
    }
    
    // draw madeIn
    [mode drawAtPoint:CGPointMake((imageSize.width-madeSize.width)/2, barSize.height) withFont:madeFont];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage*) barcode5WithText:(NSString*)text name:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode
{
    CGSize barSize = CGSizeMake(420, 140);
    
    // create barcode
    UIImage* barcode = [UIImage barcodeImage:text size:barSize];
    if (barcode == nil) return nil;
    barSize = barcode.size;
    
    // split name
    NSArray *array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* line1 = array.count > 0 ? array[0] : @"";
    NSString* line2 = array.count > 1 ? array[1] : @"";
    
    // fonts
    UIFont* nameFont = [UIFont fontWithName:@"FuturaDemiC" size:30];
    UIFont* phoneFont = [UIFont fontWithName:@"FuturaDemiC" size:30];
    UIFont* madeFont = [UIFont fontWithName:@"FuturaDemiC" size:16];
    
    // text sizes
    CGSize phoneSize = phone.length == 0 ? CGSizeMake(0, 0) : [phone sizeWithFont:phoneFont];
    CGSize line1Size = line1.length == 0 ? CGSizeMake(0, 0) : [line1 sizeWithFont:nameFont];
    CGSize line2Size = line2.length == 0 ? CGSizeMake(0, 0) : [line2 sizeWithFont:nameFont];
    CGSize madeSize = [mode sizeWithFont:madeFont];
    
    
    // create image
    CGSize imageSize = CGSizeMake(barSize.width, barSize.height+madeSize.height+line1Size.height+line2Size.height+phoneSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    // draw barcode
    [barcode drawInRect:(CGRect){.origin.y = line1Size.height+line2Size.height, .size = barSize}];
    
    [[UIColor blackColor] set];
    
    // draw name
    if (line1.length > 0)
    {
        CGPoint pos = CGPointMake((imageSize.width-line1Size.width)/2, 0);
        [line1 drawAtPoint:pos withFont:nameFont];
    }
    
    if (line2.length > 0)
    {
        CGPoint pos = CGPointMake((imageSize.width-line2Size.width)/2, line1Size.height);
        [line2 drawAtPoint:pos withFont:nameFont];
    }
    
    // draw phone
    if (phone.length > 0){
        CGPoint pos = CGPointMake((imageSize.width-phoneSize.width)/2, imageSize.height-phoneSize.height-madeSize.height);
        [phone drawAtPoint:pos withFont:phoneFont];
    }
    
    // draw madeIn
    [mode drawAtPoint:CGPointMake((imageSize.width-madeSize.width)/2, imageSize.height-madeSize.height) withFont:madeFont];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage*) barcode6WithText:(NSString*)text name:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode
{
    CGSize barSize = CGSizeMake(400, 160);
    
    // create barcode
    UIImage* barcode = [UIImage barcodeImage:text size:barSize];
    if (barcode == nil) return nil;
    barSize = barcode.size;
    
    // split name
    NSArray *array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* line1 = array.count > 0 ? array[0] : @"";
    NSString* line2 = array.count > 1 ? array[1] : @"";
    
    // fonts
    UIFont* nameFont = [UIFont fontWithName:@"FuturaDemiC" size:26];
    UIFont* phoneFont = [UIFont fontWithName:@"FuturaDemiC" size:26];
    UIFont* madeFont = [UIFont fontWithName:@"FuturaDemiC" size:16];
    
    // text sizes
    CGSize phoneSize = phone.length == 0 ? CGSizeMake(0, 0) : [phone sizeWithFont:phoneFont];
    CGSize line1Size = line1.length == 0 ? CGSizeMake(0, 0) : [line1 sizeWithFont:nameFont];
    CGSize line2Size = line2.length == 0 ? CGSizeMake(0, 0) : [line2 sizeWithFont:nameFont];
    CGSize madeSize = [mode sizeWithFont:madeFont];
    
    
    // create image
    CGSize imageSize = CGSizeMake(barSize.width+madeSize.height, barSize.height+line1Size.height+line2Size.height+phoneSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, (CGRect){.size = imageSize});
    
    // draw barcode
    [barcode drawInRect:(CGRect){.origin.y = line1Size.height+line2Size.height, .size = barSize}];
    
    [[UIColor blackColor] set];
    
    // draw name
    if (line1.length > 0)
    {
        CGPoint pos = CGPointMake(0, 0);
        [line1 drawAtPoint:pos withFont:nameFont];
    }
    
    if (line2.length > 0)
    {
        CGPoint pos = CGPointMake(0, line1Size.height);
        [line2 drawAtPoint:pos withFont:nameFont];
    }
    
    // draw phone
    if (phone.length > 0){
        CGPoint pos = CGPointMake(barSize.width-phoneSize.width, imageSize.height-phoneSize.height);
        [phone drawAtPoint:pos withFont:phoneFont];
    }
    
    // draw madeIn
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, barSize.width+madeSize.height/2, line1Size.height+line2Size.height+barSize.height/2);
    CGContextRotateCTM(context, M_PI/2);
    [mode drawAtPoint:CGPointMake(-madeSize.width/2, -madeSize.height/2) withFont:madeFont];
    CGContextRestoreGState(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
