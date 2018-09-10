//
//  UILabel+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UILabel+Idlepixel.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#import "NSString+DisplayMetrics.h"
#import "NSAttributedString+Idlepixel.h"

#import "UIView+Idlepixel.h"

@implementation UILabel (IDLDisplayMetrics)

-(CGSize)desiredSizeWithWidth:(CGFloat)width forContent:(NSObject *)content
{
    if (content == nil) {
        if (self.attributedText != nil) {
            content = self.attributedText;
        } else {
            content = self.text;
        }
    }
    
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    if ([content isKindOfClass:[NSString class]]) {
        
        NSString *contentString = (NSString *)content;
        size.height = [contentString multilineHeightWithFont:self.font forWidth:width lineBreakMode:NSLineBreakByWordWrapping];
        
    } else if ([content isKindOfClass:[NSAttributedString class]]) {
        
        NSAttributedString *contentString = (NSAttributedString *)content;
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)contentString);
        CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [contentString length]), NULL, size, NULL);
        CFRelease(framesetter);
        
        size = CGSizeMake(width, fitSize.height);
        
    } else {
        size.height = 0.0f;
    }
    
    return size;
}

-(CGFloat)desiredWidthForContent:(NSObject *)content
{
    if (content == nil) {
        if (self.attributedText != nil) {
            content = self.attributedText;
        } else {
            content = self.text;
        }
    }
    
    CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    if ([content isKindOfClass:[NSString class]]) {
        
        NSString *contentString = (NSString *)content;
        size = [contentString sizeWithFont:self.font constrainedToSize:size lineBreakMode: self.lineBreakMode];
        
        
    } else if ([content isKindOfClass:[NSAttributedString class]]) {
        
        NSAttributedString *contentString = (NSAttributedString *)content;
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)contentString);
        size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [contentString length]), NULL, size, NULL);
        CFRelease(framesetter);
        
        size.width = size.width + 1.5f;
        
    } else {
        size.height = 0.0f;
        size.width = 0.0f;
    }
    
    return size.width;
}

#pragma mark - Height

-(CGFloat)desiredHeight
{
    return [self desiredHeightWithWidth:self.frame.size.width];
}

-(CGFloat)desiredHeightWithWidth:(CGFloat)width
{
    return [self desiredSizeWithWidth:width forContent:nil].height;
}

#pragma mark Height : NSString


-(CGFloat)desiredHeightForString:(NSString *)string
{
    return [self desiredHeightWithWidth:self.frame.size.width forString:string];
}

-(CGFloat)desiredHeightWithWidth:(CGFloat)width forString:(NSString *)string
{
    return [self desiredSizeWithWidth:width forString:string].height;
}

#pragma mark Height : NSAttributedString


-(CGFloat)desiredHeightForAttributedString:(NSAttributedString *)string
{
    return [self desiredHeightWithWidth:self.frame.size.width forAttributedString:string];
}

-(CGFloat)desiredHeightWithWidth:(CGFloat)width forAttributedString:(NSAttributedString *)string
{
    return [self desiredSizeWithWidth:width forAttributedString:string].height;
}

#pragma mark - Width : NSString

-(CGFloat)desiredWidth
{
    return [self desiredWidthForContent:nil];
}

-(CGFloat)desiredWidthForString:(NSString *)string
{
    return [self desiredWidthForContent:string];
}

-(CGFloat)desiredWidthForAttributedString:(NSAttributedString *)string
{
    return [self desiredWidthForContent:string];
}

#pragma mark - Size

-(CGSize)desiredSize
{
    return [self desiredSizeWithWidth:self.frame.size.width];
}

-(CGSize)desiredSizeWithWidth:(CGFloat)width
{
    return [self desiredSizeWithWidth:width forContent:nil];
}

#pragma mark Size : NSString

-(CGSize)desiredSizeForString:(NSString *)string
{
    return [self desiredSizeWithWidth:self.frame.size.width forString:nil];
}

-(CGSize)desiredSizeWithWidth:(CGFloat)width forString:(NSString *)string
{
    return [self desiredSizeWithWidth:width forContent:string];
}

#pragma mark Size : NSAttributedString

-(CGSize)desiredSizeForAttributedString:(NSAttributedString *)string
{
    return [self desiredSizeWithWidth:self.frame.size.width forAttributedString:string];
}

-(CGSize)desiredSizeWithWidth:(CGFloat)width forAttributedString:(NSAttributedString *)string
{
    return [self desiredSizeWithWidth:width forContent:string];
}

#pragma mark -

@end

@implementation UILabel (IDLMultilineResize)

-(void)adjustFontToFitMultiline
{
    [self adjustFontToFitMultiline:self.font.pointSize];
}


-(void)adjustFontToFitMultiline:(CGFloat)maximumFontSize
{
    NSString *stringTmp = self.text;
    UIFont *font = self.font;
    
    CGFloat i;
    CGFloat pointSizeMin = self.minimumScaleFactor*font.pointSize;
    
    for(i = maximumFontSize; i > pointSizeMin; i=i-0.25f) {
        font = [font fontWithSize:i];
        CGSize constraintSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
        CGSize labelSize = [stringTmp sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        if(labelSize.height <= self.frame.size.height) {
            break;
        }
    }
    self.font = font;
}

@end

@implementation UILabel (IDLTextAttributes)

-(void)applyTextAttributes:(NSDictionary *)textAttributes
{
    if (textAttributes) {
        UIFont *font = [textAttributes objectForKey:UITextAttributeFont];
        if (font) self.font = font;
        UIColor *color = [textAttributes objectForKey:UITextAttributeTextColor];
        if (color) self.textColor = color;
        color = [textAttributes objectForKey:UITextAttributeTextShadowColor];
        if (color) self.shadowColor = color;
        NSValue *offset = [textAttributes objectForKey:UITextAttributeTextShadowOffset];
        if (offset) self.shadowOffset = offset.CGSizeValue;
    }
}

@end

@implementation UILabel (IDLAttributedString)

-(NSMutableParagraphStyle *)paragraphStyle
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = self.textAlignment;
    style.lineBreakMode = self.lineBreakMode;
    return style;
}

-(NSDictionary *)attributedStringAttributes
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setAttributedStringForegroundColor:self.textColor];
    [dictionary setAttributedStringFont:self.font];
    [dictionary setAttributedStringBaselineOffset:self.baselineAdjustment];
    [dictionary setAttributedStringParagraphStyle:self.paragraphStyle];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end

@implementation UILabel (IDLLabelKerning)

-(void)setText:(NSString *)text withKerning:(CGFloat)kerning
{
    if (kerning != 0.0f && text.length > 0) {
        NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:self.attributedStringAttributes];
        [d setAttributedStringKern:kerning];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:d];
        self.attributedText = attributedString;
    } else if (text.length > 0) {
        self.text = text;
    } else {
        self.text = nil;
    }
}

@end

