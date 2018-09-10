//
//  UIImage+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "IDLImageData.h"

extern CGFloat const IDLImageGradientDirectionVerticalFromTop;
extern CGFloat const IDLImageGradientDirectionVerticalFromBottom;
extern CGFloat const IDLImageGradientDirectionHorizontalFromLeft;
extern CGFloat const IDLImageGradientDirectionHorizontalFromRight;
extern CGSize  const IDLImageGradientDefaultImageSize;

@interface IDLImageTint : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *tint;

+(IDLImageTint *)image:(UIImage *)image tint:(UIColor *)tint;
-(id)initWithImage:(UIImage *)image tint:(UIColor *)tint;

-(UIImage *)imageWithTint;

@end

NS_INLINE UIImage *UIImageFromImageObject(NSObject *imageObject, BOOL ignoreTint)
{
    UIImage *image = nil;
    if ([imageObject isKindOfClass:[IDLImageTint class]]) {
        if (ignoreTint) {
            image = [(IDLImageTint *)imageObject image];
        } else {
            image = [(IDLImageTint *)imageObject imageWithTint];
        }
    } else if ([imageObject isKindOfClass:[UIImage class]]) {
        image = (UIImage *)imageObject;
    }
    return image;
}

@interface UIImage (IDLScaling)

- (UIImage *)imageScaledToSize:(CGSize)newSize;

- (UIImage *)imageWithScale:(CGFloat)scale;

@end

@interface UIImage (IDLCrop)

- (UIImage *)imageByCropping:(CGRect)rect;

@end

@interface UIImage (IDLBounds)

@property (nonatomic, readonly) CGRect bounds;

@end

@interface UIImage (IDLResizable)

+ (UIImage *)resizableImageNamed:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets NS_AVAILABLE_IOS(5_0);
+ (UIImage *)resizableImageNamed:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode NS_AVAILABLE_IOS(6_0);

@end

@interface UIImage (IDLDataSize)

- (uint64_t)dataSize;

@end

@interface UIImage (IDLImageData)

+ (UIImage *)imageWithImageData:(IDLImageData *)imageData;

- (IDLImageData *)imageData;

@end

@interface UIImage (IDLLaunchImage)

+ (UIImage *)launchImage;
+ (UIImage *)launchImageForOrientation:(UIDeviceOrientation)orientation;

@end

@interface UIImage (IDLCompositeImage)

+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray;
+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendAlpha:(CGFloat)blendAlpha;
+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray ignoreTints:(BOOL)ignoreTints;
+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendAlpha:(CGFloat)blendAlpha ignoreTints:(BOOL)ignoreTints;
+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendMode:(CGBlendMode)blendMode;
+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendMode:(CGBlendMode)blendMode ignoreTints:(BOOL)ignoreTints;
+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendMode:(CGBlendMode)blendMode blendAlpha:(CGFloat)blendAlpha ignoreTints:(BOOL)ignoreTints;
+ (UIImage *)compositeImageFromImageArray:(NSArray *)imageArray blendMode:(CGBlendMode)blendMode baseAlpha:(CGFloat)baseAlpha blendAlpha:(CGFloat)blendAlpha ignoreTints:(BOOL)ignoreTints;

- (UIImage *)imageOverlayedByImage:(UIImage *)overlayImage;
- (UIImage *)imageOverlayedByImage:(UIImage *)overlayImage blendMode:(CGBlendMode)blendMode;
- (UIImage *)imageOverlayedByImages:(NSArray *)overlayImageArray;
- (UIImage *)imageOverlayedByImages:(NSArray *)overlayImageArray blendMode:(CGBlendMode)blendMode;

+ (UIImage *)blendedImage:(UIImage *)firstImage secondImage:(UIImage *)secondImage blendPosition:(CGFloat)blendPosition;
- (UIImage *)imageBlendedWithSecondImage:(UIImage *)secondImage blendPosition:(CGFloat)blendPosition;

@end

@interface UIImage (IDLMaskedImage)

- (UIImage *)imageMaskedByImage:(UIImage *)maskImage;

@end

@interface UIImage (IDLImageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)aSize;

+ (UIImage *)imageWithGradient:(NSArray *)colors angle:(CGFloat)angle;
+ (UIImage *)imageWithGradient:(NSArray *)colors angle:(CGFloat)angle size:(CGSize)aSize;
+ (UIImage *)imageWithGradient:(NSArray *)colors angle:(CGFloat)angle locations:(NSArray *)locations;
+ (UIImage *)imageWithGradient:(NSArray *)colors angle:(CGFloat)angle locations:(NSArray *)locations size:(CGSize)aSize;

+ (UIImage *)imageWithGradient:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
+ (UIImage *)imageWithGradient:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint size:(CGSize)aSize;
+ (UIImage *)imageWithGradient:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)locations size:(CGSize)aSize;

@end

@interface UIImage (IDLImageWithTint)

+ (UIImage *)imageNamed:(NSString *)imageName tint:(UIColor *)tint;

- (UIImage *)imageWithTint:(UIColor *)tint;

- (UIImage *)imageWithGradientTint:(NSArray *)colors angle:(CGFloat)angle;
- (UIImage *)imageWithGradientTint:(NSArray *)colors angle:(CGFloat)angle locations:(NSArray *)locations;

- (UIImage *)imageWithGradientTint:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
- (UIImage *)imageWithGradientTint:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)locations;

@end

@interface UIImage (IDLImageSequence)

+ (NSArray *)imageSequenceWithFirstName:(NSString *)imageName;

@end

NS_INLINE UIImage *UIImageNamed(NSString *imageName)
{
    if (imageName) {
        return [UIImage imageNamed:imageName];
    } else {
        return nil;
    }
}

NS_INLINE UIImage *UIImageNamedTint(NSString *imageName, UIColor *imageTint)
{
    if (imageName) {
        return [UIImage imageNamed:imageName tint:imageTint];
    } else {
        return nil;
    }
}

NS_INLINE NSArray *UIImageSequence(NSString *imageName)
{
    return [UIImage imageSequenceWithFirstName:imageName];
}

