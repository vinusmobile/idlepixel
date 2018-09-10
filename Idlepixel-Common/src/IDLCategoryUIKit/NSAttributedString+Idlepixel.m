//
//  NSAttributedString+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "NSAttributedString+Idlepixel.h"
#import "NSDictionary+Idlepixel.h"
#import "NSMutableDictionary+Idlepixel.h"
#import "UIFont+Idlepixel.h"
#import "NSArray+Idlepixel.h"

NSString * const NSBaselineOffsetAttributeName = @"NSBaselineOffsetAttributeName";
NSString * const NSLinkAttributeName = @"NSLinkAttributeName";
NSString * const NSSuperscriptAttributeName = @"NSSuperscriptAttributeName";

@implementation NSAttributedString (Idlepixel)

+(id)stringWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor
{
    return [[self alloc] initWithString:str font:font foregroundColor:foregroundColor backgroundColor:backgroundColor];
}

+(id)stringWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor overrideBold:(NSNumber *)overrideBold
{
    return [[self alloc] initWithString:str font:font foregroundColor:foregroundColor backgroundColor:backgroundColor overrideBold:overrideBold];
}

+(id)stringWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor overrideBold:(NSNumber *)overrideBold overrideKern:(NSNumber *)overrideKern
{
    return [[self alloc] initWithString:str font:font foregroundColor:foregroundColor backgroundColor:backgroundColor overrideBold:overrideBold overrideKern:overrideKern];
}

- (id)initWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor
{
    return [self initWithString:str font:font foregroundColor:foregroundColor backgroundColor:backgroundColor overrideBold:nil];
}

- (id)initWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor overrideBold:(NSNumber *)overrideBold
{
    return [self initWithString:str font:font foregroundColor:foregroundColor backgroundColor:backgroundColor overrideBold:overrideBold overrideKern:nil];
}

- (id)initWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor overrideBold:(NSNumber *)overrideBold overrideKern:(NSNumber *)overrideKern

{
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    if (overrideBold != nil) {
        UIFont *newFont = nil;
        CTFontSymbolicTraits traits = font.symbolicTraits;
        
        if (overrideBold.boolValue) {
            traits = (traits | kCTFontBoldTrait);
        } else {
            traits = (traits & ~kCTFontBoldTrait);
        }
        
        newFont = [font fontWithSymbolicTraits:traits];
        
        if (newFont != nil) font = newFont;
    }
    
    if (overrideKern != nil) {
        [d setAttributedStringKern:overrideKern.floatValue];
    }
    
    if (str == nil) str = @"";
    
    [d setAttributedStringFont:font];
    [d setAttributedStringForegroundColor:foregroundColor];
    [d setAttributedStringBackgroundColor:backgroundColor];
    return [self initWithString:str attributes:d];
}

#pragma mark Creation of complex attributed strings

+(NSAttributedString *)attributedTextFromString:(NSString *)sourceString
                                     sourceFont:(UIFont *)sourceFont
                                    sourceColor:(UIColor *)sourceColor
                                   appendString:(NSString *)appendString
                                     appendFont:(UIFont *)appendFont
                                    appendColor:(UIColor *)appendColor
{
    return [self attributedTextFromString:sourceString sourceFont:sourceFont sourceColor:sourceColor sourceBold:nil sourceKern:nil appendString:appendString appendFont:appendFont appendColor:appendColor appendBold:nil appendKern:nil];
}

