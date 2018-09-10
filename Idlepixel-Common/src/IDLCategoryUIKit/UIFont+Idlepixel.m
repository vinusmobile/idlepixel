//
//  UIFont+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 19/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UIFont+Idlepixel.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation UIFont (IDLFontWithTraits)

+ (UIFont *)fontWithCTFont:(CTFontRef)CTFont
{
    NSString *fontName = (__bridge NSString *)CTFontCopyName(CTFont, kCTFontPostScriptNameKey);
    CGFloat fontSize = CTFontGetSize(CTFont);
    return [UIFont fontWithName:fontName size:fontSize];
}

- (UIFont *)fontWithSymbolicTraits:(CTFontSymbolicTraits)traits
{
    CTFontRef newFontRef = CTFontCreateCopyWithSymbolicTraits((__bridge CTFontRef)self, self.pointSize, NULL, traits, traits);
    return [UIFont fontWithCTFont:newFontRef];
}

- (CTFontRef)CTFont
{
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.fontName, self.pointSize, NULL);
    return font;
}

- (CTFontSymbolicTraits)symbolicTraits
{
    CTFontRef fontRef = (__bridge CTFontRef)self;
    return CTFontGetSymbolicTraits(fontRef);
}

@end

@implementation UIFont (IDLAttributedFont)

#define kUIFontAttributedStringAttributes           @"UIFontAttributedStringAttributes"

-(void)setAttributedStringAttributes:(NSDictionary *)attributedStringAttributes
{
    if (![attributedStringAttributes isKindOfClass:[NSDictionary class]]) {
        attributedStringAttributes = nil;
    }
    objc_setAssociatedObject(self, kUIFontAttributedStringAttributes, attributedStringAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDictionary *)attributedStringAttributes
{
    return objc_getAssociatedObject(self, kUIFontAttributedStringAttributes);
}

@end
