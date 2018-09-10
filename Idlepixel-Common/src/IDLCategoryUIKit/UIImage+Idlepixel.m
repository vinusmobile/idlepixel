//
//  UIImage+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "UIImage+Idlepixel.h"
#import "NSData+Idlepixel.h"
#import "NSDictionary+Idlepixel.h"
#import "UIDevice+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "NSArray+Idlepixel.h"
#import "IDLCGInlineExtensions.h"
#import "NSCharacterSet+Idlepixel.h"
#import "NSString+Idlepixel.h"

CGFloat const IDLImageGradientDirectionVerticalFromTop          = M_PI_2;
CGFloat const IDLImageGradientDirectionVerticalFromBottom       = -M_PI_2;
CGFloat const IDLImageGradientDirectionHorizontalFromLeft       = M_PI;
CGFloat const IDLImageGradientDirectionHorizontalFromRight      = 0.0f;
CGSize  const IDLImageGradientDefaultImageSize                  = {.width = 48.0f, .height = 48.0f};

@implementation IDLImageTint : NSObject

+(IDLImageTint *)image:(UIImage *)image tint:(UIColor *)tint
{
    return [[self alloc] initWithImage:image tint:tint];
}

-(id)initWithImage:(UIImage *)image tint:(UIColor *)tint
{
    self = [self init];
    if (self) {
        self.image = image;
        self.tint = tint;
    }
    return self;
}

-(UIImage *)imageWithTint
{
    if (self.image != nil && self.tint != nil) {
        return [self.image imageWithTint:self.tint];
    } else {
        return self.image;
    }
}

@end

@implementation UIImage (IDLScaling)

- (UIImage *)imageScaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageWithScale:(CGFloat)scale
{
    if (self.CGImage) {
        return [UIImage imageWithCGImage:self.CGImage scale:scale orientation:self.imageOrientation];
    } else if (self.CIImage) {
        return [UIImage imageWithCIImage:self.CIImage scale:scale orientation:self.imageOrientation];
    } else {
        return self;
    }
}

@end

@implementation UIImage (IDLCrop)

- (UIImage *)imageByCropping:(CGRect)rect
{
    CGFloat scale = self.scale;
    
    if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored || self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored) {
        rect = CGRectSwapXY(rect);
    }
    
    rect = CGRectMake(rect.origin.x * scale,
                      rect.origin.y * scale,
                      rect.size.width * scale,
                      rect.size.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return result;
}

@end

@implementation UIImage (IDLBounds)

-(CGRect)bounds
{
    return CGRectMakeWithPointAndSize(CGPointZero, self.size);
}

@end

@implementation UIImage (IDLResizable)

+ (UIImage *)resizableImageNamed:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)resizableImageNamed:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
}

@end

@implementation UIImage (IDLDataSize)

- (uint64_t)dataSize
{
    CGImageRef img = self.CGImage;
    size_t bytesPerRow = CGImageGetBytesPerRow(img);
    size_t imageHeight = CGImageGetHeight(img);
    return bytesPerRow * imageHeight;
}

@end

@implementation UIImage (IDLImageData)

+ (UIImage *)imageWithImageData:(IDLImageData *)imageData
{
    return [imageData UIImage];
}

- (IDLImageData *)imageData
{
    return [IDLImageData dataWithImage:self];
}

@end

@implementation UIImage (IDLLaunchImage)

+ (UIImage *)launchImage
{
    return [self launchImageForOrientation:[[UIDevice currentDevice] orientation]];
}

#define kImageRetinaSuffix      @"@2x"