+(NSAttributedString *)attributedTextFromString:(NSString *)sourceString
                                     sourceFont:(UIFont *)sourceFont
                                    sourceColor:(UIColor *)sourceColor
                                     sourceBold:(NSNumber *)sourceBold
                                     sourceKern:(NSNumber *)sourceKern
                                   appendString:(NSString *)appendString
                                     appendFont:(UIFont *)appendFont
                                    appendColor:(UIColor *)appendColor
                                     appendBold:(NSNumber *)appendBold
                                     appendKern:(NSNumber *)appendKern
{
    NSAttributedString *sourceAttributedString = [NSAttributedString stringWithString:sourceString font:sourceFont foregroundColor:sourceColor backgroundColor:nil overrideBold:sourceBold overrideKern:sourceKern];
    
    if (appendFont == nil) appendFont = sourceFont;
    
    return [self attributedTextFromAttributedString:sourceAttributedString appendString:appendString appendFont:appendFont appendColor:appendColor appendBold:appendBold appendKern:appendKern];
}

+(NSAttributedString *)attributedTextFromAttributedString:(NSAttributedString *)sourceString
                                             appendString:(NSString *)appendString
                                               appendFont:(UIFont *)appendFont
                                              appendColor:(UIColor *)appendColor
{
    return [self attributedTextFromAttributedString:sourceString appendString:appendString appendFont:appendFont appendColor:appendColor appendBold:nil appendKern:nil];
}

+(NSAttributedString *)attributedTextFromAttributedString:(NSAttributedString *)sourceString
                                             appendString:(NSString *)appendString
                                               appendFont:(UIFont *)appendFont
                                              appendColor:(UIColor *)appendColor
                                               appendBold:(NSNumber *)appendBold
                                               appendKern:(NSNumber *)appendKern
{
    
    if (appendFont == nil) {
        if (sourceString.length > 0) {
            appendFont = [sourceString attribute:NSFontAttributeName atIndex:(sourceString.length-1) effectiveRange:NULL];
        }
    }
    NSMutableAttributedString *appendAttributedString = [NSMutableAttributedString stringWithString:appendString font:appendFont foregroundColor:appendColor backgroundColor:nil overrideBold:appendBold overrideKern:appendKern];
    
    [appendAttributedString insertAttributedString:sourceString atIndex:0];
    
    return [[NSAttributedString alloc] initWithAttributedString:appendAttributedString];
}

+(NSAttributedString *)attributedTextWithFont:(UIFont *)font
                                      strings:(NSArray *)strings
                                       colors:(NSArray *)colors
                                        bolds:(NSArray *)bolds
                                        kerns:(NSArray *)kerns
{
    return [self attributedTextWithFont:font strings:strings colors:colors bolds:bolds kerns:kerns joinedByString:nil];
}

+(NSAttributedString *)attributedTextWithFont:(UIFont *)font
                                      strings:(NSArray *)strings
                                       colors:(NSArray *)colors
                                        bolds:(NSArray *)bolds
                                        kerns:(NSArray *)kerns
                               joinedByString:(NSString *)joinedByString
{
    return [NSAttributedString attributedTextWithFonts:NSArrayNonNil(1, font) strings:strings colors:colors bolds:bolds kerns:kerns joinedByString:joinedByString];
}

+(NSAttributedString *)attributedTextWithFonts:(NSArray *)fonts
                                       strings:(NSArray *)strings
                                        colors:(NSArray *)colors
                                         bolds:(NSArray *)bolds
                                         kerns:(NSArray *)kerns
{
    return [NSAttributedString attributedTextWithFonts:fonts strings:strings colors:colors bolds:bolds kerns:kerns joinedByString:nil];
}

