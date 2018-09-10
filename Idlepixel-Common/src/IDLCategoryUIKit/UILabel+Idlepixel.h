//
//  UILabel+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UILabel (IDLDisplayMetrics)

// height

-(CGFloat)desiredHeight;
-(CGFloat)desiredHeightWithWidth:(CGFloat)width;

-(CGFloat)desiredHeightForString:(NSString *)string;
-(CGFloat)desiredHeightWithWidth:(CGFloat)width forString:(NSString *)string;

-(CGFloat)desiredHeightForAttributedString:(NSAttributedString *)string;
-(CGFloat)desiredHeightWithWidth:(CGFloat)width forAttributedString:(NSAttributedString *)string;

// width

-(CGFloat)desiredWidth;
-(CGFloat)desiredWidthForString:(NSString *)string;
-(CGFloat)desiredWidthForAttributedString:(NSAttributedString *)string;

// size

-(CGSize)desiredSize;
-(CGSize)desiredSizeWithWidth:(CGFloat)width;

-(CGSize)desiredSizeForString:(NSString *)string;
-(CGSize)desiredSizeWithWidth:(CGFloat)width forString:(NSString *)string;

-(CGSize)desiredSizeForAttributedString:(NSAttributedString *)string;
-(CGSize)desiredSizeWithWidth:(CGFloat)width forAttributedString:(NSAttributedString *)string;

@end

@interface UILabel (IDLMultilineResize)

-(void)adjustFontToFitMultiline;
-(void)adjustFontToFitMultiline:(CGFloat)maximumFontSize;

@end

@interface UILabel (IDLTextAttributes)

-(void)applyTextAttributes:(NSDictionary *)textAttributes;

@end

@interface UILabel (IDLAttributedString)

@property (readonly) NSMutableParagraphStyle *paragraphStyle;
@property (readonly) NSDictionary *attributedStringAttributes;

@end

@interface UILabel (IDLLabelKerning)

-(void)setText:(NSString *)text withKerning:(CGFloat)kerning;

@end