+ (UIImage *)launchImageForOrientation:(UIDeviceOrientation)orientation
{
    NSString *baseName = [[[NSBundle mainBundle] infoDictionary] stringForKey:@"UILaunchImageFile"];
    UIDevice *device = [UIDevice currentDevice];
    
    if (!baseName) baseName = @"Default";
    
    NSArray *orientationModifiers = @[];
    NSArray *heightModifiers = @[];
    NSArray *scaleModifiers = nil;
    
    if (device.screenScale == 2.0f) {
        scaleModifiers = @[kImageRetinaSuffix,@""];
    } else {
        scaleModifiers = @[@"",kImageRetinaSuffix];
    }
    
    if (device.screenIsWide) heightModifiers = @[[NSString stringWithFormat:@"-%ih",(int)floor(device.screenSize.height)]];
    
    if (orientationModifiers.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        if (orientation == UIDeviceOrientationLandscapeLeft) {
            orientationModifiers = [orientationModifiers arrayByAddingObject:@"-LandscapeLeft"];
        } else if (orientation == UIDeviceOrientationLandscapeRight) {
            orientationModifiers = [orientationModifiers arrayByAddingObject:@"-LandscapeRight"];
        } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
            orientationModifiers = [orientationModifiers arrayByAddingObject:@"-PortraitUpsideDown"];
        }
        if (UIDeviceOrientationIsLandscape(orientation)) {
            orientationModifiers = @[@"-Landscape"];
        } else if (UIDeviceOrientationIsPortrait(orientation)) {
            orientationModifiers = @[@"-Portrait"];
        } else {
            orientationModifiers = @[];
        }
    }
    NSArray *sequences = [NSArray sequencesDerivedFromArrayOfArrays:@[baseName, heightModifiers, orientationModifiers, scaleModifiers]];
    
    UIImage *image = nil;
    NSString *imageName = nil;
    for (NSArray *sequence in sequences) {
        imageName = [sequence componentsJoinedByString:@""];
        image = [UIImage imageNamed:imageName];
        if (image != nil) {
            if ([imageName hasSuffix:kImageRetinaSuffix] && image.scale != 2.0f) {
                image = [image imageWithScale:2.0f];
            }
            break;
        }
    }
    
    return image;
}

@end

@implementation UIImage (IDLCompositeImage)

+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray
{
    return [self compositeImageFromImageArray:imageArray blendMode:kCGBlendModeNormal];
}

+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray ignoreTints:(BOOL)ignoreTints
{
    return [self compositeImageFromImageArray:imageArray blendMode:kCGBlendModeNormal ignoreTints:ignoreTints];
}

+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendMode:(CGBlendMode)blendMode
{
    return [self compositeImageFromImageArray:imageArray blendMode:blendMode ignoreTints:NO];
}

+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendAlpha:(CGFloat)blendAlpha
{
    return [self compositeImageFromImageArray:imageArray blendAlpha:blendAlpha ignoreTints:NO];
}

+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendAlpha:(CGFloat)blendAlpha ignoreTints:(BOOL)ignoreTints
{
    return [self compositeImageFromImageArray:imageArray blendMode:kCGBlendModeNormal blendAlpha:blendAlpha ignoreTints:ignoreTints];
}

+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendMode:(CGBlendMode)blendMode ignoreTints:(BOOL)ignoreTints
{
    return [self compositeImageFromImageArray:imageArray blendMode:blendMode blendAlpha:1.0f ignoreTints:ignoreTints];
}

+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendMode:(CGBlendMode)blendMode blendAlpha:(CGFloat)blendAlpha ignoreTints:(BOOL)ignoreTints
{
    return [self compositeImageFromImageArray:imageArray blendMode:blendMode baseAlpha:1.0f blendAlpha:blendAlpha ignoreTints:ignoreTints];
}

