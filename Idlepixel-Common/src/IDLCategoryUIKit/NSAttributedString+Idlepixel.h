//
//  NSAttributedString+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/NSAttributedString.h>

extern NSString * const NSBaselineOffsetAttributeName;
extern NSString * const NSLinkAttributeName;
extern NSString * const NSSuperscriptAttributeName;

@interface NSAttributedString (IDLAttributes)

+(id)stringWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor;
+(id)stringWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor overrideBold:(NSNumber *)overrideBold;
+(id)stringWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor overrideBold:(NSNumber *)overrideBold overrideKern:(NSNumber *)overrideKern;

- (id)initWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor;
- (id)initWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor overrideBold:(NSNumber *)overrideBold;
- (id)initWithString:(NSString *)str font:(UIFont *)font foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor overrideBold:(NSNumber *)overrideBold overrideKern:(NSNumber *)overrideKern;

#pragma mark Creation of complex attributed strings

+(NSAttributedString *)attributedTextFromString:(NSString *)sourceString
                                     sourceFont:(UIFont *)sourceFont
                                    sourceColor:(UIColor *)sourceColor
                                   appendString:(NSString *)appendString
                                     appendFont:(UIFont *)appendFont
                                    appendColor:(UIColor *)appendColor;

+(NSAttributedString *)attributedTextFromString:(NSString *)sourceString
                                     sourceFont:(UIFont *)sourceFont
                                    sourceColor:(UIColor *)sourceColor
                                     sourceBold:(NSNumber *)sourceBold
                                     sourceKern:(NSNumber *)sourceKern
                                   appendString:(NSString *)appendString
                                     appendFont:(UIFont *)appendFont
                                    appendColor:(UIColor *)appendColor
                                     appendBold:(NSNumber *)appendBold
                                     appendKern:(NSNumber *)appendKern;

+(NSAttributedString *)attributedTextFromAttributedString:(NSAttributedString *)sourceString
                                             appendString:(NSString *)appendString
                                               appendFont:(UIFont *)appendFont
                                              appendColor:(UIColor *)appendColor;

+(NSAttributedString *)attributedTextFromAttributedString:(NSAttributedString *)sourceString
                                             appendString:(NSString *)appendString
                                               appendFont:(UIFont *)appendFont
                                              appendColor:(UIColor *)appendColor
                                               appendBold:(NSNumber *)appendBold
                                               appendKern:(NSNumber *)appendKern;

+(NSAttributedString *)attributedTextWithFont:(UIFont *)font
                                      strings:(NSArray *)strings
                                       colors:(NSArray *)colors
                                        bolds:(NSArray *)bolds
                                        kerns:(NSArray *)kerns;

+(NSAttributedString *)attributedTextWithFont:(UIFont *)font
                                      strings:(NSArray *)strings
                                       colors:(NSArray *)colors
                                        bolds:(NSArray *)bolds
                                        kerns:(NSArray *)kerns
                               joinedByString:(NSString *)joinedByString;

+(NSAttributedString *)attributedTextWithFonts:(NSArray *)fonts
                                       strings:(NSArray *)strings
                                        colors:(NSArray *)colors
                                         bolds:(NSArray *)bolds
                                         kerns:(NSArray *)kerns;

+(NSAttributedString *)attributedTextWithFonts:(NSArray *)fonts
                                       strings:(NSArray *)strings
                                        colors:(NSArray *)colors
                                         bolds:(NSArray *)bolds
                                         kerns:(NSArray *)kerns
                                joinedByString:(NSString *)joinedByString;

@end

@interface NSDictionary (IDLAttributedString)

-(UIFont *)attributedStringFont;
-(UIColor *)attributedStringBackgroundColor;
-(UIColor *)attributedStringForegroundColor;
-(NSParagraphStyle *)attributedStringParagraphStyle;

-(id)attributedStringLink;

-(CGFloat)attributedStringBaselineOffset;
-(CGFloat)attributedStringKern;
-(NSInteger)attributedStringLigature;
-(NSInteger)attributedStringSuperscript;
-(NSInteger)attributedStringUnderlineStyle;

@end

@interface NSMutableDictionary (IDLAttributedString)

-(void)setAttributedStringFont:(UIFont *)value;
-(void)setAttributedStringBackgroundColor:(UIColor *)value;
-(void)setAttributedStringForegroundColor:(UIColor *)value;
-(void)setAttributedStringParagraphStyle:(NSParagraphStyle *)value;

-(void)setAttributedStringLink:(id)value;

-(void)setAttributedStringBaselineOffset:(CGFloat)value;
-(void)setAttributedStringKern:(CGFloat)value;
-(void)setAttributedStringLigature:(NSInteger)value;
-(void)setAttributedStringSuperscript:(NSInteger)value;
-(void)setAttributedStringUnderlineStyle:(NSInteger)value;

@end