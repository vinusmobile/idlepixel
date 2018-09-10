//
//  UIColor+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UIColor+Idlepixel.h"
#import "NSCharacterSet+Idlepixel.h"
#import "NSString+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

#import "IDLLoggingMacros.h"

#define kColorLeadStringHTML        @"#"
#define kColorLeadStringHex         @"0x"
//
#define kColorLeadStringCSSRGB      @"rgb"
#define kColorLeadStringCSSRGBA     @"rgba"
#define kColorLeadStringCSSHSL      @"hsl"
#define kColorLeadStringCSSHSLA     @"hsla"

@implementation UIColor (IDLData)

+ (UIColor*) colorWithData:(NSData *)colorData
{
    return UIColorFromNSData(colorData);
}

-(NSData *)data
{
    return NSDataFromUIColor(self);
}

@end

@implementation UIColor (IDLWebRGB)

+ (UIColor*) colorWithHTMLString:(NSString *)htmlString
{
    UIColor *color = nil;
    if (htmlString.length > 0) {
        htmlString = htmlString.lowercaseString;
        NSString *colorString = nil;
        if ([htmlString hasPrefix:kColorLeadStringHTML]) {
            colorString = [htmlString stringByRemovingPrefix:kColorLeadStringHTML];
            if (colorString.length == 3) {
                colorString = [colorString stringByRepeatingCharacters:2];
            }
        } else if ([htmlString hasPrefix:kColorLeadStringHex]) {
            colorString = [htmlString stringByRemovingPrefix:kColorLeadStringHex];
        }
        
        if (colorString.length == 7) {
            colorString = [colorString substringToIndex:6];
        } else if (colorString.length > 8) {
            colorString = [colorString substringToIndex:8];
        }
        if (colorString.length == 6 || colorString.length == 8) {
            NSScanner *scanner = [NSScanner scannerWithString:colorString];
            uint colorInteger = 0;
            BOOL result = [scanner scanHexInt:&colorInteger];
            if (result) {
                if (colorString.length == 6) {
                    color = [UIColor colorWithRGB:colorInteger];
                } else {
                    color = [UIColor colorWithRGBA:colorInteger];
                }
            }
        }
    }
    return color;
}

+ (UIColor*) colorWithCSSString:(NSString *)htmlString
{
    //IDLLogContext(@"CONVERTING '%@'",htmlString);
    UIColor *color = nil;
    NSRange range = [htmlString rangeOfSequenceBeginningWithString:@"(" finishingString:@")"];
    if (range.location != NSNotFound && range.length > 2) {
        NSString *leadString = [htmlString substringToIndex:range.location];
        range.location = range.location + 1;
        range.length = range.length - 2;
        NSString *colorString = [htmlString substringWithRange:range];
        
        BOOL hsl = NO;
        if ([leadString isEqualToCaseInsensitiveString:kColorLeadStringCSSHSL] || [leadString isEqualToCaseInsensitiveString:kColorLeadStringCSSHSLA]) {
            hsl = YES;
        }
        
        NSArray *componentStrings = [colorString componentsSeparatedByString:@","];
        
        if (componentStrings.count == 3 || componentStrings.count == 4) {
            CGFloat components[4] = {  0.0, 0.0, 0.0, 1.0 };
            NSString *componentString;
            CGFloat component;
            for (NSInteger i = 0; i < componentStrings.count; i++) {
                componentString = [componentStrings objectAtIndex:i];
                if ([componentString containsString:@"%"]) {
                    component = [componentString percentValue];
                } else if ([componentString containsString:@"."]) {
                    component = [componentString floatValue];
                } else if (i == 0 && hsl) {
                    component = [componentString floatValue] / 360.0f;
                } else if (!hsl && i < 3) {
                    component = [componentString floatValue] / 255.0f;
                } else {
                    component = [componentString floatValue];
                }
                components[i] = component;
                //IDLLogContext(@"string='%@', float='%f'",componentString,component);
            }
            if (hsl) {
                color = [UIColor colorWithHue:components[0] saturation:components[1] lightness:components[2] alpha:components[3]];
            } else {
                color = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
            }
        }
    }
    return color;
}