+(NSAttributedString *)attributedTextWithFonts:(NSArray *)fonts
                                       strings:(NSArray *)strings
                                        colors:(NSArray *)colors
                                         bolds:(NSArray *)bolds
                                         kerns:(NSArray *)kerns
                                joinedByString:(NSString *)joinedByString
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    UIColor *color = nil;
    NSNumber *bold = nil;
    NSNumber *kern = nil;
    
    UIFont *font = nil;
    
    NSString *string = nil;
    
    for (NSUInteger i = 0; i < strings.count; i++) {
        
        string = [strings objectAtIndex:i];
        
        if (fonts.count > i) {
            font = CLASS_OR_DEFAULT([fonts objectAtIndexOrNil:i], font, UIFont);
        }
        
        if (colors.count > i) {
            color = CLASS_OR_DEFAULT([colors objectAtIndexOrNil:i], color, UIColor);
        }
        
        if (bolds.count > i) {
            bold = CLASS_OR_NIL([bolds objectAtIndexOrNil:i], NSNumber);
        }
        
        if (kerns.count > i) {
            kern = CLASS_OR_NIL([kerns objectAtIndexOrNil:i], NSNumber);
        }
        
        if (joinedByString.length > 0 && (i + 1 < strings.count)) {
            string = [string stringByAppendingString:joinedByString];
        }
        
        NSAttributedString *subResult = [NSAttributedString stringWithString:string font:font foregroundColor:color backgroundColor:nil overrideBold:bold overrideKern:kern];
        
        if (subResult != nil) {
            [result appendAttributedString:subResult];
        }
    }
    
    
    return result;
}

@end

@implementation NSDictionary (IDLAttributedString)

-(UIFont *)attributedStringFont
{
    RETURN_IF_CLASS([self objectForKey:NSFontAttributeName], UIFont);
}

-(UIColor *)attributedStringBackgroundColor
{
    RETURN_IF_CLASS([self objectForKey:NSBackgroundColorAttributeName], UIColor);
}

-(UIColor *)attributedStringForegroundColor
{
    RETURN_IF_CLASS([self objectForKey:NSForegroundColorAttributeName], UIColor);
}

-(NSParagraphStyle *)attributedStringParagraphStyle
{
    RETURN_IF_CLASS([self objectForKey:NSParagraphStyleAttributeName], NSParagraphStyle);
}

-(id)attributedStringLink
{
    return [self objectForKey:NSLinkAttributeName];
}

-(CGFloat)attributedStringBaselineOffset
{
    return [self floatForKey:NSBaselineOffsetAttributeName];
}

-(CGFloat)attributedStringKern
{
    return [self floatForKey:NSKernAttributeName];
}

-(NSInteger)attributedStringLigature
{
    return [self integerForKey:NSLigatureAttributeName];
}

-(NSInteger)attributedStringSuperscript
{
    return [self integerForKey:NSSuperscriptAttributeName];
}

-(NSInteger)attributedStringUnderlineStyle
{
    return [self integerForKey:NSUnderlineStyleAttributeName];
}

@end

@implementation NSMutableDictionary (IDLAttributedString)

-(void)setAttributedStringFont:(UIFont *)value
{
    [self setObjectIfNotNil:value forKey:NSFontAttributeName];
}

-(void)setAttributedStringBackgroundColor:(UIColor *)value
{
    [self setObjectIfNotNil:value forKey:NSBackgroundColorAttributeName];
}

-(void)setAttributedStringForegroundColor:(UIColor *)value
{
    [self setObjectIfNotNil:value forKey:NSForegroundColorAttributeName];
}

-(void)setAttributedStringParagraphStyle:(NSParagraphStyle *)value
{
    [self setObjectIfNotNil:value forKey:NSParagraphStyleAttributeName];
}

-(void)setAttributedStringLink:(id)value
{
    [self setObjectIfNotNil:value forKey:NSLinkAttributeName];
}

-(void)setAttributedStringBaselineOffset:(CGFloat)value
{
    [self setFloat:value forKey:NSBaselineOffsetAttributeName];
}

-(void)setAttributedStringKern:(CGFloat)value
{
    [self setFloat:value forKey:NSKernAttributeName];
}

-(void)setAttributedStringLigature:(NSInteger)value
{
    [self setInteger:value forKey:NSLigatureAttributeName];
}

-(void)setAttributedStringSuperscript:(NSInteger)value
{
    [self setInteger:value forKey:NSSuperscriptAttributeName];
}

-(void)setAttributedStringUnderlineStyle:(NSInteger)value
{
    [self setInteger:value forKey:NSUnderlineStyleAttributeName];
}

@end
