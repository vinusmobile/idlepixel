//
//  UIColor+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_INLINE UIColor *UIColorFromNSData(NSData *colorData)
{
    NSObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    if ([object isKindOfClass:[UIColor class]]) {
        return (UIColor *)object;
    } else {
        return nil;
    }
}

NS_INLINE NSData *NSDataFromUIColor(UIColor *color)
{
    return [NSKeyedArchiver archivedDataWithRootObject:color];
}

// built in colors

#define UIColorClear    [UIColor clearColor]
#define UIColorWhite    [UIColor whiteColor]
#define UIColorBlack    [UIColor blackColor]
#define UIColorRed      [UIColor redColor]
#define UIColorBlue     [UIColor blueColor]
#define UIColorGreen    [UIColor greenColor]
#define UIColorYellow   [UIColor yellowColor]
#define UIColorOrange   [UIColor orangeColor]
#define UIColorPurple   [UIColor purpleColor]

@interface UIColor (IDLData)

+ (UIColor*) colorWithData:(NSData *)colorData;
@property (readonly) NSData *data;

@end

@interface UIColor (IDLWebRGB)

+ (UIColor*) colorWithHTMLString:(NSString *)htmlString;
+ (UIColor*) colorWithCSSString:(NSString *)htmlString;
+ (UIColor*) colorWithString:(NSString *)colorString;

- (NSString*) htmlString;
- (NSString*) hexString;

@end

NS_INLINE UIColor *UIColorFromString(NSString *string)
{
    return [UIColor colorWithString:string];
}

@interface UIColor (IDLHexRGB)

+ (UIColor*) colorWithRGB:(NSUInteger)rgb;
+ (UIColor*) colorWithRGBA:(NSUInteger)rgba;
+ (UIColor*) colorWithARGB:(NSUInteger)argb;

+ (UIColor*) colorWithHexGray:(NSUInteger)gray;
+ (UIColor*) colorWithHexGray:(NSUInteger)gray alpha:(NSUInteger)alpha;

+ (UIColor*) colorWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;
+ (UIColor*) colorWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(NSUInteger)alpha;

@property (readonly) CGFloat red;
@property (readonly) CGFloat green;
@property (readonly) CGFloat blue;
@property (readonly) CGFloat alpha;

@property (readonly) NSUInteger rgbValue;
@property (readonly) NSUInteger rgbaValue;
@property (readonly) NSUInteger argbValue;

@property (readonly) CGColorSpaceModel colorSpaceModel;
@property (readonly) BOOL isRGB;
@property (readonly) BOOL isMonochrome;

#pragma mark - Stolen from https://github.com/ars/uicolor-utilities/

@end

@interface UIColor (IDLGrayScale)

@property (readonly) CGFloat gray;
@property (readonly) CGFloat grayWeightedLight;
@property (readonly) CGFloat grayWeightedDark;
@property (readonly) CGFloat lightestChannel;
@property (readonly) CGFloat darkestChannel;

@property (readonly) NSUInteger grayValue;
@property (readonly) NSUInteger grayWeightedLightValue;
@property (readonly) NSUInteger grayWeightedDarkValue;
@property (readonly) NSUInteger lightestChannelValue;
@property (readonly) NSUInteger darkestChannelValue;

@end

@interface UIColor (IDLHSL)

+ (UIColor *)randomColorWithSaturation:(CGFloat)saturation lightness:(CGFloat)lightness;
+ (UIColor *)randomColorWithSaturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha;
- (UIColor *)initWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha;

@end

NS_INLINE UIColor *UIColorRandomHue(CGFloat saturation, CGFloat lightness)
{
    return [UIColor randomColorWithSaturation:saturation lightness:lightness];
}

@interface UIColor (IDLHSB)

+ (UIColor *)randomColorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness;
+ (UIColor *)randomColorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha;

@end

@interface UIColor (IDLArithmetic)

- (UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)       colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *) colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)  colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)colorByMultiplyingBy:(CGFloat)f;
- (UIColor *)       colorByAdding:(CGFloat)f;
- (UIColor *) colorByLighteningTo:(CGFloat)f;
- (UIColor *)  colorByDarkeningTo:(CGFloat)f;

- (UIColor *)colorByMultiplyingByColor:(UIColor *)color;
- (UIColor *)       colorByAddingColor:(UIColor *)color;
- (UIColor *) colorByLighteningToColor:(UIColor *)color;
- (UIColor *)  colorByDarkeningToColor:(UIColor *)color;

- (UIColor *)colorByBlendingWithColor:(UIColor *)color position:(CGFloat)position;

- (UIColor *)       colorWithHue:(CGFloat)hue;
- (UIColor *)colorWithSaturation:(CGFloat)saturation;
- (UIColor *)colorWithBrightness:(CGFloat)brightness;

- (UIColor *)       colorWithHueOffset:(CGFloat)hue;
- (UIColor *)colorWithSaturationOffset:(CGFloat)saturation;
- (UIColor *)colorWithBrightnessOffset:(CGFloat)brightness;

- (UIColor *)       colorWithHueOffset:(CGFloat)hue
                      saturationOffset:(CGFloat)saturation
                      brightnessOffset:(CGFloat)brightness;

@end

NS_INLINE UIColor *UIColorAlternatingHue(UIColor *baseColor, CGFloat variation, NSInteger index)
{
    if ((index % 2)) {
        return [baseColor colorWithHueOffset:variation];
    } else {
        return baseColor;
    }
}

NS_INLINE UIColor *UIColorAlternatingSaturation(UIColor *baseColor, CGFloat variation, NSInteger index)
{
    if ((index % 2)) {
        return [baseColor colorWithSaturationOffset:variation];
    } else {
        return baseColor;
    }
}

NS_INLINE UIColor *UIColorAlternatingBrightness(UIColor *baseColor, CGFloat variation, NSInteger index)
{
    if ((index % 2)) {
        return [baseColor colorWithBrightnessOffset:variation];
    } else {
        return baseColor;
    }
}

NS_INLINE UIColor *UIColorHexGray(NSUInteger hexGray)
{
    hexGray = MIN(255, hexGray);
    return [UIColor colorWithHexGray:hexGray];
}

NS_INLINE UIColor *UIColorHexRGB(NSUInteger hexRGB)
{
    return [UIColor colorWithRGB:hexRGB];
}