+ (UIColor*) colorWithString:(NSString *)colorString
{
    //IDLLogContext(@"CONVERTING '%@'",colorString);
    colorString = colorString.lowercaseString;
    UIColor *color = nil;
    NSCharacterSet *hexCharacterSet = [NSCharacterSet hexadecimalCharacterSet];
    if (colorString.length > 0) {
        //
        NSString *leadString = nil;
        NSString *valueString = nil;
        //
        // check if the string is a traditional hex string
        NSRange range = [colorString rangeOfString:kColorLeadStringHTML];
        if (range.location != NSNotFound) {
            leadString = kColorLeadStringHTML;
        } else {
            range = [colorString rangeOfString:kColorLeadStringHex];
            if (range.location != NSNotFound) {
                leadString = kColorLeadStringHex;
            }
        }
        if (range.location != NSNotFound) {
            range.location = NSRangeGetMax(range);
            range.length = colorString.length-range.location;
            range = [colorString rangeOfCharactersFromSet:hexCharacterSet options:NSCaseInsensitiveSearch range:range];
            if (range.location != NSNotFound && range.length > 0) {
                valueString = [colorString substringWithRange:range];
            }
        }
        if (leadString.length > 0 && valueString.length > 0) {
            return [self colorWithHTMLString:[leadString stringByAppendingString:valueString]];
        }
        //
        // check if the string is a newfangled CSS2.1 or CSS3 formatted colour
        leadString = nil, valueString = nil;
        range = [colorString rangeOfString:kColorLeadStringCSSRGBA];
        if (range.location != NSNotFound) {
            leadString = kColorLeadStringCSSRGBA;
        }
        if (range.location == NSNotFound) {
            range = [colorString rangeOfString:kColorLeadStringCSSRGB];
            if (range.location != NSNotFound) {
                leadString = kColorLeadStringCSSRGB;
            }
        }
        if (range.location == NSNotFound) {
            range = [colorString rangeOfString:kColorLeadStringCSSHSLA];
            if (range.location != NSNotFound) {
                leadString = kColorLeadStringCSSHSLA;
            }
        }
        if (range.location == NSNotFound) {
            range = [colorString rangeOfString:kColorLeadStringCSSHSL];
            if (range.location != NSNotFound) {
                leadString = kColorLeadStringCSSHSL;
            }
        }
        
        if (range.location != NSNotFound) {
            range.location = NSRangeGetMax(range);
            range.length = colorString.length-range.location;
            range = [colorString rangeOfSequenceBeginningWithString:@"(" finishingString:@")" options:NSCaseInsensitiveSearch range:range];
            if (range.location != NSNotFound) {
                valueString = [colorString substringWithRange:range];
            }
        }
        if (leadString.length > 0 && valueString.length > 0) {
            return [self colorWithCSSString:[leadString stringByAppendingString:valueString]];
        }
    }
    return color;
}

- (NSString*) htmlString
{
    return [NSString stringWithFormat:@"%@%06x", kColorLeadStringHTML, (uint)self.rgbValue];
}

- (NSString*) hexString
{
    return [NSString stringWithFormat:@"%@%06x", kColorLeadStringHex, (uint)self.rgbValue];
}

@end

@implementation UIColor (IDLHexRGB)

+ (UIColor*) colorWithRGB: (NSUInteger) rgb
{
    return [self colorWithHexRed:((rgb & 0xFF0000) >> 16) green:((rgb & 0xFF00) >> 8) blue:((rgb & 0xFF))];
}

+ (UIColor*) colorWithRGBA: (NSUInteger) rgba
{
    return [self colorWithHexRed:((rgba & 0xFF000000) >> 24) green:((rgba & 0xFF0000) >> 16) blue:((rgba & 0xFF00) >> 8) alpha:((rgba & 0xFF))];
}

+ (UIColor*) colorWithARGB: (NSUInteger) argb
{
    return [self colorWithHexRed:((argb & 0xFF0000) >> 16) green:((argb & 0xFF00) >> 8) blue:(argb & 0xFF) alpha:((argb & 0xFF000000) >> 24)];
}

+ (UIColor*) colorWithHexGray:(NSUInteger)gray
{
    return [self colorWithHexGray:gray alpha:255];
}

+ (UIColor*) colorWithHexGray:(NSUInteger)gray alpha:(NSUInteger)alpha
{
    return [self colorWithHexRed:gray green:gray blue:gray alpha:alpha];
}

+ (UIColor*) colorWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue
{
    return [self colorWithHexRed:red green:green blue:blue alpha:255];
}