+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendMode:(CGBlendMode)blendMode baseAlpha:(CGFloat)baseAlpha blendAlpha:(CGFloat)blendAlpha ignoreTints:(BOOL)ignoreTints
{
    if (imageArray.count == 0) {
        return nil;
        
    } else {
        UIImage *image = UIImageFromImageObject(imageArray.firstObject, ignoreTints);;
        
        if (imageArray.count == 1) {
            return image;
            
        } else if (image != nil) {
            
            baseAlpha = RANGE(0.0f, baseAlpha, 1.0f);
            blendAlpha = RANGE(0.0f, blendAlpha, 10.0f);
            
            NSObject *imageItem = nil;
            
            CGFloat scale = image.scale;
            CGRect bounds = image.bounds;
            
            UIGraphicsBeginImageContextWithOptions(bounds.size, NO, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextTranslateCTM(context, 0.0f, bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            CGContextSetAlpha(context, baseAlpha);
            CGContextSetBlendMode(context, kCGBlendModeNormal);
            
            for (imageItem in imageArray) {
                
                image = UIImageFromImageObject(imageItem, ignoreTints);
                
                if (image != nil) {
                    CGContextDrawImage(context, bounds, image.CGImage);
                    CGContextSetAlpha(context, blendAlpha);
                    CGContextSetBlendMode(context, blendMode);
                }
            }
            
            UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return resultImage;
        } else {
            return nil;
        }
    }
}

- (UIImage *)imageOverlayedByImage:(UIImage *)overlayImage
{
    return [self imageOverlayedByImage:overlayImage blendMode:kCGBlendModeNormal];
}

- (UIImage *)imageOverlayedByImage:(UIImage *)overlayImage blendMode:(CGBlendMode)blendMode
{
    if (overlayImage != nil) {
        return [self imageOverlayedByImages:@[overlayImage] blendMode:blendMode];
    } else {
        return self;
    }
}

- (UIImage *)imageOverlayedByImages:(NSArray *)overlayImageArray
{
    return [self imageOverlayedByImages:overlayImageArray blendMode:kCGBlendModeNormal];
}

- (UIImage *)imageOverlayedByImages:(NSArray *)overlayImageArray blendMode:(CGBlendMode)blendMode
{
    if (overlayImageArray.count > 0) {
        overlayImageArray = [@[self] arrayByAddingObjectsFromArray:overlayImageArray];
        return [[self class] compositeImageFromImageArray:overlayImageArray blendMode:blendMode];
    } else {
        return self;
    }
}

+ (UIImage *)blendedImage:(UIImage *)firstImage secondImage:(UIImage *)secondImage blendPosition:(CGFloat)blendPosition
{
    blendPosition = RANGE(0.0f, blendPosition, 1.0f);
    if (firstImage == nil || blendPosition == 1.0f) {
        return secondImage;
    } else if (secondImage == nil || blendPosition == 0.0f) {
        return firstImage;
    } else {
        return [UIImage compositeImageFromImageArray:@[firstImage, secondImage] blendMode:kCGBlendModeNormal baseAlpha:(1.0f - blendPosition) blendAlpha:blendPosition ignoreTints:YES];
    }
}

- (UIImage *)imageBlendedWithSecondImage:(UIImage *)secondImage blendPosition:(CGFloat)blendPosition
{
    return [UIImage blendedImage:self secondImage:secondImage blendPosition:blendPosition];
}

@end

@implementation UIImage (IDLMaskedImage)

- (UIImage *)imageMaskedByImage:(UIImage *)maskImage
{
    CGFloat scale = self.scale;
    CGRect bounds = self.bounds;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0f, bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextClipToMask(context, bounds, maskImage.CGImage);
    CGContextDrawImage(context, bounds, self.CGImage);
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end

@implementation UIImage (IDLImageWithColor)

/*
 * Adapted from http://ioscodesnippet.tumblr.com/
 */

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:IDLImageGradientDefaultImageSize];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)aSize
{
    CGRect rect = CGRectMake(0.0f, 0.0f, aSize.width, aSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretchableImageWithLeftCapWidth:1.0f topCapHeight:1.0f];
}

+ (UIImage *)imageWithGradient:(NSArray *)colors angle:(CGFloat)angle
{
    return [self imageWithGradient:colors angle:angle size:IDLImageGradientDefaultImageSize];
}

+ (UIImage *)imageWithGradient:(NSArray *)colors angle:(CGFloat)angle locations:(NSArray *)locations
{
    return [self imageWithGradient:colors angle:angle locations:locations size:IDLImageGradientDefaultImageSize];
}

+ (UIImage *)imageWithGradient:(NSArray *)colors angle:(CGFloat)angle size:(CGSize)aSize
{
    return [self imageWithGradient:colors angle:angle locations:nil size:aSize];
}

+ (UIImage *)imageWithGradient:(NSArray *)colors angle:(CGFloat)angle locations:(NSArray *)locations size:(CGSize)aSize
{
    CGRect bounds = CGRectMakeWithPointAndSize(CGPointZero, aSize);
    CGPoint center = CGRectCenter(bounds);
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    if (angle == IDLImageGradientDirectionVerticalFromTop) {
        startPoint = CGPointMake(center.x, CGRectGetMinY(bounds));
        endPoint = CGPointMake(center.x, CGRectGetMaxY(bounds));
    } else if (angle == IDLImageGradientDirectionVerticalFromBottom) {
        startPoint = CGPointMake(center.x, CGRectGetMaxY(bounds));
        endPoint = CGPointMake(center.x, CGRectGetMinY(bounds));
    } else if (angle == IDLImageGradientDirectionHorizontalFromLeft) {
        startPoint = CGPointMake(CGRectGetMinX(bounds), center.y);
        endPoint = CGPointMake(CGRectGetMaxX(bounds), center.y);
    } else if (angle == IDLImageGradientDirectionHorizontalFromRight) {
        startPoint = CGPointMake(CGRectGetMaxX(bounds), center.y);
        endPoint = CGPointMake(CGRectGetMinX(bounds), center.y);
    } else {
        CGFloat radius = CGRectGetRadius(bounds);
        startPoint = CGPointMakeWithOffsetAngleAndLength(center, angle, radius);
        endPoint = CGPointMakeWithOffsetAngleAndLength(center, (angle + M_PI), radius);
    }
    
    return [self imageWithGradient:colors startPoint:startPoint endPoint:endPoint locations:locations size:aSize];
}

+ (UIImage *)imageWithGradient:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    return [self imageWithGradient:colors startPoint:startPoint endPoint:endPoint locations:nil size:IDLImageGradientDefaultImageSize];
}

