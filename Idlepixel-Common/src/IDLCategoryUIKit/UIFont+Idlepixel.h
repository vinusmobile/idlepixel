//
//  UIFont+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 19/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (IDLFontWithTraits)

+ (UIFont *)fontWithCTFont:(CTFontRef)CTFont;

- (CTFontRef)CTFont;
- (UIFont *)fontWithSymbolicTraits:(CTFontSymbolicTraits)traits;
- (CTFontSymbolicTraits)symbolicTraits;

@end

@interface UIFont (IDLAttributedFont)

@property (strong) NSDictionary *attributedStringAttributes;

@end