+ (UIColor*) colorWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(NSUInteger)alpha
{
    return [UIColor colorWithRed:((float)(MIN(red, 255))/255.0f)
                           green:((float)(MIN(green, 255))/255.0f)
                            blue:((float)(MIN(blue, 255))/255.0f)
                           alpha:((float)(MIN(alpha, 255))/255.0f)];
}

- (CGColorSpaceModel) colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL) isRGB
{
    return (([self colorSpaceModel] == kCGColorSpaceModelRGB) ||
            ([self colorSpaceModel] == kCGColorSpaceModelMonochrome));
}

- (BOOL) isMonochrome
{
    return (([self colorSpaceModel] == kCGColorSpaceModelMonochrome));
}

- (CGFloat) red
{
    if (!self.isRGB) return 0.0f;
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat) green
{
    if (!self.isRGB) return 0.0f;
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.isMonochrome) {
        return c[0];
    } else {
        return c[1];
    }
}

- (CGFloat) blue
{
    if (!self.isRGB) return 0.0f;
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.isMonochrome) {
        return c[0];
    } else {
        return c[2];
    }
}

- (CGFloat) alpha
{
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[CGColorGetNumberOfComponents(self.CGColor)-1];
}

- (NSUInteger) rgbValue
{
    if (!self.isRGB) return 0;
    NSUInteger rgb = 0x000000;
    rgb += ((NSUInteger)(self.red * 255)) << 16;
    rgb += ((NSUInteger)(self.green * 255)) << 8;
    rgb += ((NSUInteger)(self.blue * 255));
    return rgb;
}

- (NSUInteger) argbValue
{
    if (!self.isRGB) return 0;
    NSUInteger rgb = 0x00000000;
    rgb += ((NSUInteger)(self.alpha * 255)) << 24;
    rgb += ((NSUInteger)(self.red * 255)) << 16;
    rgb += ((NSUInteger)(self.green * 255)) << 8;
    rgb += ((NSUInteger)(self.blue * 255));
    return rgb;
}

- (NSUInteger) rgbaValue
{
    if (!self.isRGB) return 0;
    NSUInteger rgb = 0x00000000;
    rgb += ((NSUInteger)(self.red * 255)) << 24;
    rgb += ((NSUInteger)(self.green * 255)) << 16;
    rgb += ((NSUInteger)(self.blue * 255)) << 8;
    rgb += ((NSUInteger)(self.alpha * 255));
    return rgb;
}

@end

@implementation UIColor (IDLGrayScale)

- (CGFloat) gray
{
    if (!self.isRGB) return 0.0f;
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    if (self.isMonochrome) {
        return c[0];
    } else {
        
        CGFloat average = 0.0f;
        for (NSUInteger i = 0; i < 3; i++) {
            average += c[i];
        }
        return average/3.0f;
    }
}

- (CGFloat) grayWeightedLight
{
    if (!self.isRGB) return 0.0f;
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    if (self.isMonochrome) {
        return c[0];
    } else {
        
        CGFloat lightest = 0.0f;
        
        CGFloat average = 0.0f;
        for (NSUInteger i = 0; i < 3; i++) {
            average += c[i];
            lightest = MAX(c[i], lightest);
        }
        return (average/3.0f + lightest) / 2.0f;
    }
}

- (CGFloat) grayWeightedDark
{
    if (!self.isRGB) return 0.0f;
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    if (self.isMonochrome) {
        return c[0];
    } else {
        
        CGFloat darkest = 1.0f;
        
        CGFloat average = 0.0f;
        for (NSUInteger i = 0; i < 3; i++) {
            average += c[i];
            darkest = MIN(c[i], darkest);
        }
        return (average/3.0f + darkest) / 2.0f;
    }
}

- (CGFloat) lightestChannel
{
    if (!self.isRGB) return 0.0f;
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    if (self.isMonochrome) {
        return c[0];
    } else {
        
        CGFloat value = 0.0f;
        for (NSUInteger i = 0; i < 3; i++) {
            value = MAX(c[i], value);
        }
        return value;
    }
}

- (CGFloat) darkestChannel
{
    if (!self.isRGB) return 0.0f;
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    if (self.isMonochrome) {
        return c[0];
    } else {
        
        CGFloat value = 1.0f;
        for (NSUInteger i = 0; i < 3; i++) {
            value = MIN(c[i], value);
        }
        return value;
    }
}