+ (UIImage *)imageWithGradient:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint size:(CGSize)aSize
{
    return [self imageWithGradient:colors startPoint:startPoint endPoint:endPoint locations:nil size:aSize];
}

+ (UIImage *)imageWithGradient:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)locations size:(CGSize)aSize
{
    if (colors.count == 0) {
        return nil;
    } else if (colors.count == 1) {
        colors = [colors arrayByAddingObject:colors.firstObject];
    }
    
    CGFloat floatLocations[colors.count];
    NSMutableArray *cgColors;
    NSInteger i;
    
    if (locations == nil) {
        cgColors = [NSMutableArray arrayWithCapacity:colors.count];
        for (i = 0; i < colors.count; i++) {
            floatLocations[i] = (CGFloat)i/((CGFloat)(colors.count-1));
        }
    } else if (colors.count != locations.count) {
        return nil;
    } else {
        cgColors = [NSMutableArray arrayWithCapacity:colors.count];
        for (i = 0; i < colors.count; i++) {
            floatLocations[i] = [(NSNumber *)[locations objectAtIndex:i] floatValue];
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    for (i = 0; i < colors.count; i++) {
        if ([[colors objectAtIndex:i] isKindOfClass:[UIColor class]]) {
            [cgColors addObject:(__bridge id)[(UIColor *)[colors objectAtIndex:i] CGColor]];
        } else {
            [cgColors addObject:[colors objectAtIndex:i]];
        }
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)cgColors, floatLocations);
    
    CGFloat scale = [UIDevice currentDevice].screenScale;
    CGRect bounds = CGRectMakeWithPointAndSize(CGPointZero, aSize);
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end

@implementation UIImage (IDLImageWithTint)

+ (UIImage *)imageNamed:(NSString *)imageName tint:(UIColor *)tint
{
    return [[self imageNamed:imageName] imageWithTint:tint];
}

- (UIImage *)imageWithTint:(UIColor *)tint
{
    if (tint == nil) {
        return self;
    } else {
        return [self imageWithGradientTint:@[tint] angle:0.0f];
    }
}

- (UIImage *)imageWithGradientTint:(NSArray *)colors angle:(CGFloat)angle
{
    return [self imageWithGradientTint:colors angle:angle locations:nil];
}

- (UIImage *)imageWithGradientTint:(NSArray *)colors angle:(CGFloat)angle locations:(NSArray *)locations
{
    UIImage *gradient = [UIImage imageWithGradient:colors angle:angle locations:locations size:self.size];
    
    return [gradient imageMaskedByImage:self];
}

- (UIImage *)imageWithGradientTint:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    return [self imageWithGradientTint:colors startPoint:startPoint endPoint:endPoint locations:nil];
}

- (UIImage *)imageWithGradientTint:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)locations
{
    UIImage *gradient = [UIImage imageWithGradient:colors startPoint:startPoint endPoint:endPoint locations:locations size:self.size];
    
    return [gradient imageMaskedByImage:self];
}

@end

@implementation UIImage (IDLImageSequence)

+ (NSArray *)imageSequenceWithFirstName:(NSString *)imageName
{
    if (imageName == nil) return nil;
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (image != nil) {
        
        NSMutableArray *sequence = [NSMutableArray arrayWithObject:image];
        
        NSRange digitRange = [imageName rangeOfCharacterFromSet:[NSCharacterSet digitCharacterSet] options:(NSBackwardsSearch | NSAnchoredSearch)];
        
        if (digitRange.location != NSNotFound) {
            
            NSInteger digitCounter = [[imageName substringWithRange:digitRange] integerValue];
            NSString *prefix = [imageName substringToIndex:digitRange.location];
            
            NSString *formatString;
            NSInteger currentDigitLength;
            
            do {
                
                digitCounter++;
                
                currentDigitLength = floor((CGFloat)digitCounter/10.0f) + 1;
                
                if (currentDigitLength < digitRange.length) {
                    formatString = [NSString stringWithFormat:@"%%@%%0%ui",(unsigned int)(digitRange.length - currentDigitLength)];
                } else {
                    formatString = @"%@%i";
                }
                
                NSString *nextImageName = [NSString stringWithFormat:formatString,prefix,digitCounter];
                
                image = [UIImage imageNamed:nextImageName];
                
                if (image != nil) [sequence addObject:image];
                
            } while (image != nil);
        }
        
        return [NSArray arrayWithArray:sequence];
    }
    return nil;
}

@end

