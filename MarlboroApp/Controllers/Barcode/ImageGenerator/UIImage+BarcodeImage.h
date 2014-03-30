//
//  UIImage+BarcodeImage.h
//  Barcode
//
//  Created by Admin on 3/29/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BarcodeImage)

// type: 1-6
+(UIImage*) barcodeWithText:(NSString*)text name:(NSString*)name phone:(NSString*)phone mode:(NSString*)mode type:(int)type;

@end