- (NSUInteger) grayValue
{
    return ((NSUInteger)(self.gray * 255));
}

- (NSUInteger) grayWeightedLightValue
{
    return ((NSUInteger)(self.grayWeightedLight * 255));
}

- (NSUInteger) grayWeightedDarkValue
{
    return ((NSUInteger)(self.grayWeightedDark * 255));
}

- (NSUInteger) lightestChannelValue
{
    return ((NSUInteger)(self.lightestChannel * 255));
}

- (NSUInteger) darkestChannelValue
{
    return ((NSUInteger)(self.darkestChannel * 255));
}

@end

@implementation UIColor (IDLHSL)

+ (UIColor *)randomColorWithSaturation:(CGFloat)saturation lightness:(CGFloat)lightness
{
    return [self randomColorWithSaturation:saturation lightness:lightness alpha:1.0f];
}

+ (UIColor *)randomColorWithSaturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha
{
    return [self colorWithHue:randf() saturation:saturation lightness:lightness alpha:alpha];
}

+ (UIColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha
{
    return [[self alloc] initWithHue:hue saturation:saturation lightness:lightness alpha:alpha];
}

#pragma mark HSL -> HSB conversion derived from http://en.wikipedia.org/wiki/HSL_and_HSV

- (UIColor *)initWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha
{
    lightness *= 2.0f;
    if (lightness <= 1.0f) {
        saturation *= lightness;
    } else {
        saturation *= 2.0f - lightness;
    }
    CGFloat hsbBrightness = (lightness + saturation) / 2.0f;
    CGFloat hsbSaturation = (2.0 * saturation) / (lightness + saturation);
    //
    return [self initWithHue:hue saturation:hsbSaturation brightness:hsbBrightness alpha:alpha];
}

@end

@implementation UIColor (IDLHSB)

+ (UIColor *)randomColorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness
{
    return [self randomColorWithSaturation:saturation brightness:brightness alpha:1.0f];
}

+ (UIColor *)randomColorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha
{
    return [self colorWithHue:randf() saturation:saturation brightness:brightness alpha:alpha];
}

@end

@implementation UIColor (IDLArithmetic)

#pragma mark - Stolen From https://github.com/ars/uicolor-utilities/

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
    
	CGFloat r,g,b,a;
    
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			a = components[1];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			a = components[3];
			break;
		default:	// We don't know how to handle this model
			return NO;
	}
    
	if (red) *red = r;
	if (green) *green = g;
	if (blue) *blue = b;
	if (alpha) *alpha = a;
    
	return YES;
}

- (UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert([self isRGB], @"Must be a RGB color to use arithmatic operations");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [UIColor colorWithRed:MAX(0.0, MIN(1.0, r * red))
						   green:MAX(0.0, MIN(1.0, g * green))
							blue:MAX(0.0, MIN(1.0, b * blue))
						   alpha:MAX(0.0, MIN(1.0, a * alpha))];
}

- (UIColor *)colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert([self isRGB], @"Must be a RGB color to use arithmatic operations");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [UIColor colorWithRed:MAX(0.0, MIN(1.0, r + red))
						   green:MAX(0.0, MIN(1.0, g + green))
							blue:MAX(0.0, MIN(1.0, b + blue))
						   alpha:MAX(0.0, MIN(1.0, a + alpha))];
}

- (UIColor *)colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert([self isRGB], @"Must be a RGB color to use arithmatic operations");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [UIColor colorWithRed:MAX(r, red)
						   green:MAX(g, green)
							blue:MAX(b, blue)
						   alpha:MAX(a, alpha)];
}

- (UIColor *)colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	NSAssert([self isRGB], @"Must be a RGB color to use arithmatic operations");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [UIColor colorWithRed:MIN(r, red)
						   green:MIN(g, green)
							blue:MIN(b, blue)
						   alpha:MIN(a, alpha)];
}

- (UIColor *)colorByMultiplyingBy:(CGFloat)f {
	return [self colorByMultiplyingByRed:f green:f blue:f alpha:1.0f];
}

- (UIColor *)colorByAdding:(CGFloat)f {
	return [self colorByMultiplyingByRed:f green:f blue:f alpha:0.0f];
}

- (UIColor *)colorByLighteningTo:(CGFloat)f {
	return [self colorByLighteningToRed:f green:f blue:f alpha:0.0f];
}

