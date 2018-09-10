//
//  NSString+DisplayMetrics.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (IDLDisplayMetrics)

- (CGFloat)multilineHeightWithFont:(UIFont *)font forWidth:(CGFloat)width; // Uses UILineBreakModeWordWrap
- (CGFloat)multilineHeightWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