- (UIColor *)colorByDarkeningTo:(CGFloat)f {
	return [self colorByDarkeningToRed:f green:f blue:f alpha:1.0f];
}

- (UIColor *)colorByMultiplyingByColor:(UIColor *)color {
	NSAssert([self isRGB], @"Must be a RGB color to use arithmatic operations");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [self colorByMultiplyingByRed:r green:g blue:b alpha:1.0f];
}

- (UIColor *)colorByAddingColor:(UIColor *)color {
	NSAssert([self isRGB], @"Must be a RGB color to use arithmatic operations");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [self colorByAddingRed:r green:g blue:b alpha:0.0f];
}

- (UIColor *)colorByLighteningToColor:(UIColor *)color {
	NSAssert([self isRGB], @"Must be a RGB color to use arithmatic operations");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [self colorByLighteningToRed:r green:g blue:b alpha:0.0f];
}

- (UIColor *)colorByDarkeningToColor:(UIColor *)color {
	NSAssert([self isRGB], @"Must be a RGB color to use arithmatic operations");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
	return [self colorByDarkeningToRed:r green:g blue:b alpha:1.0f];
}

- (UIColor *)colorByBlendingWithColor:(UIColor *)color position:(CGFloat)position
{
    if (color == nil || !self.isRGB || !color.isRGB) return self;
    
    CGFloat r1,g1,b1,a1;
    CGFloat r2,g2,b2,a2;
    
    [self red:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color red:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    UIColor *blend = [UIColor colorWithRed:POSITION(r1, r2, position)
                                     green:POSITION(g1, g2, position)
                                      blue:POSITION(b1, b2, position)
                                     alpha:POSITION(a1, a2, position)];
    /*
    IDLLogFloat(position);
    IDLLogObject(self);
    IDLLogObject(color);
    IDLLogContext(@"%f, %f, %f, %f",r2,g2,b2,a2);
    IDLLogObject(blend);
    //*/
    return blend;
}

- (UIColor *)colorWithHue:(CGFloat)hue isOffset:(BOOL)offset
{
    CGFloat h,s,b,a;
    
    if (![self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return nil;
    } else {
        if (offset) hue = h + hue;
        return [UIColor colorWithHue:hue saturation:s brightness:b alpha:a];
    }
}

- (UIColor *)colorWithSaturation:(CGFloat)saturation isOffset:(BOOL)offset
{
    CGFloat h,s,b,a;
    
    if (![self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return nil;
    } else {
        if (offset) saturation = s + saturation;
        saturation = RANGE(0.0f, saturation, 1.0f);
        return [UIColor colorWithHue:h saturation:saturation brightness:b alpha:a];
    }
}

- (UIColor *)colorWithBrightness:(CGFloat)brightness isOffset:(BOOL)offset
{
    CGFloat h,s,b,a;
    
    if (![self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return nil;
    } else {
        if (offset) brightness = b + brightness;
        brightness = RANGE(0.0f, brightness, 1.0f);
        return [UIColor colorWithHue:h saturation:s brightness:brightness alpha:a];
    }
}

- (UIColor *)colorWithHueOffset:(CGFloat)hue
               saturationOffset:(CGFloat)saturation
               brightnessOffset:(CGFloat)brightness
{
    CGFloat h,s,b,a;
    
    if (![self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return nil;
    } else {
        hue = h + hue;
        saturation = RANGE(0.0f, saturation + s, 1.0f);
        brightness = RANGE(0.0f, brightness + b, 1.0f);
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:a];
    }
}

- (UIColor *)       colorWithHue:(CGFloat)hue
{
    return [self colorWithHue:hue isOffset:NO];
}

- (UIColor *)colorWithSaturation:(CGFloat)saturation
{
    return [self colorWithSaturation:saturation isOffset:NO];
}

- (UIColor *)colorWithBrightness:(CGFloat)brightness
{
    return [self colorWithBrightness:brightness isOffset:NO];
}

- (UIColor *)       colorWithHueOffset:(CGFloat)hue
{
    return [self colorWithHue:hue isOffset:YES];
}

- (UIColor *)colorWithSaturationOffset:(CGFloat)saturation
{
    return [self colorWithSaturation:saturation isOffset:YES];
}

- (UIColor *)colorWithBrightnessOffset:(CGFloat)brightness
{
    return [self colorWithBrightness:brightness isOffset:YES];
}


@end
